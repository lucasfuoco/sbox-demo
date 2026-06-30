using Sandbox.Components.SingletonComponents;

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
	public CameraComponent FollowCamera { get; set; }

	[Property, Group( "Precipitation" ), Title( "Follow Height" )]
	public float PrecipitationFollowHeight { get; set; } = 700f;

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

		if ( !IsEditMode )
		{
			_rain = WorldPrecipitationEffect.Create( GameObject, snow: false );
			_snow = WorldPrecipitationEffect.Create( GameObject, snow: true );
		}
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

		UpdatePrecipitation();
	}

	protected override void DrawGizmos()
	{
		if ( !IsEditMode )
			return;

		ApplyAtmosphere();
	}

	void EnsureReferences()
	{
		World ??= WorldManagerComponent.Instance;
		World ??= Components.Get<WorldManagerComponent>();
		World ??= Scene.GetAllComponents<WorldManagerComponent>().FirstOrDefault();

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
		var clouds = World.CloudAmount;
		var rain = World.RainAmount;
		var temperature = World.Temperature;
		var intensity = WorldAtmospherePalette.GetSunLightIntensity( time );

		Sun.GameObject.WorldRotation = WorldAtmospherePalette.GetSunRotation( time );
		Sun.LightColor = WorldAtmospherePalette.GetSunLightColor( time, clouds, rain, temperature );
		Sun.SkyColor = WorldAtmospherePalette.GetSkyAmbientColor( time, clouds, rain );
		Sun.FogMode = Light.FogInfluence.Enabled;
		Sun.FogStrength = WorldAtmospherePalette.GetFogStrength( World.FogAmount, clouds, rain );
		Sun.Enabled = intensity > 0.02f;
		Sun.Shadows = intensity > 0.2f && rain < 0.85f && clouds < 0.95f;
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
		var clouds = World.CloudAmount;
		var rain = World.RainAmount;
		var intensity = WorldAtmospherePalette.GetMoonLightIntensity( time );

		Moon.GameObject.WorldRotation = WorldAtmospherePalette.GetMoonRotation( time );
		Moon.LightColor = WorldAtmospherePalette.GetMoonLightColor( clouds, rain ).WithAlpha( intensity );
		Moon.SkyColor = WorldAtmospherePalette.GetSkyAmbientColor( time, clouds, rain );
		Moon.FogMode = Light.FogInfluence.Enabled;
		Moon.FogStrength = WorldAtmospherePalette.GetFogStrength( World.FogAmount, clouds, rain ) * 0.35f;
		Moon.Enabled = intensity > 0.03f;
		Moon.Shadows = false;
	}

	void UpdateFog()
	{
		if ( !GradientFog.IsValid() )
			return;

		var fogAmount = WorldAtmospherePalette.GetFogStrength( World.FogAmount, World.CloudAmount, World.RainAmount );
		GradientFog.Enabled = fogAmount > 0.01f;
		if ( !GradientFog.Enabled )
			return;

		GradientFog.Color = WorldAtmospherePalette.GetFogColor(
			World.TimeOfDay,
			World.FogAmount,
			World.CloudAmount,
			World.RainAmount,
			World.Temperature );

		var endDistance = WorldAtmospherePalette.GetFogEndDistance( World.FogAmount, World.CloudAmount, World.RainAmount );
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
		var clouds = World.CloudAmount;
		var rain = World.RainAmount;
		var snow = World.SnowAmount;
		var blend = SkyCycleBlend.FromTimeOfDay( time );

		_skyMaterial.Set( "g_flDayAmount", blend.Day );
		_skyMaterial.Set( "g_flNightAmount", blend.Night );
		_skyMaterial.Set( "g_flSunriseAmount", blend.Sunrise );
		_skyMaterial.Set( "g_flSunsetAmount", blend.Sunset );
		_skyMaterial.Set( "g_flStarIntensity", blend.StarIntensity );
		_skyMaterial.Set( "g_flMilkyWayIntensity", blend.MilkyWayIntensity );
		_skyMaterial.Set( "g_flCloudCoverage", clouds );
		_skyMaterial.Set( "g_flWeatherDarkness", WorldAtmospherePalette.GetWeatherDarkness( clouds, rain, snow ) );

		var dayGradient = WorldAtmospherePalette.GetDaySkyGradient( clouds, rain );
		var sunriseGradient = WorldAtmospherePalette.GetSunriseSkyGradient( clouds, rain );
		var sunsetGradient = WorldAtmospherePalette.GetSunsetSkyGradient( clouds, rain );
		var nightGradient = WorldAtmospherePalette.GetNightSkyGradient( clouds, rain );

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
		var sunDiscColor = WorldAtmospherePalette.GetSunDiscColor( time, clouds );
		var moonDiscColor = WorldAtmospherePalette.GetMoonDiscColor( time, clouds );

		_skyMaterial.Set( "g_vSunDirection", sunDirection );
		_skyMaterial.Set( "g_vMoonDirection", moonDirection );
		_skyMaterial.Set( "g_vSunDiscColor", WorldAtmospherePalette.ToVector3( sunDiscColor ) );
		_skyMaterial.Set( "g_vMoonDiscColor", WorldAtmospherePalette.ToVector3( moonDiscColor ) );
		_skyMaterial.Set( "g_flSunBrightness", WorldAtmospherePalette.GetSunBodyVisibility( time ) );
		_skyMaterial.Set( "g_flMoonBrightness", WorldAtmospherePalette.GetMoonBodyVisibility( time ) );
		_skyMaterial.Set( "g_flSunGlowStrength", WorldAtmospherePalette.GetSunGlowStrength( time ) * blend.Day );
		_skyMaterial.Set( "g_flMoonGlowStrength", MathX.Lerp( 0.35f, 0.7f, blend.Night ) );

		Sky.Tint = Color.White;
	}

	void UpdatePrecipitation()
	{
		if ( !_rain.IsValid() || !_snow.IsValid() )
			return;

		if ( !TryGetPrecipitationCenter( out var center ) )
			return;

		var wind = World.WindDirection;
		var windStrength = World.WindStrength;

		_rain.Update( center, World.RainAmount, wind, windStrength, World.Temperature );
		_snow.Update( center, World.SnowAmount, wind, windStrength, World.Temperature );
	}

	bool TryGetPrecipitationCenter( out Vector3 center )
	{
		center = default;

		if ( FollowCamera.IsValid() )
		{
			center = FollowCamera.WorldPosition + Vector3.Up * PrecipitationFollowHeight;
			return true;
		}

		var camera = Scene.Camera;
		if ( camera.IsValid() )
		{
			center = camera.WorldPosition + Vector3.Up * PrecipitationFollowHeight;
			return true;
		}

		foreach ( var candidate in Scene.GetAllComponents<CameraComponent>() )
		{
			if ( !candidate.IsValid() || !candidate.Enabled )
				continue;

			center = candidate.WorldPosition + Vector3.Up * PrecipitationFollowHeight;
			return true;
		}

		return false;
	}
}

static class WorldPrecipitationEffectExtensions
{
	public static bool IsValid( this WorldPrecipitationEffect effect ) => effect?.Root.IsValid() == true;
}
