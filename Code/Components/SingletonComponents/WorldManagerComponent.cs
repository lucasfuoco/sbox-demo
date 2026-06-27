namespace Sandbox.Components.SingletonComponents;

/// <summary>
/// Singleton entry point for server-authoritative world simulation state.
/// </summary>
[Title( "World Manager" ), Category( "World Simulation" )]
public sealed class WorldManagerComponent : SingletonComponent<WorldManagerComponent>, Component.ExecuteInEditor
{
	[RequireComponent]
	public WorldTimeComponent Time { get; private set; }

	[RequireComponent]
	public WeatherManagerComponent Weather { get; private set; }

	public float TimeOfDay => Time.TimeOfDay;

	public float NormalizedTimeOfDay => Time.NormalizedTimeOfDay;

	public float DayLengthSeconds => Time.DayLengthSeconds;

	public bool IsNight => Time.IsNight;

	public WeatherType CurrentWeather => Weather.CurrentWeather;

	public WeatherType TargetWeather => Weather.TargetWeather;

	public float RainAmount => Weather.RainAmount;

	public float SnowAmount => Weather.SnowAmount;

	public float FogAmount => Weather.FogAmount;

	public float CloudAmount => Weather.CloudAmount;

	public float WindStrength => Weather.WindStrength;

	public Vector3 WindDirection => Weather.WindDirection;

	public float Temperature => Weather.Temperature;

	public void SetTimeOfDay( float hours ) => Time.SetTimeOfDay( hours );

	public void SetTargetWeather( WeatherType weatherType ) => Weather.SetTargetWeather( weatherType );
}
