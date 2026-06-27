namespace Sandbox;

/// <summary>
/// Derives sky, sun, and fog colors from simulated time and weather.
/// </summary>
static class WorldAtmospherePalette
{
	static readonly Color NightLight = new( 0.35f, 0.45f, 0.75f );
	static readonly Color DawnLight = new( 1f, 0.72f, 0.45f );
	static readonly Color DayLight = new( 1f, 0.97f, 0.92f );
	static readonly Color DuskLight = new( 1f, 0.55f, 0.35f );
	static readonly Color OvercastTint = new( 0.72f, 0.76f, 0.82f );
	static readonly Color RainTint = new( 0.58f, 0.64f, 0.72f );

	static readonly Color NightSky = new( 0.02f, 0.04f, 0.1f );
	static readonly Color DaySky = new( 0.45f, 0.68f, 0.95f );
	static readonly Color OvercastSky = new( 0.42f, 0.46f, 0.52f );

	static readonly Color ClearFog = new( 0.62f, 0.72f, 0.82f );
	static readonly Color DenseFog = new( 0.55f, 0.58f, 0.62f );

	public static float GetSunElevationDegrees( float timeOfDay )
	{
		var sunPhase = GetSunPhase( timeOfDay );
		return MathF.Sin( sunPhase ) * 72f;
	}

	public static float GetSunAzimuthDegrees( float timeOfDay )
	{
		return timeOfDay / 24f * 360f;
	}

	public static Rotation GetSunRotation( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		var azimuth = GetSunAzimuthDegrees( timeOfDay );
		return Rotation.From( new Angles( -elevation, azimuth, 0f ) );
	}

	public static float GetDaylight( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		return MathX.Clamp( elevation / 35f, 0f, 1f );
	}

	public static Color GetSunLightColor( float timeOfDay, float cloudAmount, float rainAmount, float temperature )
	{
		var daylight = GetDaylight( timeOfDay );
		var twilight = GetTwilightBlend( timeOfDay );

		var baseColor = Color.Lerp( NightLight, DayLight, daylight );
		baseColor = Color.Lerp( baseColor, DawnLight, twilight.dawn );
		baseColor = Color.Lerp( baseColor, DuskLight, twilight.dusk );

		var weatherTint = Color.Lerp( Color.White, OvercastTint, cloudAmount * 0.75f );
		weatherTint = Color.Lerp( weatherTint, RainTint, rainAmount * 0.85f );
		baseColor *= weatherTint;

		var temperatureTint = Color.Lerp( new Color( 0.85f, 0.9f, 1f ), new Color( 1f, 0.95f, 0.85f ), MathX.Clamp( (temperature - 5f) / 25f, 0f, 1f ) );
		baseColor *= temperatureTint;

		return baseColor.WithAlpha( MathX.Lerp( 0.12f, 1f, daylight ) );
	}

	public static Color GetSkyAmbientColor( float timeOfDay, float cloudAmount, float rainAmount )
	{
		var daylight = GetDaylight( timeOfDay );
		var sky = Color.Lerp( NightSky, DaySky, daylight );
		sky = Color.Lerp( sky, OvercastSky, cloudAmount * 0.85f + rainAmount * 0.35f );
		return sky;
	}

	public static Color GetSkyTint( float timeOfDay, float cloudAmount, float rainAmount, float snowAmount )
	{
		var daylight = GetDaylight( timeOfDay );
		var twilight = GetTwilightBlend( timeOfDay );
		var brightness = MathX.Lerp( 0.12f, 1f, daylight );
		brightness *= 1f - cloudAmount * 0.45f - rainAmount * 0.2f;
		brightness += snowAmount * 0.08f;

		var tint = new Color( brightness, brightness, brightness * MathX.Lerp( 1.15f, 0.95f, cloudAmount ) );
		var sunset = new Color( 1.05f, 0.72f, 0.45f );
		tint = Color.Lerp( tint, sunset, twilight.dawn * 0.55f + twilight.dusk * 0.75f );

		return tint.WithAlpha( 1f );
	}

	static float GetSunPhase( float timeOfDay ) => (timeOfDay / 24f - 0.25f) * MathF.PI * 2f;

	public static Color GetFogColor( float timeOfDay, float fogAmount, float cloudAmount, float rainAmount, float temperature )
	{
		var daylight = GetDaylight( timeOfDay );
		var fog = Color.Lerp( ClearFog, DenseFog, fogAmount );
		fog = Color.Lerp( fog, OvercastSky, cloudAmount * 0.35f + rainAmount * 0.25f );
		fog *= MathX.Lerp( 0.35f, 1f, daylight );

		if ( temperature < 0f )
			fog = Color.Lerp( fog, new Color( 0.82f, 0.86f, 0.92f ), MathX.Clamp( -temperature / 12f, 0f, 0.5f ) );

		return fog;
	}

	public static float GetFogStrength( float fogAmount, float cloudAmount, float rainAmount )
	{
		return MathX.Clamp( fogAmount * 0.85f + cloudAmount * 0.15f + rainAmount * 0.1f, 0f, 1f );
	}

	public static float GetFogEndDistance( float fogAmount, float cloudAmount, float rainAmount )
	{
		var density = MathX.Clamp( fogAmount + cloudAmount * 0.25f + rainAmount * 0.15f, 0f, 1f );
		return MathX.Lerp( 30000f, 2500f, density );
	}

	static (float dawn, float dusk) GetTwilightBlend( float timeOfDay )
	{
		var dawn = 1f - MathX.Clamp( MathF.Abs( timeOfDay - 6f ) / 1.5f, 0f, 1f );
		var dusk = 1f - MathX.Clamp( MathF.Abs( timeOfDay - 18f ) / 1.5f, 0f, 1f );
		return (dawn, dusk);
	}
}
