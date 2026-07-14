namespace Sandbox;

/// <summary>
/// One active lightning flash used by storm lighting and local cloud tinting.
/// </summary>
public readonly struct WeatherLightningFlash
{
	public int Id { get; init; }
	public Vector3 Position { get; init; }
	public float Intensity { get; init; }
	public float InfluenceRadius { get; init; }

	public float GetInfluence( Vector3 worldPosition )
	{
		if ( Intensity <= 0.01f || InfluenceRadius <= 1f )
			return 0f;

		var delta = worldPosition - Position;
		var distSq = delta.LengthSquared;
		var radiusSq = InfluenceRadius * InfluenceRadius;
		if ( distSq >= radiusSq )
			return 0f;

		var t = 1f - MathF.Sqrt( distSq ) / InfluenceRadius;
		return Intensity * (t * t);
	}
}
