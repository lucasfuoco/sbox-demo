using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Client-side atmosphere rendering driven by <see cref="WorldManagerComponent"/>.
/// Rotates the scene's <see cref="DirectionalLight"/> sun and tints the skybox backdrop.
/// </summary>
[Title( "World Environment Renderer" ), Category( "World Simulation" )]
public sealed class WorldEnvironmentRendererComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" )]
	public WorldManagerComponent World { get; set; }

	[Property, Group( "Setup" ), Title( "Scene Sun" ), Description( "The scene's DirectionalLight. Auto-finds the Sun object if unset." )]
	public DirectionalLight Sun { get; set; }

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
		if ( IsEditMode )
			return;

		ApplyAtmosphere();
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

		Sun ??= ResolveSceneSun();
		Sky ??= Scene.GetAllComponents<SkyBox2D>().FirstOrDefault();
		GradientFog ??= GameObject.GetOrAddComponent<GradientFog>();
	}

	void ApplyAtmosphere()
	{
		EnsureReferences();

		if ( !World.IsValid() )
			return;

		UpdateSun();
		UpdateSky();
		UpdateFog();
	}

	DirectionalLight ResolveSceneSun()
	{
		if ( Sun.IsValid() )
			return Sun;

		foreach ( var light in Scene.GetAllComponents<DirectionalLight>() )
		{
			if ( !light.IsValid() )
				continue;

			if ( light.GameObject.Name.Equals( "Sun", StringComparison.OrdinalIgnoreCase ) )
				return light;
		}

		foreach ( var light in Scene.GetAllComponents<DirectionalLight>() )
		{
			if ( light.IsValid() && light.GameObject.Tags.Has( "light_directional" ) )
				return light;
		}

		return Scene.GetAllComponents<DirectionalLight>().FirstOrDefault();
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
			Sun = ResolveSceneSun();
			if ( !Sun.IsValid() )
				return;
		}

		var time = World.TimeOfDay;
		var clouds = World.CloudAmount;
		var rain = World.RainAmount;
		var temperature = World.Temperature;
		var daylight = WorldAtmospherePalette.GetDaylight( time );

		Sun.GameObject.WorldRotation = WorldAtmospherePalette.GetSunRotation( time );
		Sun.LightColor = WorldAtmospherePalette.GetSunLightColor( time, clouds, rain, temperature );
		Sun.SkyColor = WorldAtmospherePalette.GetSkyAmbientColor( time, clouds, rain );
		Sun.FogMode = Light.FogInfluence.Enabled;
		Sun.FogStrength = WorldAtmospherePalette.GetFogStrength( World.FogAmount, clouds, rain );
		Sun.Enabled = daylight > 0.02f;
		Sun.Shadows = daylight > 0.2f && rain < 0.85f && clouds < 0.95f;
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

		var blend = SkyCycleBlend.FromTimeOfDay( World.TimeOfDay );
		_skyMaterial.Set( "g_flBlendDay", blend.Day );
		_skyMaterial.Set( "g_flBlendSunrise", blend.Sunrise );
		_skyMaterial.Set( "g_flBlendSunset", blend.Sunset );
		_skyMaterial.Set( "g_flBlendNight", blend.Night );
		_skyMaterial.Set( "g_vWeatherTint", GetSkyWeatherTint( World.CloudAmount, World.RainAmount, World.SnowAmount ) );
		Sky.Tint = Color.White;
	}

	static Vector3 GetSkyWeatherTint( float cloudAmount, float rainAmount, float snowAmount )
	{
		var brightness = 1f - cloudAmount * 0.35f - rainAmount * 0.2f + snowAmount * 0.05f;
		brightness = MathX.Clamp( brightness, 0.45f, 1.1f );
		return new Vector3( brightness, brightness, brightness );
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
