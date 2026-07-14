namespace Sandbox.Components;

/// <summary>
/// Exposes effective audio weather values at the listener.
/// </summary>
[Title( "Weather Audio Controller" ), Category( "World Simulation" )]
public sealed class WeatherAudioControllerComponent : Component
{
	[RequireComponent]
	public WeatherVolumeManagerComponent VolumeManager { get; private set; }

	public float RainAmount => VolumeManager.IsValid() ? VolumeManager.GetPlayerWeather().RainAmount : 0f;

	public float WindStrength => VolumeManager.IsValid() ? VolumeManager.GetPlayerWeather().WindStrength : 0f;

	public Vector3 WindDirection => VolumeManager.IsValid()
		? VolumeManager.GetPlayerWeather().WindDirection
		: Vector3.Forward;

	public float AudioMuffleAmount => VolumeManager.IsValid() ? VolumeManager.GetPlayerWeather().AudioMuffleAmount : 0f;
}
