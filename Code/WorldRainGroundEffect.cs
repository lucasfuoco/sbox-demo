namespace Sandbox;

using Sandbox.Components.SingletonComponents;
using Sandbox.Controllers;

/// <summary>
/// Camera-local ground splashes and surface-aware rain impact audio.
/// </summary>
sealed class WorldRainGroundEffect
{
	/// <summary>Play splash from the first impact frame through the end of the sheet.</summary>
	const int SplashStartFrame = 0;

	enum RainSurface
	{
		Grass,
		Sand,
		Rock,
		Water,
	}

	readonly Scene _scene;
	readonly ParticleEffect _effect;
	readonly ParticleBoxEmitter _emitter;
	readonly ParticleSpriteRenderer _renderer;
	readonly SoundEvent _fallbackImpact;
	readonly SoundEvent _sandImpact;
	readonly SoundEvent _grassImpact;
	readonly SoundEvent _rockImpact;
	readonly SoundEvent _waterImpact;
	readonly int _lastFrame;

	TimeSince _sinceSplashTrace;
	TimeSince _sinceImpactSound;
	Vector3 _groundCenter;
	bool _hasGround;
	float _amount;
	WorldManagerSingletonComponent _terrain;

	public GameObject Root { get; }

	WorldRainGroundEffect(
		Scene scene,
		GameObject root,
		ParticleEffect effect,
		ParticleBoxEmitter emitter,
		ParticleSpriteRenderer renderer,
		SoundEvent fallbackImpact,
		SoundEvent sandImpact,
		SoundEvent grassImpact,
		SoundEvent rockImpact,
		SoundEvent waterImpact,
		int lastFrame )
	{
		_scene = scene;
		Root = root;
		_effect = effect;
		_emitter = emitter;
		_renderer = renderer;
		_fallbackImpact = fallbackImpact;
		_sandImpact = sandImpact;
		_grassImpact = grassImpact;
		_rockImpact = rockImpact;
		_waterImpact = waterImpact;
		_lastFrame = lastFrame;
	}

	public static WorldRainGroundEffect Create( GameObject parent, Scene scene )
	{
		var root = new GameObject( true, "RainGround" );
		root.Tags.Add( "particles" );
		root.Flags |= GameObjectFlags.NotSaved;
		root.SetParent( parent );

		var effect = root.Components.Create<ParticleEffect>();
		var emitter = root.Components.Create<ParticleBoxEmitter>();
		var renderer = root.Components.Create<ParticleSpriteRenderer>();

		var sprite = ResourceLibrary.Get<Sprite>( "sprites/rain_splash.sprite" );
		renderer.Sprite = sprite;
		renderer.Additive = true;
		renderer.Lighting = false;
		renderer.Shadows = false;
		renderer.FaceVelocity = false;
		renderer.Opaque = false;
		renderer.Scale = 1f;
		renderer.FogStrength = 0.1f;

		var frameCount = GetSpriteFrameCount( sprite );
		var lastFrame = Math.Max( frameCount - 1, SplashStartFrame );

		effect.MaxParticles = 280;
		effect.PreWarm = 0.15f;
		effect.Lifetime = MakeRange( 0.28f, 0.55f );
		effect.ApplyAlpha = true;
		effect.ApplyColor = true;
		effect.ApplyShape = true;
		effect.ApplyRotation = true;
		effect.Force = true;
		effect.ForceDirection = Vector3.Down;
		effect.ForceScale = MakeConstant( 400f );
		effect.ForceSpace = ParticleEffect.SimulationSpace.World;
		effect.Damping = MakeConstant( 2.5f );
		effect.Scale = MakeRange( 8f, 28f );
		effect.StartVelocity = MakeConstant( 0f );
		effect.Brightness = 1.6f;
		effect.Gradient = new ParticleGradient
		{
			Type = ParticleGradient.ValueType.Constant,
			ConstantValue = new Color( 0.85f, 0.92f, 1f, 0.75f ),
		};
		effect.Collision = false;

		if ( lastFrame > SplashStartFrame )
		{
			effect.SheetSequence = true;
			effect.SnapToFrame = true;
			effect.SequenceSpeed = MakeConstant( 0f );
		}

		emitter.Loop = true;
		emitter.Duration = 99999f;
		emitter.Delay = 0f;
		emitter.Rate = MakeConstant( 0f );
		emitter.Size = new Vector3( 1800f, 1800f, 40f );

		var fallback = ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_impact.sound" );
		var sand = ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_impact_sand.sound" ) ?? fallback;
		var grass = ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_impact_grass.sound" ) ?? fallback;
		var rock = ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_impact_rock.sound" ) ?? fallback;
		var water = ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_impact_water.sound" ) ?? fallback;

		var ground = new WorldRainGroundEffect(
			scene,
			root,
			effect,
			emitter,
			renderer,
			fallback,
			sand,
			grass,
			rock,
			water,
			lastFrame );

		if ( lastFrame > SplashStartFrame )
		{
			effect.OnParticleCreated = ground.OnParticleCreated;
			effect.OnStep = ground.OnParticleStep;
		}

		return ground;
	}

	void OnParticleCreated( Particle particle )
	{
		particle.Frame = SplashStartFrame;
	}

	void OnParticleStep( Particle particle, float delta )
	{
		if ( _lastFrame <= SplashStartFrame )
			return;

		var life = MathF.Max( particle.Age + particle.LifeTimeRemaining, 0.001f );
		var t = MathX.Clamp( particle.Age / life, 0f, 1f );
		var frame = SplashStartFrame + (int)(t * (_lastFrame - SplashStartFrame));
		particle.Frame = Math.Clamp( frame, SplashStartFrame, _lastFrame );
	}

	public void Update(
		Vector3 listener,
		float amount,
		float splashRadius,
		bool enableSplashes,
		bool enableAudio,
		float audioVolume )
	{
		amount = MathX.Clamp( amount, 0f, 1.5f );
		_amount = amount;

		var wantsAudio = enableAudio && HasAnyImpactSound();
		var active = amount > 0.05f && (enableSplashes || wantsAudio);
		Root.Enabled = active && enableSplashes;

		if ( !active )
		{
			_emitter.Rate = MakeConstant( 0f );
			_hasGround = false;
			return;
		}

		if ( _sinceSplashTrace > 0.2f )
		{
			_sinceSplashTrace = 0f;
			SampleGround( listener, splashRadius );
		}

		if ( enableSplashes && _hasGround )
		{
			Root.WorldPosition = _groundCenter + Vector3.Up * 8f;
			Root.WorldRotation = Rotation.Identity;
			_emitter.Size = new Vector3( splashRadius * 1.25f, splashRadius * 1.25f, 28f );

			var burstUp = MathX.Lerp( 60f, 160f, MathX.Clamp( amount, 0f, 1f ) );
			_effect.ConstantMovement = new ParticleVector3
			{
				X = MakeRange( -burstUp * 0.3f, burstUp * 0.3f ),
				Y = MakeRange( -burstUp * 0.3f, burstUp * 0.3f ),
				Z = MakeRange( burstUp * 0.25f, burstUp * 0.75f ),
			};
			_effect.MaxParticles = Math.Clamp( (int)(amount * 220f), 40, 280 );
			_emitter.Rate = MakeConstant( amount * 90f );
			_renderer.Scale = MathX.Lerp( 0.7f, 1.05f, MathX.Clamp( amount, 0f, 1f ) );
		}
		else
		{
			_emitter.Rate = MakeConstant( 0f );
		}

		if ( wantsAudio )
			PlayImpactAudio( listener, audioVolume );
	}

	bool HasAnyImpactSound() =>
		_sandImpact is not null
		|| _grassImpact is not null
		|| _rockImpact is not null
		|| _waterImpact is not null
		|| _fallbackImpact is not null;

	void SampleGround( Vector3 listener, float splashRadius )
	{
		var best = 0;
		var sum = Vector3.Zero;

		for ( var i = 0; i < 3; i++ )
		{
			var angle = (i / 3f) * MathF.PI * 2f + Game.Random.Float( 0f, 0.4f );
			var radial = splashRadius * (0.25f + i * 0.22f);
			var offset = new Vector3( MathF.Cos( angle ) * radial, MathF.Sin( angle ) * radial, 0f );
			var origin = listener + offset + Vector3.Up * 250f;
			var tr = _scene.Trace.Ray( origin, origin + Vector3.Down * 4000f )
				.WithoutTags( "trigger", "player", "ragdoll", "particles", "water", "weather_volume" )
				.Run();

			if ( !tr.Hit )
				continue;

			// Skip steep walls — want ground / roofs the rain lands on.
			if ( tr.Normal.z < 0.35f )
				continue;

			sum += tr.HitPosition;
			best++;
		}

		if ( best <= 0 )
		{
			_hasGround = false;
			return;
		}

		_groundCenter = sum / best;
		_hasGround = true;
	}

	void PlayImpactAudio( Vector3 listener, float volumeScale )
	{
		// Sparse in light rain, dense in strong rain (amount ~0.2 light → ~1.2+ strong).
		var rainT = MathX.Clamp( _amount / 1.25f, 0f, 1f );
		var rateT = rainT * rainT;
		var interval = MathX.Lerp( 0.55f, 0.018f, rateT );
		if ( _sinceImpactSound < interval )
			return;

		_sinceImpactSound = 0f;

		var angle = Game.Random.Float( 0f, MathF.PI * 2f );
		var dist = Game.Random.Float( 80f, 650f );
		var offset = new Vector3( MathF.Cos( angle ) * dist, MathF.Sin( angle ) * dist, 0f );
		var pos = _hasGround
			? _groundCenter + offset.WithZ( 4f )
			: listener + offset.WithZ( -32f );

		EnsureTerrain();
		var surface = ResolveSurface( pos );
		var sound = ResolveImpactSound( surface );
		if ( sound is null )
			return;

		// Place water hits on the ocean/calm surface when we can.
		if ( surface == RainSurface.Water )
		{
			var waterHeight = OceanSurfaceController.GetWaterHeightAt( _scene, pos );
			if ( waterHeight > float.MinValue * 0.5f )
				pos = pos.WithZ( waterHeight + 2f );
			else if ( _terrain.IsValid() )
				pos = pos.WithZ( _terrain.GetHeight( pos.x, pos.y ) + 2f );
		}
		else if ( _terrain.IsValid() )
		{
			pos = pos.WithZ( _terrain.GetHeight( pos.x, pos.y ) + 4f );
		}

		if ( Sound.Play( sound, pos ) is not { } handle )
			return;

		handle.Volume = MathX.Clamp( volumeScale * MathX.Lerp( 0.08f, 0.22f, rainT ), 0f, 1f );
		handle.Pitch = Game.Random.Float( 0.9f, 1.15f );
	}

	void EnsureTerrain()
	{
		if ( _terrain.IsValid() )
			return;

		_terrain = WorldManagerSingletonComponent.Instance
			?? _scene?.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
	}

	RainSurface ResolveSurface( Vector3 position )
	{
		EnsureTerrain();

		var oceanHeight = OceanSurfaceController.GetWaterHeightAt( _scene, position );
		if ( oceanHeight > float.MinValue * 0.5f )
		{
			var ground = _terrain.IsValid() ? _terrain.GetHeight( position.x, position.y ) : position.z;
			if ( ground <= oceanHeight + 16f )
				return RainSurface.Water;
		}

		if ( !_terrain.IsValid() )
			return RainSurface.Grass;

		var sample = WorldAmbientTerrainSample.Sample( _terrain, position.x, position.y );
		if ( sample.Water >= 0.45f || sample.Shore >= 0.85f && sample.Sand < 0.35f )
			return RainSurface.Water;

		if ( sample.Sand >= sample.Grass && sample.Sand >= sample.Rock )
			return RainSurface.Sand;

		if ( sample.Rock >= sample.Grass )
			return RainSurface.Rock;

		return RainSurface.Grass;
	}

	SoundEvent ResolveImpactSound( RainSurface surface ) => surface switch
	{
		RainSurface.Sand => _sandImpact ?? _fallbackImpact ?? _grassImpact,
		RainSurface.Rock => _rockImpact ?? _fallbackImpact ?? _grassImpact,
		RainSurface.Water => _waterImpact ?? _fallbackImpact ?? _grassImpact,
		_ => _grassImpact ?? _fallbackImpact ?? _sandImpact,
	};

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
}

static class WorldRainGroundEffectValidation
{
	public static bool IsValid( this WorldRainGroundEffect effect ) => effect?.Root.IsValid() == true;
}
