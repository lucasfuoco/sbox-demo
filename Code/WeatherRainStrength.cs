namespace Sandbox;

/// <summary>
/// Discrete rain intensity tiers shared by volume rain and ambient audio.
/// </summary>
public enum WeatherRainStrength
{
	None = 0,
	Light = 1,
	Medium = 2,
	Strong = 3,
}

public static class WeatherRainStrengthUtil
{
	public static WeatherRainStrength FromAmount( float rainAmount )
	{
		rainAmount = MathX.Clamp( rainAmount, 0f, 1.5f );
		if ( rainAmount < 0.08f )
			return WeatherRainStrength.None;

		if ( rainAmount < 0.45f )
			return WeatherRainStrength.Light;

		if ( rainAmount < 0.8f )
			return WeatherRainStrength.Medium;

		return WeatherRainStrength.Strong;
	}

	public static float ToAmount( WeatherRainStrength strength ) => strength switch
	{
		WeatherRainStrength.Light => 0.35f,
		WeatherRainStrength.Medium => 0.7f,
		WeatherRainStrength.Strong => 1.15f,
		_ => 0f,
	};

	public static float ToVisualMultiplier( WeatherRainStrength strength ) => strength switch
	{
		WeatherRainStrength.Light => 0.55f,
		WeatherRainStrength.Medium => 1f,
		WeatherRainStrength.Strong => 1.45f,
		_ => 0f,
	};

	public static float ToAudioVolume( WeatherRainStrength strength ) => strength switch
	{
		WeatherRainStrength.Light => 0.35f,
		WeatherRainStrength.Medium => 0.65f,
		WeatherRainStrength.Strong => 1f,
		_ => 0f,
	};
}
