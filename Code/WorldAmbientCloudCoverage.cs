namespace Sandbox;

/// <summary>
/// Procedural cloud patches used to localize rain and thunder in the world.
/// </summary>
public static class WorldAmbientCloudCoverage
{
	public static float Sample(
		float worldX,
		float worldY,
		float timeSeconds,
		Vector3 windDirection,
		float cloudAmount )
	{
		if ( cloudAmount <= 0.01f )
			return 0f;

		var wind = windDirection.WithZ( 0f );
		if ( wind.LengthSquared <= 0.0001f )
			wind = Vector3.Forward;
		else
			wind = wind.Normal;

		var scrollX = wind.x * timeSeconds * 0.08f;
		var scrollY = wind.y * timeSeconds * 0.08f;

		var patchA = Noise01( worldX * 0.00055f + scrollX, worldY * 0.00055f + scrollY );
		var patchB = Noise01( worldX * 0.00115f - scrollX * 0.6f, worldY * 0.00115f - scrollY * 0.6f );
		var coverage = MathX.Clamp( patchA * 0.65f + patchB * 0.35f, 0f, 1f );

		var threshold = 1f - cloudAmount;
		return MathX.Clamp( (coverage - threshold) / MathF.Max( 1f - threshold, 0.05f ), 0f, 1f );
	}

	static float Noise01( float x, float y )
	{
		var value = MathF.Sin( x * 12.9898f + y * 78.233f ) * 43758.5453f;
		value = value - MathF.Floor( value );
		return value * value * (3f - 2f * value);
	}
}
