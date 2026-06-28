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

	public static Rotation GetMoonRotation( float timeOfDay ) =>
		GetSunRotation( (timeOfDay + 12f) % 24f );

	/// <summary>
	/// World-space direction toward the visible sun disc in the sky.
	/// </summary>
	public static Vector3 GetSunSkyDirection( float timeOfDay ) =>
		(-GetSunRotation( timeOfDay ).Forward).Normal;

	/// <summary>
	/// World-space direction toward the visible moon disc (roughly opposite the sun).
	/// </summary>
	public static Vector3 GetMoonSkyDirection( float timeOfDay ) =>
		GetSunSkyDirection( (timeOfDay + 12f) % 24f );

	public static float GetSunBodyVisibility( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		return MathX.Clamp( elevation / 4f, 0f, 1f );
	}

	public static float GetMoonBodyVisibility( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( (timeOfDay + 12f) % 24f );
		return MathX.Clamp( elevation / 3f, 0f, 1f );
	}

	public static Color GetSunDiscColor( float timeOfDay, float cloudAmount )
	{
		var twilight = GetTwilightBlend( timeOfDay );
		var daylight = GetDaylight( timeOfDay );
		var color = Color.Lerp( new Color( 1f, 0.55f, 0.2f ), new Color( 1f, 0.98f, 0.88f ), daylight );
		color = Color.Lerp( color, new Color( 1f, 0.72f, 0.38f ), twilight.dawn + twilight.dusk );
		color *= Color.Lerp( Color.White, OvercastTint, cloudAmount * 0.55f );
		return color;
	}

	public static Color GetMoonDiscColor( float timeOfDay, float cloudAmount )
	{
		var color = new Color( 0.82f, 0.88f, 1f );
		color *= Color.Lerp( Color.White, OvercastTint, cloudAmount * 0.65f );
		return color;
	}

	public static float GetSunGlowStrength( float timeOfDay )
	{
		var twilight = GetTwilightBlend( timeOfDay );
		return 0.35f + twilight.dawn * 0.85f + twilight.dusk * 1f;
	}

	public static float GetDaylight( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		return MathX.Clamp( elevation / 35f, 0f, 1f );
	}

	public static Color GetSunLightColor( float timeOfDay, float cloudAmount, float rainAmount, float temperature )
	{
		var daylight = GetSunLightIntensity( timeOfDay );
		var twilight = GetTwilightBlend( timeOfDay );

		var baseColor = Color.Lerp( NightLight, DayLight, daylight );
		baseColor = Color.Lerp( baseColor, DawnLight, twilight.dawn );
		baseColor = Color.Lerp( baseColor, DuskLight, twilight.dusk );

		var weatherTint = Color.Lerp( Color.White, OvercastTint, cloudAmount * 0.75f );
		weatherTint = Color.Lerp( weatherTint, RainTint, rainAmount * 0.85f );
		baseColor *= weatherTint;

		var temperatureTint = Color.Lerp( new Color( 0.85f, 0.9f, 1f ), new Color( 1f, 0.95f, 0.85f ), MathX.Clamp( (temperature - 5f) / 25f, 0f, 1f ) );
		baseColor *= temperatureTint;

		return baseColor.WithAlpha( daylight );
	}

	public static float GetSunLightIntensity( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		return MathX.Clamp( elevation / 12f, 0f, 1f );
	}

	public static float GetMoonLightIntensity( float timeOfDay )
	{
		var moonElevation = GetSunElevationDegrees( (timeOfDay + 12f) % 24f );
		var night = 1f - GetSunLightIntensity( timeOfDay );
		return MathX.Clamp( moonElevation / 10f, 0f, 1f ) * night;
	}

	public static Color GetMoonLightColor( float cloudAmount, float rainAmount )
	{
		var color = new Color( 0.72f, 0.82f, 1f );
		color *= Color.Lerp( Color.White, OvercastTint, cloudAmount * 0.7f );
		color *= Color.Lerp( Color.White, RainTint, rainAmount * 0.5f );
		return color;
	}

	public static Vector3 ToVector3( Color color ) => new( color.r, color.g, color.b );

	public static (Color Horizon, Color Zenith) GetDaySkyGradient( float cloudAmount, float rainAmount )
	{
		var horizon = new Color( 0.72f, 0.82f, 0.95f );
		var zenith = new Color( 0.22f, 0.48f, 0.92f );
		return WeatherSkyGradient( horizon, zenith, cloudAmount, rainAmount );
	}

	public static (Color Horizon, Color Zenith) GetSunriseSkyGradient( float cloudAmount, float rainAmount )
	{
		var horizon = new Color( 1f, 0.55f, 0.28f );
		var zenith = new Color( 0.55f, 0.62f, 0.88f );
		return WeatherSkyGradient( horizon, zenith, cloudAmount, rainAmount * 0.5f );
	}

	public static (Color Horizon, Color Zenith) GetSunsetSkyGradient( float cloudAmount, float rainAmount )
	{
		var horizon = new Color( 1f, 0.42f, 0.32f );
		var zenith = new Color( 0.48f, 0.38f, 0.72f );
		return WeatherSkyGradient( horizon, zenith, cloudAmount, rainAmount * 0.5f );
	}

	public static (Color Horizon, Color Zenith) GetNightSkyGradient( float cloudAmount, float rainAmount )
	{
		var horizon = new Color( 0.04f, 0.06f, 0.12f );
		var zenith = new Color( 0.01f, 0.02f, 0.06f );
		var weather = Color.Lerp( Color.White, OvercastSky, cloudAmount * 0.35f + rainAmount * 0.25f );
		return (horizon * weather, zenith * weather);
	}

	static (Color Horizon, Color Zenith) WeatherSkyGradient( Color horizon, Color zenith, float cloudAmount, float rainAmount )
	{
		var weather = Color.Lerp( Color.White, OvercastSky, cloudAmount * 0.55f + rainAmount * 0.35f );
		return (horizon * weather, zenith * weather);
	}

	public static Color GetSunGlowColor( float timeOfDay, float cloudAmount )
	{
		var daylight = GetSunLightIntensity( timeOfDay );
		var twilight = GetTwilightBlend( timeOfDay );
		var color = Color.Lerp( new Color( 1f, 0.55f, 0.2f ), new Color( 1f, 0.97f, 0.88f ), daylight );
		color = Color.Lerp( color, new Color( 1f, 0.72f, 0.38f ), twilight.dawn + twilight.dusk );
		color *= Color.Lerp( Color.White, OvercastTint, cloudAmount * 0.45f );
		return color;
	}

	public static float GetWeatherDarkness( float cloudAmount, float rainAmount, float snowAmount ) =>
		MathX.Clamp( cloudAmount * 0.45f + rainAmount * 0.35f + snowAmount * 0.08f, 0f, 0.85f );

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
