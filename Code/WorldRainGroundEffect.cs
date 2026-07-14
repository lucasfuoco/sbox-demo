namespace Sandbox;

/// <summary>
/// Camera-local ground splashes and impact audio for outdoor rain.
/// </summary>
sealed class WorldRainGroundEffect
{
	/// <summary>Play splash from the first impact frame through the end of the sheet.</summary>
	const int SplashStartFrame = 0;

	readonly Scene _scene;
	readonly ParticleEffect _effect;
	readonly ParticleBoxEmitter _emitter;
	readonly ParticleSpriteRenderer _renderer;
	readonly SoundEvent _impactSound;
	readonly int _lastFrame;

	TimeSince _sinceSplashTrace;
	TimeSince _sinceImpactSound;
	Vector3 _groundCenter;
	bool _hasGround;
	float _amount;

	public GameObject Root { get; }

	WorldRainGroundEffect(
		Scene scene,
		GameObject root,
		ParticleEffect effect,
		ParticleBoxEmitter emitter,
		ParticleSpriteRenderer renderer,
		SoundEvent impactSound,
		int lastFrame )
	{
		_scene = scene;
		Root = root;
		_effect = effect;
		_emitter = emitter;
		_renderer = renderer;
		_impactSound = impactSound;
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

		var impactSound = ResourceLibrary.Get<SoundEvent>( "sound/weather/rain_impact.sound" );
		var ground = new WorldRainGroundEffect( scene, root, effect, emitter, renderer, impactSound, lastFrame );
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

		var active = amount > 0.05f && (enableSplashes || enableAudio);
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

		if ( !_hasGround )
		{
			_emitter.Rate = MakeConstant( 0f );
			return;
		}

		if ( enableSplashes )
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

		if ( enableAudio && _impactSound is not null )
			PlayImpactAudio( listener, audioVolume );
	}

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
		var interval = MathX.Lerp( 0.35f, 0.12f, MathX.Clamp( _amount, 0f, 1f ) );
		if ( _sinceImpactSound < interval )
			return;

		_sinceImpactSound = 0f;

		var angle = Game.Random.Float( 0f, MathF.PI * 2f );
		var dist = Game.Random.Float( 120f, 700f );
		var pos = _hasGround
			? _groundCenter + new Vector3( MathF.Cos( angle ) * dist, MathF.Sin( angle ) * dist, 4f )
			: listener + new Vector3( MathF.Cos( angle ) * dist, MathF.Sin( angle ) * dist, 0f );

		if ( Sound.Play( _impactSound, pos ) is { } handle )
		{
			handle.Volume = MathX.Clamp( volumeScale * MathX.Lerp( 0.2f, 0.55f, MathX.Clamp( _amount, 0f, 1f ) ), 0f, 1f );
			handle.Pitch = Game.Random.Float( 0.9f, 1.15f );
		}
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
}

static class WorldRainGroundEffectValidation
{
	public static bool IsValid( this WorldRainGroundEffect effect ) => effect?.Root.IsValid() == true;
}
