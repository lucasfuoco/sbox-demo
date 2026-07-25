namespace Sandbox;

using Sandbox.Components.SingletonComponents;
using Sandbox.Controllers;

/// <summary>
/// Rain / snow particle effect used by weather volumes and global precipitation.
/// Surface clipping uses a cheap camera-local height grid instead of per-drop physics.
/// </summary>
sealed class WorldPrecipitationEffect
{
	const int ClipGridSize = 7;
	const float ClipCellSize = 420f;
	const float ClipProbeUp = 900f;
	const float ClipProbeDown = 60000f;
	const string FrameKey = "rain_frame";

	enum Kind
	{
		Rain,
		Snow,
	}

	readonly Kind _kind;
	readonly ParticleEffect _effect;
	readonly ParticleBoxEmitter _emitter;
	readonly ParticleSpriteRenderer _renderer;
	readonly float[] _clipHeights = new float[ClipGridSize * ClipGridSize];
	readonly int _lastFrame;

	Vector3 _emitterSize = new( 3600f, 3600f, 1600f );
	Vector3 _clipOrigin;
	float _configuredLife = -1f;
	bool _configured;
	bool _clipToSurfaces;
	bool _clipGridReady;
	int _clipCellCursor;
	float _clipCeiling = float.MaxValue;
	WorldManagerSingletonComponent _terrain;
	int _stepBucket;

	public GameObject Root { get; }

	WorldPrecipitationEffect(
		GameObject root,
		ParticleEffect effect,
		ParticleBoxEmitter emitter,
		ParticleSpriteRenderer renderer,
		Kind kind,
		int lastFrame )
	{
		Root = root;
		_effect = effect;
		_emitter = emitter;
		_renderer = renderer;
		_kind = kind;
		_lastFrame = lastFrame;

		for ( var i = 0; i < _clipHeights.Length; i++ )
			_clipHeights[i] = float.NegativeInfinity;
	}

	public void SetEmitterSize( Vector3 size )
	{
		_emitterSize = new Vector3(
			MathF.Max( size.x, 1f ),
			MathF.Max( size.y, 1f ),
			MathF.Max( size.z, 1f ) );
	}

	public static WorldPrecipitationEffect Create( GameObject parent, bool snow, string name = null )
	{
		var root = new GameObject( true, name ?? (snow ? "Snow" : "Rain") );
		root.Tags.Add( "particles" );
		root.Flags |= GameObjectFlags.NotSaved;
		root.SetParent( parent );

		var effect = root.Components.Create<ParticleEffect>();
		var emitter = root.Components.Create<ParticleBoxEmitter>();
		var renderer = root.Components.Create<ParticleSpriteRenderer>();

		var kind = snow ? Kind.Snow : Kind.Rain;
		var sprite = ConfigureRenderer( renderer, kind );
		var lastFrame = GetSpriteFrameCount( sprite ) - 1;
		ConfigureEffect( effect, kind, lastFrame );
		ConfigureEmitter( emitter );

		var precip = new WorldPrecipitationEffect( root, effect, emitter, renderer, kind, lastFrame );
		if ( kind == Kind.Rain )
		{
			effect.OnParticleCreated = precip.OnRainParticleCreated;
			effect.OnStep = precip.OnRainParticleStep;
		}

		return precip;
	}

	public void Update(
		Vector3 center,
		float amount,
		Vector3 windDirection,
		float windStrength,
		float temperature,
		float lifetimeSeconds = -1f,
		float fallSpeedOverride = -1f,
		bool enableCollision = false,
		float rateMultiplier = 1f,
		Vector3? clipListener = null )
	{
		amount = MathX.Clamp( amount, 0f, 1.5f );
		var active = amount > 0.02f;
		Root.Enabled = active;
		_clipToSurfaces = enableCollision && _kind == Kind.Rain && Game.IsPlaying;

		if ( !active )
		{
			_emitter.Rate = MakeConstant( 0f );
			_clipGridReady = false;
			return;
		}

		Root.WorldPosition = center;
		Root.WorldRotation = Rotation.Identity;
		_emitter.Size = _emitterSize;

		var wind = windDirection.WithZ( 0f );
		if ( wind.LengthSquared <= 0.0001f )
			wind = Vector3.Forward;
		else
			wind = wind.Normal;

		var clampedWind = MathX.Clamp( windStrength, 0f, 1f );
		var fallSpeed = fallSpeedOverride > 0f
			? fallSpeedOverride
			: _kind == Kind.Rain
				? MathX.Lerp( 1400f, 3200f, MathX.Clamp( amount, 0f, 1f ) ) + clampedWind * 400f
				: MathX.Lerp( 90f, 240f, MathX.Clamp( amount, 0f, 1f ) ) + clampedWind * 70f;

		var lean = _kind == Kind.Rain
			? MathX.Lerp( 0.18f, 0.85f, clampedWind )
			: MathX.Lerp( 0.08f, 0.45f, clampedWind );
		var fallDirection = (Vector3.Down + wind * lean).Normal;
		var fall = fallDirection * fallSpeed;
		var spread = fallSpeed * (_kind == Kind.Rain ? 0.04f : 0.06f);

		var columnLean = wind * (_emitterSize.z * lean * 0.35f);
		Root.WorldPosition = center - columnLean * 0.5f;
		Root.WorldRotation = Rotation.Identity;
		_emitter.Size = new Vector3(
			_emitterSize.x + MathF.Abs( columnLean.x ) * 0.5f,
			_emitterSize.y + MathF.Abs( columnLean.y ) * 0.5f,
			_emitterSize.z );

		// Keep cheap constant motion — no per-drop physics collision.
		_effect.Force = false;
		_effect.ForceSpace = ParticleEffect.SimulationSpace.World;
		_effect.Damping = MakeConstant( 0f );
		_effect.Collision = false;
		_effect.StartVelocity = MakeConstant( 0f );
		_effect.ConstantMovement = new ParticleVector3
		{
			X = MakeRange( fall.x - spread, fall.x + spread ),
			Y = MakeRange( fall.y - spread, fall.y + spread ),
			Z = MakeRange( fall.z * 0.96f, fall.z * 1.04f ),
		};

		if ( _clipToSurfaces )
		{
			EnsureTerrain();
			UpdateClipGrid( clipListener ?? center );
		}
		else
		{
			_clipGridReady = false;
		}

		_renderer.FaceVelocity = _kind == Kind.Rain;
		_renderer.MotionBlur = false;
		_renderer.LeadingTrail = false;
		_renderer.BlurAmount = 0f;

		var targetLife = lifetimeSeconds > 0f
			? MathX.Clamp( lifetimeSeconds, 0.5f, 20f )
			: (_kind == Kind.Rain ? 1.1f : 3.5f);

		if ( !_configured || MathF.Abs( targetLife - _configuredLife ) > 0.35f )
		{
			_effect.Lifetime = MakeRange( targetLife * 0.9f, targetLife * 1.15f );
			_effect.PreWarm = _configured ? 0f : MathF.Min( targetLife, 4f );
			_configuredLife = targetLife;
			_configured = true;
		}

		rateMultiplier = MathF.Max( rateMultiplier, 0.05f );
		// Bias density toward camera-scale shafts; don't explode for huge legacy boxes.
		var volumeScale = MathX.Clamp( _emitterSize.z / 8000f, 0.55f, 3.5f );
		var areaNorm = (_emitterSize.x * _emitterSize.y) / (14000f * 14000f);
		var areaScale = MathX.Clamp( MathF.Sqrt( MathF.Max( areaNorm, 0.01f ) ), 0.65f, 2.8f );
		var rainScale = volumeScale * areaScale * rateMultiplier;
		var clipScale = _clipToSurfaces ? 0.85f : 1f;
		_emitter.Rate = MakeConstant( _kind == Kind.Rain
			? amount * 4800f * rainScale * clipScale
			: amount * (temperature > 2f ? 500f : 1600f) * rateMultiplier );

		_effect.MaxParticles = _kind == Kind.Rain
			? Math.Clamp( (int)(amount * 6500f * rainScale * clipScale), 1400, _clipToSurfaces ? 12000 : 16000 )
			: 5000;

		_effect.Brightness = _kind == Kind.Rain
			? MathX.Lerp( 1.55f, 2.2f, MathX.Clamp( amount, 0f, 1f ) )
			: 1.5f;

		_effect.Gradient = _kind == Kind.Rain
			? MakeColor( new Color( 0.72f, 0.84f, 1f, MathX.Clamp( 0.78f + amount * 0.18f, 0.78f, 0.98f ) ) )
			: MakeColor( Color.White.WithAlpha( 0.92f ) );

		_renderer.Scale = _kind == Kind.Rain ? MathX.Lerp( 1.05f, 1.35f, MathX.Clamp( amount, 0f, 1f ) ) : 1.1f;

		_stepBucket = (_stepBucket + 1) & 3;
	}

	void EnsureTerrain()
	{
		if ( _terrain.IsValid() )
			return;

		_terrain = Root.Scene?.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
	}

	void UpdateClipGrid( Vector3 listener )
	{
		var half = (ClipGridSize - 1) * 0.5f;
		var origin = new Vector3(
			listener.x - half * ClipCellSize,
			listener.y - half * ClipCellSize,
			listener.z );

		// Rebuild origin when the camera moves far enough.
		if ( !_clipGridReady || (origin - _clipOrigin).LengthSquared > (ClipCellSize * ClipCellSize) )
		{
			_clipOrigin = origin;
			_clipCeiling = float.NegativeInfinity;
			for ( var i = 0; i < _clipHeights.Length; i++ )
				_clipHeights[i] = float.NegativeInfinity;
			_clipCellCursor = 0;
			_clipGridReady = true;
		}

		var scene = Root.Scene;
		if ( scene is null )
			return;

		// Amortize probes: a few cells per frame instead of the whole grid.
		var cellsPerFrame = 3;
		for ( var n = 0; n < cellsPerFrame; n++ )
		{
			var index = _clipCellCursor;
			_clipCellCursor = (_clipCellCursor + 1) % _clipHeights.Length;

			var gx = index % ClipGridSize;
			var gy = index / ClipGridSize;
			var sample = new Vector3(
				_clipOrigin.x + gx * ClipCellSize,
				_clipOrigin.y + gy * ClipCellSize,
				listener.z );

			var height = ProbeSurfaceHeight( scene, sample );
			_clipHeights[index] = height;
			if ( height > _clipCeiling )
				_clipCeiling = height;
		}
	}

	float ProbeSurfaceHeight( Scene scene, Vector3 sample )
	{
		var height = float.NegativeInfinity;

		if ( _terrain.IsValid() )
			height = MathF.Max( height, _terrain.GetHeight( sample.x, sample.y ) );

		var waterHeight = OceanSurfaceController.GetWaterHeightAt( scene, sample );
		if ( waterHeight > float.MinValue * 0.5f )
			height = MathF.Max( height, waterHeight );

		// One downward trace catches roofs / props the heightfield misses.
		var start = sample + Vector3.Up * ClipProbeUp;
		var tr = scene.Trace.Ray( start, start + Vector3.Down * ClipProbeDown )
			.WithoutTags( "trigger", "player", "ragdoll", "particles", "weather_volume" )
			.Run();

		if ( tr.Hit && tr.Normal.z > 0.25f )
			height = MathF.Max( height, tr.HitPosition.z );

		return height;
	}

	float SampleClipHeight( float worldX, float worldY )
	{
		var localX = (worldX - _clipOrigin.x) / ClipCellSize;
		var localY = (worldY - _clipOrigin.y) / ClipCellSize;
		var gx = (int)MathF.Floor( localX + 0.5f );
		var gy = (int)MathF.Floor( localY + 0.5f );
		gx = Math.Clamp( gx, 0, ClipGridSize - 1 );
		gy = Math.Clamp( gy, 0, ClipGridSize - 1 );
		return _clipHeights[gy * ClipGridSize + gx];
	}

	void OnRainParticleCreated( Particle particle )
	{
		if ( _lastFrame <= 0 )
			return;

		var frame = Game.Random.Int( 0, _lastFrame );
		particle.Set( FrameKey, frame );
		particle.Frame = frame;
	}

	void OnRainParticleStep( Particle particle, float delta )
	{
		if ( _lastFrame > 0 )
			particle.Frame = particle.Get<int>( FrameKey );

		if ( !_clipToSurfaces || !_clipGridReady )
			return;

		var pos = particle.Position;

		// Most of the shaft is high above the surface — skip those drops.
		if ( pos.z > _clipCeiling + 280f )
			return;

		// Stagger particle tests across frames.
		if ( ((particle.GetHashCode() & 3) != _stepBucket) )
			return;

		var height = SampleClipHeight( pos.x, pos.y );
		if ( height > float.NegativeInfinity && pos.z <= height + 18f )
			HideParticle( particle );
	}

	static void HideParticle( Particle particle )
	{
		particle.Alpha = 0f;
		particle.Size = 0f;
		particle.Velocity = Vector3.Zero;
		particle.Color = Color.Transparent;
	}

	static Sprite ConfigureRenderer( ParticleSpriteRenderer renderer, Kind kind )
	{
		var sprite = ResourceLibrary.Get<Sprite>( kind == Kind.Rain
			? "sprites/rain_drop.sprite"
			: "sprites/cloud_mist.sprite" );
		renderer.Sprite = sprite;
		renderer.Additive = kind == Kind.Rain;
		renderer.Lighting = false;
		renderer.Shadows = false;
		renderer.MotionBlur = false;
		renderer.LeadingTrail = false;
		renderer.FaceVelocity = kind == Kind.Rain;
		renderer.BlurAmount = 0f;
		renderer.Opaque = false;
		renderer.Scale = kind == Kind.Rain ? 1f : 1.25f;
		renderer.FogStrength = kind == Kind.Rain ? 0.05f : 0.15f;
		return sprite;
	}

	static void ConfigureEffect( ParticleEffect effect, Kind kind, int lastFrame )
	{
		effect.MaxParticles = kind == Kind.Rain ? 6500 : 5000;
		effect.PreWarm = 1.0f;
		effect.Lifetime = MakeRange( kind == Kind.Rain ? 0.9f : 2.5f, kind == Kind.Rain ? 1.3f : 5f );
		effect.ApplyAlpha = true;
		effect.ApplyColor = true;
		effect.ApplyShape = true;
		effect.ApplyRotation = false;
		effect.Force = false;
		effect.ForceSpace = ParticleEffect.SimulationSpace.World;
		effect.Damping = MakeConstant( 0f );
		effect.Collision = false;
		effect.Scale = kind == Kind.Rain
			? MakeRange( 10f, 24f )
			: MakeRange( 50f, 130f );
		effect.StartVelocity = MakeConstant( 0f );
		effect.Brightness = kind == Kind.Rain ? 1.5f : 1.5f;
		effect.Gradient = MakeColor( kind == Kind.Rain
			? new Color( 0.75f, 0.85f, 1f, 0.88f )
			: Color.White.WithAlpha( 0.92f ) );

		if ( kind == Kind.Rain && lastFrame > 0 )
		{
			effect.SheetSequence = true;
			effect.SnapToFrame = true;
			effect.SequenceSpeed = MakeConstant( 0f );
		}
	}

	static void ConfigureEmitter( ParticleBoxEmitter emitter )
	{
		emitter.Loop = true;
		emitter.Duration = 99999f;
		emitter.Delay = 0f;
		emitter.Rate = MakeConstant( 0f );
		emitter.Size = new Vector3( 3600f, 3600f, 1600f );
	}

	static int GetSpriteFrameCount( Sprite sprite )
	{
		if ( !sprite.IsValid() || sprite.Animations.Count == 0 )
			return 1;

		var animation = sprite.GetAnimation( 0 );
		if ( animation is null )
			return 1;

		return Math.Max( animation.Frames.Count, 1 );
	}

	static ParticleFloat MakeRange( float min, float max ) => new( min, max );

	static ParticleFloat MakeConstant( float value ) => new( value, value );

	static ParticleGradient MakeColor( Color color ) => new()
	{
		Type = ParticleGradient.ValueType.Constant,
		ConstantValue = color,
	};
}

static class WorldPrecipitationEffectValidation
{
	public static bool IsValid( this WorldPrecipitationEffect effect ) => effect?.Root.IsValid() == true;
}
