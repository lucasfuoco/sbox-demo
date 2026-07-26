using Sandbox.Components;
using Sandbox.Components.SingletonComponents;

namespace Sandbox;

/// <summary>
/// Soft billboard cloud particles that fill a weather volume box.
/// </summary>
sealed class WorldCloudEffect
{
	const string FrameKey = "cloud_frame";
	const string WindTurbulenceKey = "cloud_wind_turb";
	const string AlphaKey = "cloud_alpha";
	const float WindDriftMin = 6f;
	const float WindDriftMax = 28f;

	readonly ParticleEffect _effect;
	readonly ParticleBoxEmitter _emitter;
	readonly ParticleSpriteRenderer _renderer;
	int _lastFrame = -1;
	float _fadeInSeconds = 30f;
	float _fadeOutSeconds = 45f;
	float _systemFade;
	Color _cloudTint = Color.White;
	float _cloudAlpha = 0.45f;
	float _coverageFade = 1f;
	float _displayAlpha = 0.45f;
	int _maxParticles = 8000;
	float _coverageDensity;
	float _coverageTime;
	Vector3 _coverageWind;
	Vector3 _windVelocity;
	Vector3 _particleWindVelocity;
	float _windTurbulence;
	bool _simulateLocal;
	float _lightResponse = 1f;
	Color _lightTint = Color.White;
	Color _skyAmbient = Color.White;
	Vector3 _sunHorizontal = Vector3.Forward;
	Vector3 _emissionCenter;
	float _sunSideStrength = 0.35f;
	float _lightningFlash;
	float _lastPushedLightningFlash = -1f;
	WeatherLightningFlash[] _lightningFlashes = Array.Empty<WeatherLightningFlash>();
	bool _hasLightningFlashes;

	public GameObject Root { get; }

	WorldCloudEffect(
		GameObject root,
		ParticleEffect effect,
		ParticleBoxEmitter emitter,
		ParticleSpriteRenderer renderer )
	{
		Root = root;
		_effect = effect;
		_emitter = emitter;
		_renderer = renderer;
	}

	public static WorldCloudEffect Create( GameObject parent, Sprite sprite )
	{
		var root = new GameObject( true, "CloudVolume" );
		root.Tags.Add( "particles" );
		root.Flags |= GameObjectFlags.NotSaved;
		root.SetParent( parent );

		var effect = root.Components.Create<ParticleEffect>();
		var emitter = root.Components.Create<ParticleBoxEmitter>();
		var renderer = root.Components.Create<ParticleSpriteRenderer>();

		if ( sprite.IsValid() )
			renderer.Sprite = sprite;

		var frameCount = GetSpriteFrameCount( sprite );

		var cloudEffect = new WorldCloudEffect( root, effect, emitter, renderer );
		cloudEffect.ConfigureRenderer( renderer );
		cloudEffect.ConfigureEffect( effect, frameCount );
		ConfigureEmitter( emitter );

		return cloudEffect;
	}

	public void Update(
		Vector3 emissionCenter,
		Vector3 emissionSize,
		Vector3 localEmissionCenter,
		Vector3 coverageSamplePosition,
		float cloudDensity,
		Vector3 windDirection,
		float windStrength,
		float timeSeconds,
		float scaleMinMultiplier = 0.35f,
		float scaleMaxMultiplier = 1.85f,
		float scaleMultiplier = 1f,
		float cloudAmountMultiplier = 1f,
		float deltaTime = 0f,
		float fadeInSeconds = 30f,
		Color targetCloudTint = default,
		float colorTransitionSeconds = 15f,
		bool moveWithVolume = false,
		bool castShadows = false,
		bool receiveLighting = false,
		float sunSideStrength = 0.35f,
		float lightningFlash = 0f,
		IReadOnlyList<WeatherLightningFlash> lightningFlashes = null )
	{
		_fadeInSeconds = MathF.Max( fadeInSeconds, 0.01f );
		_fadeOutSeconds = MathF.Max( _fadeInSeconds * 1.5f, 15f );
		_sunSideStrength = MathX.Clamp( sunSideStrength, 0f, 1f );
		_lightningFlash = MathX.Clamp( lightningFlash, 0f, 2f );
		CacheLightningFlashes( lightningFlashes );
		_emissionCenter = emissionCenter;

		// Soft cloud billboards with Lighting/Shadows enabled are extremely expensive at deck scale.
		_renderer.Shadows = castShadows;
		_renderer.Lighting = receiveLighting;
		_renderer.Additive = false;
		_renderer.Opaque = false;
		_renderer.FogStrength = 0.12f;

		RefreshLightResponse();

		if ( targetCloudTint == default )
			targetCloudTint = Color.White;
		else
			targetCloudTint = targetCloudTint.WithAlpha( 1f );

		if ( deltaTime <= 0.0001f )
			_cloudTint = targetCloudTint;
		else
		{
			var colorStep = colorTransitionSeconds > 0.01f
				? MathF.Min( deltaTime / colorTransitionSeconds, 1f )
				: 1f;
			_cloudTint = Color.Lerp( _cloudTint, targetCloudTint, colorStep );
		}

		var density = cloudDensity * MathF.Max( cloudAmountMultiplier, 0.1f );

		var targetCoverage = MathX.Clamp( density / 0.1f, 0f, 1f );
		if ( targetCoverage < _coverageFade )
			_coverageFade = MathF.Max( targetCoverage, _coverageFade - deltaTime / 18f );
		else if ( deltaTime <= 0.0001f )
			_coverageFade = targetCoverage;
		else
			_coverageFade = MathX.Lerp( _coverageFade, targetCoverage, MathF.Min( deltaTime / _fadeInSeconds, 1f ) );

		density *= _coverageFade;
		var active = density > 0.02f && emissionSize.x > 1f && emissionSize.y > 1f && emissionSize.z > 1f;

		if ( active )
		{
			if ( Game.IsPlaying )
				_systemFade = MathF.Min( _systemFade + deltaTime / _fadeInSeconds, 1f );
			else
				_systemFade = 1f;
		}
		else
			_systemFade = 0f;

		Root.Enabled = active;

		if ( !active )
		{
			_emitter.Rate = 0f;
			if ( _coverageFade <= 0.01f )
				_systemFade = 0f;

			return;
		}

		var fade = Game.IsPlaying ? SmoothStep( _systemFade ) : 1f;

		if ( !Game.IsPlaying )
			_cloudTint = targetCloudTint;

		// Keep the emitter glued to the volume (top band) in local space.
		_simulateLocal = moveWithVolume && Root.Parent.IsValid();
		_effect.ForceSpace = _simulateLocal
			? ParticleEffect.SimulationSpace.Local
			: ParticleEffect.SimulationSpace.World;

		if ( Root.Parent.IsValid() )
		{
			Root.LocalPosition = localEmissionCenter;
			Root.LocalRotation = Rotation.Identity;
		}
		else
		{
			Root.WorldPosition = emissionCenter;
		}

		_emitter.Size = emissionSize;

		var horizontalSpan = MathF.Max( emissionSize.x, emissionSize.y );
		var spanRoot = MathF.Sqrt( horizontalSpan );
		var scaleSpan = MathF.Min( horizontalSpan, 32768f );
		var typicalScale = MathX.Clamp( MathF.Pow( scaleSpan, 0.72f ) * 0.45f, 800f, 5500f );
		// Keep puff size from dwarfing a thin top band and reading as a filled volume.
		var bandScaleCap = MathF.Max( emissionSize.z * 1.35f, 1200f );
		typicalScale = MathF.Min( typicalScale, bandScaleCap );

		var wind = windDirection.WithZ( 0f );
		if ( wind.LengthSquared <= 0.0001f )
			wind = Vector3.Forward;
		else
			wind = wind.Normal;

		var baseDrift = MathX.Lerp( WindDriftMin, WindDriftMax, windStrength );
		var driftSpeed = baseDrift * (typicalScale / 350f );
		_windVelocity = wind * driftSpeed;
		_windTurbulence = MathF.Max( driftSpeed * 0.08f, 6f );
		_particleWindVelocity = _simulateLocal && Root.Parent.IsValid()
			? Root.Parent.Transform.World.Rotation.Inverse * _windVelocity
			: _windVelocity;

		var driftSpread = MathF.Max( driftSpeed * 0.08f, 6f );
		var spreadVelocity = _particleWindVelocity;
		// Drive wind on the particle system so OnParticleStep does not rewrite velocity.
		_effect.ConstantMovement = new ParticleVector3
		{
			X = MakeRange( spreadVelocity.x - driftSpread, spreadVelocity.x + driftSpread ),
			Y = MakeRange( spreadVelocity.y - driftSpread, spreadVelocity.y + driftSpread ),
			Z = MakeRange( -3f, 10f ),
		};

		var maxParticles = Math.Clamp( (int)(density * spanRoot * 2.2f), 200, 2800 );
		if ( MathF.Abs( maxParticles - _maxParticles ) > _maxParticles * 0.1f )
		{
			_maxParticles = maxParticles;
			_effect.MaxParticles = maxParticles;
		}

		_emitter.Rate = density * MathX.Clamp( spanRoot * 0.08f, 25f, 350f ) * fade;

		_coverageDensity = density;
		_coverageTime = timeSeconds;
		_coverageWind = windDirection;

		var patch = WorldAmbientCloudCoverage.Sample(
			coverageSamplePosition.x,
			coverageSamplePosition.y,
			timeSeconds,
			windDirection,
			density );
		var clearSky = WeatherCloudPalette.IsClearSkyTint( _cloudTint );
		var targetAlpha = clearSky
			? MathX.Clamp( 0.58f + density * 0.28f + patch * 0.06f, 0.52f, 0.96f ) * fade
			: MathX.Clamp( 0.32f + density * 0.35f + patch * 0.12f, 0.25f, 0.85f ) * fade;

		if ( deltaTime <= 0.0001f )
			_displayAlpha = targetAlpha;
		else
			_displayAlpha = MathX.Lerp( _displayAlpha, targetAlpha, MathF.Min( deltaTime / 2.5f, 1f ) );

		_cloudAlpha = _displayAlpha;
		_effect.Tint = Color.White;

		var flashTint = _cloudTint;
		_effect.Gradient = MakeColor( flashTint.WithAlpha( _displayAlpha ) );

		var baseBrightness = clearSky
			? Game.IsPlaying
				? MathX.Lerp( 1.25f, 1.55f, fade )
				: 1.55f
			: Game.IsPlaying
				? (0.95f + density * 0.25f) * (0.65f + fade * 0.35f )
				: 1.05f + density * 0.1f;
		// Keep system brightness stable — lightning brightening is per-sprite via flash influence.
		_effect.Brightness = baseBrightness;

		if ( _effect.ApplyColor )
		{
			_effect.ApplyColor = false;
			_effect.ApplyAlpha = false;
		}

		// Lightning must push colors immediately (slow tint lerp would hide the flash).
		var wantsLightningColors = !Game.IsPlaying || _hasLightningFlashes || _lightningFlash > 0.01f;
		if ( wantsLightningColors && MathF.Abs( _lightningFlash - _lastPushedLightningFlash ) > 0.02f )
		{
			_lastPushedLightningFlash = _lightningFlash;
			RefreshParticleColors( editorPreview: !Game.IsPlaying );
		}
		else if ( !Game.IsPlaying )
		{
			RefreshParticleColors( editorPreview: true );
		}

		_renderer.Scale = MathF.Max( scaleMultiplier, 1f );

		GetSpriteScaleRange(
			horizontalSpan,
			density,
			scaleMinMultiplier,
			scaleMaxMultiplier,
			scaleMultiplier,
			bandScaleCap,
			out var scaleMin,
			out var scaleMax );
		_effect.Scale = MakeRange( scaleMin, scaleMax );
	}

	static void GetSpriteScaleRange(
		float horizontalSpan,
		float cloudDensity,
		float scaleMinMultiplier,
		float scaleMaxMultiplier,
		float scaleMultiplier,
		float maxBaseScale,
		out float scaleMin,
		out float scaleMax )
	{
		var scaleSpan = MathF.Min( horizontalSpan, 32768f );
		var baseScale = MathX.Clamp( MathF.Pow( scaleSpan, 0.72f ) * 0.45f, 800f, 5500f );
		baseScale = MathF.Min( baseScale, maxBaseScale );
		var densityScale = 0.85f + cloudDensity * 0.35f;
		baseScale *= densityScale * MathF.Max( scaleMultiplier, 0.1f );

		scaleMin = baseScale * MathF.Max( scaleMinMultiplier, 0.1f );
		scaleMax = baseScale * MathF.Max( scaleMaxMultiplier, scaleMinMultiplier + 0.05f );
	}

	void ConfigureRenderer( ParticleSpriteRenderer renderer )
	{
		renderer.Additive = false;
		renderer.Lighting = false;
		renderer.Shadows = false;
		renderer.Opaque = false;
		renderer.MotionBlur = false;
		renderer.FogStrength = 0.12f;
	}

	void ConfigureEffect( ParticleEffect effect, int spriteFrameCount )
	{
		effect.MaxParticles = 2800;
		effect.PreWarm = 0f;
		effect.Lifetime = MakeRange( 120f, 300f );
		effect.ApplyAlpha = false;
		effect.ApplyColor = false;
		effect.ApplyShape = true;
		effect.ApplyRotation = true;
		effect.Force = false;
		effect.Damping = 0f;
		effect.ForceSpace = ParticleEffect.SimulationSpace.World;
		effect.StartVelocity = MakeConstant( 0f );
		effect.Scale = MakeRange( 800f, 4500f );
		effect.Brightness = 1.1f;
		effect.Gradient = MakeColor( Color.White.WithAlpha( 0.45f ) );

		_lastFrame = spriteFrameCount - 1;
		if ( _lastFrame < 1 )
			return;

		effect.SheetSequence = true;
		effect.SnapToFrame = true;
		effect.SequenceSpeed = MakeConstant( 0f );

		effect.OnParticleCreated = OnParticleCreated;
		effect.OnStep = OnParticleStep;
	}

	void OnParticleCreated( Particle particle )
	{
		var frame = Game.Random.Int( 0, _lastFrame );
		particle.Set( FrameKey, frame );
		particle.Set( WindTurbulenceKey, Random.Shared.VectorInSphere() * _windTurbulence * 0.35f );

		var patch = WorldAmbientCloudCoverage.Sample(
			particle.Position.x,
			particle.Position.y,
			_coverageTime,
			_coverageWind,
			_coverageDensity );
		var clearSky = WeatherCloudPalette.IsClearSkyTint( _cloudTint );
		var baseAlpha = clearSky
			? MathX.Clamp( 0.58f + _coverageDensity * 0.28f + patch * 0.06f, 0.52f, 0.96f )
			: MathX.Clamp( 0.32f + _coverageDensity * 0.35f + patch * 0.12f, 0.25f, 0.85f );
		particle.Set( AlphaKey, baseAlpha );

		ApplyParticleFrame( particle, frame );
		ApplyParticleColor( particle, editorPreview: !Game.IsPlaying );
	}

	void OnParticleStep( Particle particle, float delta )
	{
		// Wind is ConstantMovement. Frames are sticky after create.
		// Only rewrite tint for lifetime fade / lightning response.
		ApplyParticleColor( particle );
	}

	void ApplyParticleColor( Particle particle, bool editorPreview = false )
	{
		var baseAlpha = particle.Get<float>( AlphaKey );
		float alpha;

		if ( editorPreview )
		{
			alpha = baseAlpha * _displayAlpha;
		}
		else
		{
			var fadeIn = MathX.Clamp( particle.Age / _fadeInSeconds, 0f, 1f );
			var fadeOut = MathX.Clamp( particle.LifeTimeRemaining / _fadeOutSeconds, 0f, 1f );
			alpha = SmoothStep( fadeIn ) * SmoothStep( fadeOut ) * baseAlpha;
		}

		// Keep alpha moderate — denser alpha + shadows was crushing FPS.
		particle.Color = GetParticleTint( particle ).WithAlpha( alpha );
	}

	void RefreshLightResponse()
	{
		var time = 12f;
		var overcast = 0f;
		var rain = 0f;
		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() )
		{
			time = world.TimeOfDay;
			if ( world.Weather.IsValid() )
			{
				overcast = world.Weather.OvercastAmount;
				rain = world.Weather.RainAmount;
			}
		}

		var sun = WorldAtmospherePalette.GetSunLightIntensity( time );
		var moon = WorldAtmospherePalette.GetMoonLightIntensity( time );
		_lightResponse = MathX.Clamp( 0.3f + sun * 0.95f + moon * 0.4f, 0.28f, 1.35f );

		var sunColor = WorldAtmospherePalette.GetSunDiscColor( time, overcast, rain );
		var moonColor = new Color( 0.72f, 0.8f, 1f );
		var lightMix = sun + moon;
		_lightTint = lightMix <= 0.001f
			? moonColor
			: Color.Lerp( moonColor, sunColor, sun / lightMix );
		// Keep clouds readable — blend lighting color into white.
		var warmAmount = MathX.Clamp( sun * 0.65f + WorldAtmospherePalette.GetDaylight( time ) * 0.2f, 0f, 0.75f );
		_lightTint = Color.Lerp( Color.White, _lightTint, warmAmount );

		var sunDir = WorldAtmospherePalette.GetSunSkyDirection( time );
		var horizontal = sunDir.WithZ( 0f );
		_sunHorizontal = horizontal.LengthSquared > 0.0001f ? horizontal.Normal : Vector3.Forward;

		var daylight = WorldAtmospherePalette.GetDaylight( time );
		_skyAmbient = Color.Lerp( new Color( 0.55f, 0.62f, 0.85f ), new Color( 1f, 1f, 1.05f ), daylight );
		_skyAmbient = Color.Lerp( _skyAmbient, new Color( 0.75f, 0.78f, 0.82f ), overcast * 0.45f );
	}

	Color GetParticleTint( Particle particle )
	{
		var tint = WeatherCloudPalette.IsClearSkyTint( _cloudTint ) ? WeatherCloudPalette.ClearSkyCloud : _cloudTint;
		tint *= _lightResponse;
		tint *= Color.Lerp( Color.White, _lightTint, 0.55f );
		tint *= Color.Lerp( Color.White, _skyAmbient, 0.28f );

		if ( _sunSideStrength > 0.01f )
		{
			var offset = (particle.Position - _emissionCenter).WithZ( 0f );
			if ( offset.LengthSquared > 1f )
			{
				// Lit toward the sun, slightly cooler/darker away from it.
				var side = Vector3.Dot( offset.Normal, _sunHorizontal );
				var shade = MathX.Lerp( 1f - _sunSideStrength * 0.55f, 1f + _sunSideStrength * 0.4f, side * 0.5f + 0.5f );
				tint *= shade;
			}
		}

		tint = ApplyLightningToColor( tint, ResolveParticleWorldPosition( particle ) );
		return tint.WithAlpha( 1f );
	}

	void CacheLightningFlashes( IReadOnlyList<WeatherLightningFlash> flashes )
	{
		if ( flashes is null || flashes.Count == 0 )
		{
			_lightningFlashes = Array.Empty<WeatherLightningFlash>();
			_hasLightningFlashes = false;
			return;
		}

		if ( _lightningFlashes.Length != flashes.Count )
			_lightningFlashes = new WeatherLightningFlash[flashes.Count];

		for ( var i = 0; i < flashes.Count; i++ )
			_lightningFlashes[i] = flashes[i];

		_hasLightningFlashes = true;
	}

	Vector3 ResolveParticleWorldPosition( Particle particle )
	{
		if ( _simulateLocal && Root.IsValid() )
			return Root.WorldTransform.PointToWorld( particle.Position );

		return particle.Position;
	}

	Color ApplyLightningToColor( Color tint, Vector3 worldPosition )
	{
		// Whole cloud deck washes light blue for the flash; near the bolt gets a bit brighter.
		var amount = _lightningFlash;

		if ( _hasLightningFlashes )
		{
			foreach ( var flash in _lightningFlashes )
			{
				amount = MathF.Max( amount, flash.Intensity );
				amount = MathF.Max( amount, flash.GetInfluence( worldPosition ) * 1.15f );
			}
		}

		if ( amount <= 0.01f )
			return tint;

		var lightBlue = new Color( 0.62f, 0.82f, 1.12f );
		amount = MathX.Clamp( amount, 0f, 1.5f );
		var blend = MathX.Clamp( amount * 1.15f, 0f, 1f );
		var lit = Color.Lerp( tint, lightBlue, blend );
		return lit * (1f + amount * 2.4f);
	}

	Color ApplyLightningToColor( Color tint ) => ApplyLightningToColor( tint, _emissionCenter );

	void RefreshParticleColors( bool editorPreview )
	{
		foreach ( var particle in _effect.Particles )
			ApplyParticleColor( particle, editorPreview );
	}

	static void ApplyParticleFrame( Particle particle, int frame )
	{
		particle.Frame = frame;
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

	static void ConfigureEmitter( ParticleBoxEmitter emitter )
	{
		emitter.Loop = true;
		emitter.Duration = 99999f;
		emitter.Delay = 0f;
		emitter.Rate = 0f;
	}

	static ParticleFloat MakeRange( float min, float max ) => new( min, max );

	static ParticleFloat MakeConstant( float value ) => new( value, value );

	static ParticleGradient MakeColor( Color color ) => new()
	{
		Type = ParticleGradient.ValueType.Constant,
		ConstantValue = color,
	};

	static float SmoothStep( float t )
	{
		t = MathX.Clamp( t, 0f, 1f );
		return t * t * (3f - 2f * t);
	}
}

static class WorldCloudEffectExtensions
{
	public static bool IsValid( this WorldCloudEffect effect ) => effect?.Root.IsValid() == true;
}
