namespace Sandbox;

/// <summary>
/// Derives sky, sun, and fog colors from simulated time and weather.
/// </summary>
static class WorldAtmospherePalette
{
	static readonly Color NightLight = new( 0.35f, 0.45f, 0.75f );
	static readonly Color DawnLight = new( 1.25f, 0.28f, 0.07f );
	static readonly Color DayLight = new( 1f, 0.97f, 0.92f );
	static readonly Color DuskLight = new( 1.3f, 0.2f, 0.05f );
	static readonly Color OvercastTint = new( 0.56f, 0.59f, 0.64f );
	static readonly Color RainTint = new( 0.42f, 0.45f, 0.50f );

	static readonly Color NightSky = new( 0.008f, 0.012f, 0.035f );
	static readonly Color DaySky = new( 0.45f, 0.68f, 0.95f );
	static readonly Color OvercastSky = new( 0.34f, 0.36f, 0.40f );
	static readonly Color RainSky = new( 0.28f, 0.30f, 0.34f );

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

	/// <summary>
	/// World-space direction from the observer toward the sun in the sky dome.
	/// </summary>
	public static Vector3 GetSunSkyDirection( float timeOfDay ) =>
		DirectionFromElevationAzimuth( GetSunElevationDegrees( timeOfDay ), GetSunAzimuthDegrees( timeOfDay ) );

	/// <summary>
	/// World-space direction toward the visible moon disc (roughly opposite the sun).
	/// </summary>
	public static Vector3 GetMoonSkyDirection( float timeOfDay ) =>
		GetSunSkyDirection( (timeOfDay + 12f) % 24f );

	public static Rotation GetSunRotation( float timeOfDay )
	{
		var toSun = GetSunSkyDirection( timeOfDay );
		return Rotation.LookAt( -toSun, Vector3.Up );
	}

	public static Rotation GetMoonRotation( float timeOfDay ) =>
		GetSunRotation( (timeOfDay + 12f) % 24f );

	static Vector3 DirectionFromElevationAzimuth( float elevationDegrees, float azimuthDegrees )
	{
		var elev = elevationDegrees * (MathF.PI / 180f);
		var azim = azimuthDegrees * (MathF.PI / 180f );
		var horizontal = MathF.Cos( elev );

		// Azimuth rotates around world up (Z). 6:00 = 90° (east), 12:00 = 180°, 18:00 = 270°.
		return new Vector3(
			horizontal * MathF.Sin( azim ),
			horizontal * MathF.Cos( azim ),
			MathF.Sin( elev )
		).Normal;
	}

	public static float GetSunBodyVisibility( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		return MathX.Clamp( elevation / 4f, 0f, 1f );
	}

	public static float GetMoonBodyVisibility( float timeOfDay )
	{
		var moonElevation = GetSunElevationDegrees( (timeOfDay + 12f) % 24f );
		if ( moonElevation < -1.5f )
			return 0f;

		// Peek over the horizon quickly — was elevation/2 which kept the disc nearly black while rising.
		var aboveHorizon = MathX.Clamp( (moonElevation + 1.5f) / 5f, 0f, 1f );
		var night = 1f - GetSunLightIntensity( timeOfDay );
		// Remain readable in twilight; only dim under full daylight.
		var skyDarkness = MathX.Lerp( 0.65f, 1f, night );
		return MathX.Clamp( aboveHorizon * skyDarkness, 0f, 1f );
	}

	public static Color GetSunDiscColor( float timeOfDay, float overcastAmount, float rainAmount )
	{
		var twilight = GetTwilightBlend( timeOfDay );
		var daylight = GetDaylight( timeOfDay );
		var visibility = GetSunBodyVisibility( timeOfDay );
		var dawnRed = new Color( 1.35f, 0.2f, 0.04f );
		var duskRed = new Color( 1.4f, 0.14f, 0.03f );
		var dayWhite = new Color( 1f, 0.98f, 0.9f );

		// Night base must not be dawn-red — otherwise residual glow keeps the sky warm after sunset.
		var color = Color.Lerp( dayWhite * 0.35f, dayWhite, daylight );
		color = Color.Lerp( color, dawnRed, twilight.dawn );
		color = Color.Lerp( color, duskRed, twilight.dusk );

		// Warm rim only while the disc is still visible and low.
		var lowSun = MathX.Clamp( 1f - daylight, 0f, 1f ) * visibility;
		color = Color.Lerp( color, new Color( 1.2f, 0.32f, 0.08f ), lowSun * 0.55f * (1f - twilight.dawn) * (1f - twilight.dusk) );

		color *= Color.Lerp( Color.White, OvercastTint, overcastAmount * 0.7f );
		color *= Color.Lerp( Color.White, RainTint, rainAmount * 0.85f );
		return color;
	}

	public static Color GetMoonDiscColor( float timeOfDay, float overcastAmount )
	{
		var color = Color.White;
		color *= Color.Lerp( Color.White, OvercastTint, overcastAmount * 0.35f );
		return color;
	}

	public static float GetSunGlowStrength( float timeOfDay, float overcastAmount, float rainAmount )
	{
		var twilight = GetTwilightBlend( timeOfDay );
		var daylight = GetDaylight( timeOfDay );
		var strength = 0.4f + twilight.dawn * 1.1f + twilight.dusk * 1.25f + daylight * 0.35f;
		strength *= MathX.Clamp( 1f - overcastAmount * 0.55f - rainAmount * 0.75f, 0.08f, 1f );
		return strength;
	}

	/// <summary>
	/// Daytime lens-flare intensity for the sky sun disc (fades at twilight/night and in bad weather).
	/// </summary>
	public static float GetSunFlareStrength( float timeOfDay, float overcastAmount, float rainAmount )
	{
		var daylight = GetDaylight( timeOfDay );
		var twilight = GetTwilightBlend( timeOfDay );
		var dayCore = MathX.Clamp( (daylight - 0.2f) / 0.55f, 0f, 1f );
		dayCore *= 1f - (twilight.dawn + twilight.dusk) * 0.9f;
		dayCore *= GetSunBodyVisibility( timeOfDay );
		dayCore *= GetSunWeatherDimming( overcastAmount, rainAmount );
		return dayCore * 0.9f;
	}

	public static float GetSunWeatherDimming( float overcastAmount, float rainAmount ) =>
		MathX.Clamp( 1f - overcastAmount * 0.42f - rainAmount * 0.62f, 0.1f, 1f );

	public static float GetDaylight( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		return MathX.Clamp( elevation / 35f, 0f, 1f );
	}

	public static Color GetSunLightColor( float timeOfDay, float overcastAmount, float rainAmount, float temperature )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		var intensity = GetSunLightIntensity( timeOfDay );

		// Below the horizon: no directional sun contribution (do not keep twilight red).
		if ( intensity <= 0.001f || elevation < -0.5f )
			return Color.Black;

		var twilight = GetTwilightBlend( timeOfDay );
		var daylight = GetDaylight( timeOfDay );

		var baseColor = Color.Lerp( new Color( 1f, 0.72f, 0.45f ), DayLight, daylight );
		// Red only while the sun is still up / just at the horizon.
		var warmGate = MathX.Clamp( (elevation + 1f) / 10f, 0f, 1f );
		baseColor = Color.Lerp( baseColor, DawnLight, MathF.Min( twilight.dawn * 1.35f, 1f ) * warmGate );
		baseColor = Color.Lerp( baseColor, DuskLight, MathF.Min( twilight.dusk * 1.35f, 1f ) * warmGate );

		var weatherTint = Color.Lerp( Color.White, OvercastTint, overcastAmount * 0.85f );
		weatherTint = Color.Lerp( weatherTint, RainTint, rainAmount * 0.95f );
		baseColor *= weatherTint;

		var dimming = GetSunWeatherDimming( overcastAmount, rainAmount );
		baseColor *= dimming * intensity;

		var temperatureTint = Color.Lerp( new Color( 0.85f, 0.9f, 1f ), new Color( 1f, 0.95f, 0.85f ), MathX.Clamp( (temperature - 5f) / 25f, 0f, 1f ) );
		baseColor *= temperatureTint;

		// Bake intensity into RGB — don't rely on alpha alone, and never substitute twilight for night.
		return baseColor.WithAlpha( MathX.Clamp( intensity * dimming, 0f, 1f ) );
	}

	public static float GetSunLightIntensity( float timeOfDay )
	{
		var elevation = GetSunElevationDegrees( timeOfDay );
		return MathX.Clamp( elevation / 12f, 0f, 1f );
	}

	public static float GetMoonLightIntensity( float timeOfDay )
	{
		var moonElevation = GetSunElevationDegrees( (timeOfDay + 12f) % 24f );
		if ( moonElevation < -1f )
			return 0f;

		var night = 1f - GetSunLightIntensity( timeOfDay );
		var rise = MathX.Clamp( (moonElevation + 1f) / 8f, 0f, 1f );
		return rise * MathX.Lerp( 0.35f, 1f, night );
	}

	public static Color GetMoonLightColor( float overcastAmount, float rainAmount )
	{
		var color = new Color( 0.72f, 0.82f, 1f );
		color *= Color.Lerp( Color.White, OvercastTint, overcastAmount * 0.7f );
		color *= Color.Lerp( Color.White, RainTint, rainAmount * 0.5f );
		return color;
	}

	public static Vector3 ToVector3( Color color ) => new( color.r, color.g, color.b );

	public static (Color Horizon, Color Zenith) GetDaySkyGradient( float overcastAmount, float rainAmount )
	{
		var horizon = new Color( 0.72f, 0.82f, 0.95f );
		var zenith = new Color( 0.22f, 0.48f, 0.92f );
		return WeatherSkyGradient( horizon, zenith, overcastAmount, rainAmount );
	}

	public static (Color Horizon, Color Zenith) GetSunriseSkyGradient( float overcastAmount, float rainAmount )
	{
		var horizon = new Color( 1f, 0.55f, 0.28f );
		var zenith = new Color( 0.55f, 0.62f, 0.88f );
		return WeatherSkyGradient( horizon, zenith, overcastAmount, rainAmount * 0.5f );
	}

	public static (Color Horizon, Color Zenith) GetSunsetSkyGradient( float overcastAmount, float rainAmount )
	{
		var horizon = new Color( 1f, 0.42f, 0.32f );
		var zenith = new Color( 0.48f, 0.38f, 0.72f );
		return WeatherSkyGradient( horizon, zenith, overcastAmount, rainAmount * 0.5f );
	}

	public static (Color Horizon, Color Zenith) GetNightSkyGradient( float overcastAmount, float rainAmount )
	{
		var horizon = new Color( 0.004f, 0.006f, 0.014f );
		var zenith = new Color( 0.0008f, 0.0012f, 0.005f );
		var weather = Color.Lerp( Color.White, OvercastSky, overcastAmount * 0.25f + rainAmount * 0.2f );
		return (horizon * weather, zenith * weather);
	}

	static (Color Horizon, Color Zenith) WeatherSkyGradient( Color horizon, Color zenith, float overcastAmount, float rainAmount )
	{
		var weather = Color.Lerp( Color.White, OvercastSky, overcastAmount * 0.78f + rainAmount * 0.5f );
		weather = Color.Lerp( weather, RainSky, rainAmount * 0.65f );
		return (horizon * weather, zenith * weather);
	}

	public static Color GetSunGlowColor( float timeOfDay, float overcastAmount )
	{
		var daylight = GetSunLightIntensity( timeOfDay );
		var twilight = GetTwilightBlend( timeOfDay );
		var color = Color.Lerp( new Color( 1.25f, 0.25f, 0.06f ), new Color( 1f, 0.97f, 0.88f ), daylight );
		color = Color.Lerp( color, new Color( 1.35f, 0.18f, 0.04f ), twilight.dawn );
		color = Color.Lerp( color, new Color( 1.4f, 0.12f, 0.03f ), twilight.dusk );
		color *= Color.Lerp( Color.White, OvercastTint, overcastAmount * 0.45f );
		return color;
	}

	public static float GetWeatherDarkness( float overcastAmount, float rainAmount, float snowAmount ) =>
		MathX.Clamp( overcastAmount * 0.5f + rainAmount * 0.55f + snowAmount * 0.08f, 0f, 0.9f );

	public static Color GetSkyAmbientColor( float timeOfDay, float overcastAmount, float rainAmount )
	{
		var daylight = GetDaylight( timeOfDay );
		var sky = Color.Lerp( NightSky, DaySky, daylight );
		sky = Color.Lerp( sky, OvercastSky, overcastAmount * 0.9f + rainAmount * 0.45f );
		sky = Color.Lerp( sky, RainSky, rainAmount * 0.35f );
		return sky;
	}

	public static Color GetSkyTint( float timeOfDay, float overcastAmount, float rainAmount, float snowAmount )
	{
		var daylight = GetDaylight( timeOfDay );
		var twilight = GetTwilightBlend( timeOfDay );
		var brightness = MathX.Lerp( 0.12f, 1f, daylight );
		brightness *= 1f - overcastAmount * 0.55f - rainAmount * 0.35f;
		brightness += snowAmount * 0.08f;

		var tint = new Color( brightness, brightness, brightness * MathX.Lerp( 1.15f, 0.95f, overcastAmount ) );
		var sunset = new Color( 1.05f, 0.72f, 0.45f );
		tint = Color.Lerp( tint, sunset, twilight.dawn * 0.55f + twilight.dusk * 0.75f );

		return tint.WithAlpha( 1f );
	}

	static float GetSunPhase( float timeOfDay ) => (timeOfDay / 24f - 0.25f) * MathF.PI * 2f;

	public static Color GetFogColor( float timeOfDay, float fogAmount, float overcastAmount, float rainAmount, float temperature )
	{
		var daylight = GetDaylight( timeOfDay );
		var fog = Color.Lerp( ClearFog, DenseFog, fogAmount );
		fog = Color.Lerp( fog, OvercastSky, overcastAmount * 0.35f + rainAmount * 0.25f );
		fog *= MathX.Lerp( 0.35f, 1f, daylight );

		if ( temperature < 0f )
			fog = Color.Lerp( fog, new Color( 0.82f, 0.86f, 0.92f ), MathX.Clamp( -temperature / 12f, 0f, 0.5f ) );

		return fog;
	}

	public static float GetFogStrength( float fogAmount, float overcastAmount, float rainAmount )
	{
		return MathX.Clamp( fogAmount * 0.85f + overcastAmount * 0.15f + rainAmount * 0.1f, 0f, 1f );
	}

	public static float GetFogEndDistance( float fogAmount, float overcastAmount, float rainAmount )
	{
		var density = MathX.Clamp( fogAmount + overcastAmount * 0.25f + rainAmount * 0.15f, 0f, 1f );
		return MathX.Lerp( 30000f, 2500f, density );
	}

	static (float dawn, float dusk) GetTwilightBlend( float timeOfDay )
	{
		var elevGate = MathX.Clamp( (GetSunElevationDegrees( timeOfDay ) + 6f) / 6f, 0f, 1f );
		var dawn = (1f - MathX.Clamp( MathF.Abs( timeOfDay - 6f ) / 1.5f, 0f, 1f )) * elevGate;
		var dusk = (1f - MathX.Clamp( MathF.Abs( timeOfDay - 18f ) / 1.25f, 0f, 1f )) * elevGate;
		return (dawn, dusk);
	}
}
