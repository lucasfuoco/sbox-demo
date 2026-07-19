namespace Sandbox.Components;

/// <summary>
/// Exposes effective cloud density, storm intensity, and lightning flash at the listener.
/// </summary>
[Title( "Cloud Controller" ), Category( "World Simulation" )]
public sealed class CloudControllerComponent : Component
{
	[RequireComponent]
	public WeatherVolumeManagerComponent VolumeManager { get; private set; }

	public float CloudDensity => VolumeManager.IsValid() ? VolumeManager.GetPlayerWeather().CloudDensity : 0f;

	public float StormAmount => VolumeManager.IsValid() ? VolumeManager.GetPlayerWeather().StormAmount : 0f;

	/// <summary>
	/// Peak lightning flash from storm volumes the listener is under (0–1+).
	/// Does not apply when outside storm cloud footprints.
	/// </summary>
	public float LightningFlash
	{
		get
		{
			if ( Scene is null )
				return 0f;

			var listener = VolumeManager.IsValid()
				? VolumeManager.GetPlayerPosition()
				: Scene.Camera.IsValid() ? Scene.Camera.WorldPosition : WorldPosition;

			var peak = 0f;
			foreach ( var lightning in Scene.GetAllComponents<WeatherVolumeLightningControllerComponent>() )
			{
				if ( !lightning.IsValid() || !lightning.Enabled )
					continue;

				var volume = lightning.Volume;
				if ( !volume.IsValid() || volume.VolumeType != WeatherVolumeType.StormCloud )
					continue;

				var blend = GetHorizontalBlend( volume, listener );
				if ( blend <= 0.02f )
					continue;

				// Keep sky/key flash strong once you're under the storm footprint.
				var weight = MathX.Clamp( MathF.Max( blend, 0.55f ), 0f, 1f );
				peak = MathF.Max( peak, lightning.CurrentFlashIntensity * weight );
			}

			return peak;
		}
	}

	static float GetHorizontalBlend( WeatherVolumeComponent volume, Vector3 worldPosition )
	{
		var local = volume.Transform.World.ToLocal( new Transform( worldPosition, Rotation.Identity ) ).Position;
		var half = volume.Size * 0.5f;
		var blendDistance = MathF.Max( volume.BlendDistance, 20000f );

		var blendX = AxisBlend( MathF.Abs( local.x ), half.x, blendDistance );
		var blendY = AxisBlend( MathF.Abs( local.y ), half.y, blendDistance );
		return MathF.Min( blendX, blendY );
	}

	static float AxisBlend( float distance, float halfExtent, float blendDistance )
	{
		if ( distance <= halfExtent - blendDistance )
			return 1f;

		if ( distance >= halfExtent )
			return 0f;

		return 1f - (distance - (halfExtent - blendDistance)) / blendDistance;
	}
}
