using Sandbox.Components.SingletonComponents;

using static Sandbox.WeatherCloudPalette;

namespace Sandbox.Components;
/// <summary>
/// Client-side atmosphere rendering driven by <see cref="WorldManagerComponent"/>.
/// Rotates scene directional lights and drives the procedural sky material.
/// </summary>
[Title( "World Environment Renderer" ), Category( "World Simulation" )]
public sealed class WorldEnvironmentRendererComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" )]
	public WorldManagerComponent World { get; set; }

	[Property, Group( "Setup" ), Title( "Scene Sun" ), Description( "The scene's sun DirectionalLight. Auto-finds the Sun object if unset." )]
	public DirectionalLight Sun { get; set; }

	[Property, Group( "Setup" ), Title( "Scene Moon" ), Description( "The scene's moon DirectionalLight. Auto-finds the Moon object if unset." )]
	public DirectionalLight Moon { get; set; }

	[Property, Group( "Setup" )]
	public SkyBox2D Sky { get; set; }

	[Property, Group( "Setup" )]
	public GradientFog GradientFog { get; set; }

	[Property, Group( "Setup" )]
	public WeatherVolumeManagerComponent VolumeManager { get; set; }

	[Property, Group( "Setup" )]
	public CloudControllerComponent Clouds { get; set; }

	[Property, Group( "Setup" )]
	public EnvironmentWeatherEffectsComponent EnvironmentEffects { get; set; }

	[Property, Group( "Setup" )]
	public CameraComponent FollowCamera { get; set; }

	[Property, Group( "Precipitation" ), Title( "Follow Height" )]
	public float PrecipitationFollowHeight { get; set; } = 700f;

	[Property, Group( "Sun" ), Title( "Disc Size" ), Range( 0.4f, 3f ), Description( "Angular size of the sun disc in degrees." )]
	public float SunDiscSize { get; set; } = 1.15f;

	[Property, Group( "Sun" ), Title( "Glow Size" ), Range( 1f, 12f )]
	public float SunGlowSize { get; set; } = 4f;

	[Property, Group( "Sun" ), Title( "Glow Strength" ), Range( 0f, 2f )]
	public float SunGlowStrength { get; set; } = 1f;

	[Property, Group( "Sun Flare" ), Title( "Enable Flare" )]
	public bool EnableSunFlare { get; set; } = true;

	[Property, Group( "Sun Flare" ), Title( "Intensity" ), Range( 0f, 3f ), Description( "Overall daytime lens-flare strength multiplier." )]
	public float SunFlareIntensity { get; set; } = 1f;

	[Property, Group( "Sun Flare" ), Title( "Bloom" ), Range( 0f, 3f ), Description( "Soft glow around the sun." )]
	public float SunFlareBloom { get; set; } = 1f;

	[Property, Group( "Sun Flare" ), Title( "Streaks" ), Range( 0f, 3f ), Description( "Anamorphic cross / streak strength." )]
	public float SunFlareStreaks { get; set; } = 1f;

	[Property, Group( "Sun Flare" ), Title( "Ghosts" ), Range( 0f, 3f ), Description( "Secondary ghost discs along the sun axis." )]
	public float SunFlareGhosts { get; set; } = 1f;

	[Property, Group( "Sun Flare" ), Title( "Halo" ), Range( 0f, 3f )]
	public float SunFlareHalo { get; set; } = 1f;

	[Property, Group( "Sun Flare" ), Title( "Tint" ), Description( "Optional flare tint. Leaves dynamic sun color when unset / white." )]
	public Color SunFlareTint { get; set; } = Color.White;

	WorldPrecipitationEffect _rain;
	WorldPrecipitationEffect _snow;
	Material _skyMaterial;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	protected override void OnStart()
	{
		EnsureReferences();
		EnsureSkyMaterial();

		if ( !Sun.IsValid() )
			Log.Warning( $"{nameof( WorldEnvironmentRendererComponent )} could not find a scene DirectionalLight to use as the sun." );

		EnsurePrecipitationEffects();
	}

	protected override void OnValidate()
	{
		if ( !IsEditMode )
			return;

		EnsureReferences();
		ApplyAtmosphere();
	}

	protected override void OnUpdate()
	{
		ApplyAtmosphere();

		if ( IsEditMode )
			return;

		EnsurePrecipitationEffects();
		UpdatePrecipitation();
	}

	void EnsureReferences()
	{
		World ??= WorldManagerComponent.Instance;
		World ??= Components.Get<WorldManagerComponent>();
		World ??= Scene.GetAllComponents<WorldManagerComponent>().FirstOrDefault();

		VolumeManager ??= Components.Get<WeatherVolumeManagerComponent>();
		VolumeManager ??= Scene.GetAllComponents<WeatherVolumeManagerComponent>().FirstOrDefault();

		Clouds ??= Components.Get<CloudControllerComponent>();
		Clouds ??= Scene.GetAllComponents<CloudControllerComponent>().FirstOrDefault();

		EnvironmentEffects ??= Components.Get<EnvironmentWeatherEffectsComponent>();
		EnvironmentEffects ??= Scene.GetAllComponents<EnvironmentWeatherEffectsComponent>().FirstOrDefault();

		Sun ??= ResolveDirectionalLight( "Sun" );
		Moon ??= ResolveDirectionalLight( "Moon" );
		Sky ??= Scene.GetAllComponents<SkyBox2D>().FirstOrDefault();
		GradientFog ??= GameObject.GetOrAddComponent<GradientFog>();
	}

	void ApplyAtmosphere()
	{
		EnsureReferences();

		if ( !World.IsValid() )
			return;

		UpdateSun();
		UpdateMoon();
		UpdateSky();
		UpdateFog();
	}

	DirectionalLight ResolveDirectionalLight( string objectName )
	{
		if ( objectName.Equals( "Sun", StringComparison.OrdinalIgnoreCase ) && Sun.IsValid() )
			return Sun;

		if ( objectName.Equals( "Moon", StringComparison.OrdinalIgnoreCase ) && Moon.IsValid() )
			return Moon;

		foreach ( var light in Scene.GetAllComponents<DirectionalLight>() )
		{
			if ( !light.IsValid() )
				continue;

			if ( light.GameObject.Name.Equals( objectName, StringComparison.OrdinalIgnoreCase ) )
				return light;
		}

		return null;
	}

	void EnsureSkyMaterial()
	{
		if ( _skyMaterial.IsValid() )
			return;

		if ( !Sky.IsValid() )
			return;

		var source = Sky.SkyMaterial;
		if ( !source.IsValid() )
		{
			Log.Warning( $"{nameof( WorldEnvironmentRendererComponent )} SkyBox2D needs sky_cycle.vmat assigned." );
			return;
		}

		_skyMaterial = source.CreateCopy();
		Sky.SkyMaterial = _skyMaterial;
	}

	void UpdateSun()
	{
		if ( !Sun.IsValid() )
		{
			Sun = ResolveDirectionalLight( "Sun" );
			if ( !Sun.IsValid() )
				return;
		}

		var time = World.TimeOfDay;
		var overcast = GetCloudDensity();
		var rain = GetRainAmount();
		var temperature = GetTemperature();
		var intensity = WorldAtmospherePalette.GetSunLightIntensity( time );
		var elevation = WorldAtmospherePalette.GetSunElevationDegrees( time );

		// Same direction the sky shader uses (g_vSunDirection).
		Sun.GameObject.WorldRotation = WorldAtmospherePalette.GetSunRotation( time );

		if ( intensity <= 0.02f || elevation < -0.5f )
		{
			Sun.Enabled = false;
			Sun.LightColor = Color.Black;
			Sun.SkyColor = ApplyLightningSkyBoost( WorldAtmospherePalette.GetSkyAmbientColor( time, overcast, rain ) );
			Sun.Shadows = false;
			return;
		}

		Sun.Enabled = true;
		Sun.LightColor = ApplyLightningKeyBoost( WorldAtmospherePalette.GetSunLightColor( time, overcast, rain, temperature ) );
		Sun.SkyColor = ApplyLightningSkyBoost( WorldAtmospherePalette.GetSkyAmbientColor( time, overcast, rain ) );
		Sun.FogMode = Light.FogInfluence.Enabled;
		Sun.FogStrength = WorldAtmospherePalette.GetFogStrength( GetFogAmount(), overcast, rain );
		Sun.Shadows = intensity > 0.2f && rain < 0.85f && overcast < 0.95f;
	}

	void UpdateMoon()
	{
		if ( !Moon.IsValid() )
		{
			Moon = ResolveDirectionalLight( "Moon" );
			if ( !Moon.IsValid() )
				return;
		}

		var time = World.TimeOfDay;
		var overcast = GetCloudDensity();
		var rain = GetRainAmount();
		var intensity = WorldAtmospherePalette.GetMoonLightIntensity( time );

		Moon.GameObject.WorldRotation = WorldAtmospherePalette.GetMoonRotation( time );
		Moon.LightColor = ApplyLightningKeyBoost( WorldAtmospherePalette.GetMoonLightColor( overcast, rain ) ).WithAlpha( intensity );
		Moon.SkyColor = ApplyLightningSkyBoost( WorldAtmospherePalette.GetSkyAmbientColor( time, overcast, rain ) );
		Moon.FogMode = Light.FogInfluence.Enabled;
		Moon.FogStrength = WorldAtmospherePalette.GetFogStrength( GetFogAmount(), overcast, rain ) * 0.35f;
		Moon.Enabled = intensity > 0.03f;
		Moon.Shadows = false;
	}

	Color ApplyLightningSkyBoost( Color sky )
	{
		var flash = GetLightningFlash();
		if ( flash <= 0.01f )
			return sky;

		// Strong viewport-wide pulse so storm flashes read clearly in editor and play.
		var bolt = new Color( 0.45f, 0.72f, 1.7f );
		var amount = MathX.Clamp( flash, 0f, 1.35f );
		return Color.Lerp( sky, bolt, MathX.Clamp( amount * 1.05f, 0f, 1f ) ) * (1f + amount * 2.8f);
	}

	Color ApplyLightningKeyBoost( Color light )
	{
		var flash = GetLightningFlash();
		if ( flash <= 0.01f )
			return light;

		var bolt = new Color( 0.55f, 0.78f, 1.85f );
		var amount = MathX.Clamp( flash, 0f, 1.35f );
		return Color.Lerp( light, bolt, MathX.Clamp( amount * 0.85f, 0f, 1f ) ) * (1f + amount * 1.8f);
	}

	void UpdateFog()
	{
		if ( !GradientFog.IsValid() )
			return;

		var overcast = GetCloudDensity();
		var rain = GetRainAmount();
		var fogAmount = WorldAtmospherePalette.GetFogStrength( GetFogAmount(), overcast, rain );
		var visibility = GetVisibilityMultiplier();
		fogAmount = MathX.Clamp( fogAmount + (1f - visibility) * 0.35f, 0f, 1f );
		GradientFog.Enabled = fogAmount > 0.01f;
		if ( !GradientFog.Enabled )
			return;

		GradientFog.Color = WorldAtmospherePalette.GetFogColor(
			World.TimeOfDay,
			GetFogAmount(),
			overcast,
			rain,
			GetTemperature() );

		var endDistance = WorldAtmospherePalette.GetFogEndDistance( GetFogAmount(), overcast, rain ) * visibility;
		GradientFog.StartDistance = endDistance * 0.15f;
		GradientFog.EndDistance = endDistance;
		GradientFog.Height = MathX.Lerp( 2500f, 8000f, 1f - fogAmount );
		GradientFog.FalloffExponent = MathX.Lerp( 1.2f, 2.4f, fogAmount );
		GradientFog.VerticalFalloffExponent = 1.35f;
	}

	void UpdateSky()
	{
		if ( !Sky.IsValid() )
			Sky = Scene.GetAllComponents<SkyBox2D>().FirstOrDefault();

		if ( !Sky.IsValid() )
			return;

		EnsureSkyMaterial();
		if ( !_skyMaterial.IsValid() )
			return;

		var time = World.TimeOfDay;
		var overcast = GetCloudDensity();
		var rain = GetRainAmount();
		var blend = SkyCycleBlend.FromTimeOfDay( time );

		// Keep the sky dome gradients vivid; weather mood is shown on cloud sprites instead.
		const float skyOvercast = 0f;
		const float skyRain = 0f;

		_skyMaterial.Set( "g_flDayAmount", blend.Day );
		_skyMaterial.Set( "g_flNightAmount", blend.Night );
		_skyMaterial.Set( "g_flSunriseAmount", blend.Sunrise );
		_skyMaterial.Set( "g_flSunsetAmount", blend.Sunset );
		_skyMaterial.Set( "g_flStarIntensity", blend.StarIntensity );
		_skyMaterial.Set( "g_flMilkyWayIntensity", blend.MilkyWayIntensity );
		_skyMaterial.Set( "g_flMilkyWayBrightness", MathX.Lerp( 0.7f, 1.15f, blend.Night ) );
		// Higher density threshold = fewer procedural stars; higher scale = finer star field.
		_skyMaterial.Set( "g_flStarNoiseDensity", 0.988f );
		_skyMaterial.Set( "g_flStarNoiseScale", 260f );
		_skyMaterial.Set( "g_flStarTwinkleSpeed", 1.35f );
		_skyMaterial.Set( "g_flStarTwinkleAmount", 0.65f );
		_skyMaterial.Set( "g_flWeatherDarkness", WorldAtmospherePalette.GetWeatherDarkness( skyOvercast, skyRain, 0f ) );

		var dayGradient = WorldAtmospherePalette.GetDaySkyGradient( skyOvercast, skyRain );
		var sunriseGradient = WorldAtmospherePalette.GetSunriseSkyGradient( skyOvercast, skyRain );
		var sunsetGradient = WorldAtmospherePalette.GetSunsetSkyGradient( skyOvercast, skyRain );
		var nightGradient = WorldAtmospherePalette.GetNightSkyGradient( skyOvercast, skyRain );

		_skyMaterial.Set( "g_vDayHorizonColor", WorldAtmospherePalette.ToVector3( dayGradient.Horizon ) );
		_skyMaterial.Set( "g_vDayZenithColor", WorldAtmospherePalette.ToVector3( dayGradient.Zenith ) );
		_skyMaterial.Set( "g_vSunriseHorizonColor", WorldAtmospherePalette.ToVector3( sunriseGradient.Horizon ) );
		_skyMaterial.Set( "g_vSunriseZenithColor", WorldAtmospherePalette.ToVector3( sunriseGradient.Zenith ) );
		_skyMaterial.Set( "g_vSunsetHorizonColor", WorldAtmospherePalette.ToVector3( sunsetGradient.Horizon ) );
		_skyMaterial.Set( "g_vSunsetZenithColor", WorldAtmospherePalette.ToVector3( sunsetGradient.Zenith ) );
		_skyMaterial.Set( "g_vNightHorizonColor", WorldAtmospherePalette.ToVector3( nightGradient.Horizon ) );
		_skyMaterial.Set( "g_vNightZenithColor", WorldAtmospherePalette.ToVector3( nightGradient.Zenith ) );

		var sunDirection = WorldAtmospherePalette.GetSunSkyDirection( time );
		var moonDirection = WorldAtmospherePalette.GetMoonSkyDirection( time );
		var sunDiscColor = WorldAtmospherePalette.GetSunDiscColor( time, overcast, rain );
		var moonDiscColor = WorldAtmospherePalette.GetMoonDiscColor( time, overcast );
		var sunDimming = WorldAtmospherePalette.GetSunWeatherDimming( overcast, rain );

		_skyMaterial.Set( "g_vSunDirection", sunDirection );
		_skyMaterial.Set( "g_vMoonDirection", moonDirection );
		_skyMaterial.Set( "g_vSunDiscColor", WorldAtmospherePalette.ToVector3( sunDiscColor ) );
		_skyMaterial.Set( "g_vMoonDiscColor", WorldAtmospherePalette.ToVector3( moonDiscColor ) );
		_skyMaterial.Set( "g_flSunBrightness", WorldAtmospherePalette.GetSunBodyVisibility( time ) * sunDimming );
		_skyMaterial.Set( "g_flMoonBrightness", WorldAtmospherePalette.GetMoonBodyVisibility( time ) );
		_skyMaterial.Set( "g_flSunDiscSize", MathF.Max( SunDiscSize, 0.1f ) );
		_skyMaterial.Set( "g_flSunGlowSize", MathF.Max( SunGlowSize, 0.5f ) );
		_skyMaterial.Set(
			"g_flSunGlowStrength",
			WorldAtmospherePalette.GetSunGlowStrength( time, overcast, rain )
			* MathF.Max( blend.Day, blend.Sunrise * 0.85f + blend.Sunset * 0.85f )
			* MathF.Max( SunGlowStrength, 0f ) );
		var moonVis = WorldAtmospherePalette.GetMoonBodyVisibility( time );
		_skyMaterial.Set( "g_flMoonGlowStrength", MathX.Lerp( 0.25f, 0.55f, blend.Night ) * MathF.Max( moonVis, 0.15f ) );

		var flare = EnableSunFlare
			? WorldAtmospherePalette.GetSunFlareStrength( time, overcast, rain ) * MathF.Max( SunFlareIntensity, 0f )
			: 0f;
		_skyMaterial.Set( "g_flSunFlareStrength", flare );
		_skyMaterial.Set( "g_flSunFlareBloom", MathF.Max( SunFlareBloom, 0f ) );
		_skyMaterial.Set( "g_flSunFlareStreaks", MathF.Max( SunFlareStreaks, 0f ) );
		_skyMaterial.Set( "g_flSunFlareGhosts", MathF.Max( SunFlareGhosts, 0f ) );
		_skyMaterial.Set( "g_flSunFlareHalo", MathF.Max( SunFlareHalo, 0f ) );

		var flareColor = Color.Lerp( sunDiscColor, new Color( 1f, 0.96f, 0.88f ), 0.35f ) * SunFlareTint;
		_skyMaterial.Set( "g_vSunFlareColor", WorldAtmospherePalette.ToVector3( flareColor ) );

		Sky.Tint = Color.Lerp( Color.White, new Color( 0.55f, 0.6f, 0.75f ), blend.Night * 0.45f );
	}

	void EnsurePrecipitationEffects()
	{
		if ( IsEditMode )
			return;

		if ( !_rain.IsValid() )
			_rain = WorldPrecipitationEffect.Create( GameObject, snow: false );

		if ( !_snow.IsValid() )
			_snow = WorldPrecipitationEffect.Create( GameObject, snow: true );
	}

	void UpdatePrecipitation()
	{
		if ( !_rain.IsValid() || !_snow.IsValid() )
			return;

		if ( !TryGetEffectCenter( PrecipitationFollowHeight, out var center ) )
			return;

		// Global weather only — rain/storm cloud volumes spawn their own rain from the cloud deck.
		var rain = World.RainAmount;
		var snow = World.SnowAmount;
		SplitPrecipitation( ref rain, ref snow );

		var windStrength = GetWindStrength();
		var windDirection = GetWindDirection();
		var temperature = GetTemperature();
		_rain.Update( center, rain, windDirection, windStrength, temperature );
		_snow.Update( center, snow, windDirection, windStrength, temperature );
	}

	float ResolveSnowAmount()
	{
		var sample = ResolveLocalWeather();
		var snow = sample?.SnowAmount ?? World.SnowAmount;
		var rain = sample?.RainAmount ?? World.RainAmount;
		var temperature = GetTemperature();

		if ( temperature >= 2f || rain <= 0.01f )
			return snow;

		var freezeBlend = temperature <= 0f
			? 1f
			: MathX.Clamp( (2f - temperature) / 2f, 0f, 1f );

		return MathF.Max( snow, rain * freezeBlend );
	}

	void SplitPrecipitation( ref float rain, ref float snow )
	{
		var temperature = GetTemperature();

		if ( temperature >= 2f || rain <= 0.001f )
			return;

		var freezeBlend = temperature <= 0f
			? 1f
			: MathX.Clamp( (2f - temperature) / 2f, 0f, 1f );

		snow = MathF.Max( snow, rain * freezeBlend );
		rain *= 1f - freezeBlend;
	}

	bool TryGetEffectCenter( float followHeight, out Vector3 center )
	{
		center = default;

		if ( FollowCamera.IsValid() )
		{
			center = FollowCamera.WorldPosition + Vector3.Up * followHeight;
			return true;
		}

		var camera = Scene.Camera;
		if ( camera.IsValid() )
		{
			center = camera.WorldPosition + Vector3.Up * followHeight;
			return true;
		}

		foreach ( var candidate in Scene.GetAllComponents<CameraComponent>() )
		{
			if ( !candidate.IsValid() || !candidate.Enabled )
				continue;

			center = candidate.WorldPosition + Vector3.Up * followHeight;
			return true;
		}

		return false;
	}

	WeatherSample? ResolveLocalWeather()
	{
		if ( VolumeManager.IsValid() )
			return VolumeManager.GetPlayerWeather();

		return null;
	}

	float GetRainAmount()
	{
		var sample = ResolveLocalWeather();
		return sample?.RainAmount ?? World.RainAmount;
	}

	float GetFogAmount()
	{
		var sample = ResolveLocalWeather();
		return sample?.FogAmount ?? World.FogAmount;
	}

	float GetCloudDensity() => Clouds.IsValid() ? Clouds.CloudDensity : World.OvercastAmount;

	float GetLightningFlash()
	{
		if ( Clouds.IsValid() )
			return Clouds.LightningFlash;

		if ( Scene is null )
			return 0f;

		var camera = Scene.Camera;
		var listener = camera.IsValid() ? camera.WorldPosition : WorldPosition;
		var peak = 0f;

		foreach ( var lightning in Scene.GetAllComponents<WeatherVolumeLightningControllerComponent>() )
		{
			if ( !lightning.IsValid() || !lightning.Enabled )
				continue;

			var volume = lightning.Volume;
			if ( !volume.IsValid() || volume.VolumeType != WeatherVolumeType.StormCloud )
				continue;

			var blend = volume.GetBlend( listener );
			if ( volume.HorizontalBlendOnly )
			{
				// Match storm sampling: ignore height so ground listeners still count.
				var local = volume.Transform.World.ToLocal( new Transform( listener, Rotation.Identity ) ).Position;
				var half = volume.Size * 0.5f;
				var blendDistance = MathF.Max( volume.BlendDistance, 20000f );
				var blendX = GetAxisBlend( MathF.Abs( local.x ), half.x, blendDistance );
				var blendY = GetAxisBlend( MathF.Abs( local.y ), half.y, blendDistance );
				blend = MathF.Min( blendX, blendY );
			}

			if ( blend <= 0.05f )
				continue;

			peak = MathF.Max( peak, lightning.CurrentFlashIntensity * blend );
		}

		return peak;
	}

	static float GetAxisBlend( float distance, float halfExtent, float blendDistance )
	{
		if ( distance <= halfExtent - blendDistance )
			return 1f;

		if ( distance >= halfExtent )
			return 0f;

		return 1f - (distance - (halfExtent - blendDistance)) / blendDistance;
	}

	float GetWindStrength() => EnvironmentEffects.IsValid() ? EnvironmentEffects.WindStrength : World.WindStrength;

	Vector3 GetWindDirection() => EnvironmentEffects.IsValid() ? EnvironmentEffects.WindDirection : World.WindDirection;

	float GetVisibilityMultiplier() => EnvironmentEffects.IsValid() ? EnvironmentEffects.VisibilityMultiplier : 1f;

	float GetTemperature()
	{
		var modifier = ResolveLocalWeather()?.TemperatureModifier ?? 0f;
		return World.Temperature + modifier;
	}
}
