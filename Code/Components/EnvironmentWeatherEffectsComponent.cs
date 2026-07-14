namespace Sandbox.Components;

/// <summary>
/// Exposes effective visibility and wind values at the listener for gameplay and VFX.
/// </summary>
[Title( "Environment Weather Effects" ), Category( "World Simulation" )]
public sealed class EnvironmentWeatherEffectsComponent : Component
{
	[RequireComponent]
	public WeatherVolumeManagerComponent VolumeManager { get; private set; }

	public float VisibilityMultiplier => VolumeManager.IsValid() ? VolumeManager.GetPlayerWeather().VisibilityMultiplier : 1f;

	public float WindStrength => VolumeManager.IsValid() ? VolumeManager.GetPlayerWeather().WindStrength : 0f;

	public Vector3 WindDirection => VolumeManager.IsValid()
		? VolumeManager.GetPlayerWeather().WindDirection
		: Vector3.Forward;
}
