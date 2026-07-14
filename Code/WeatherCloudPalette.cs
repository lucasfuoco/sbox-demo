namespace Sandbox;

/// <summary>
/// Particle cloud tints from global weather and localized volume types.
/// </summary>
static class WeatherCloudPalette
{
	public static Color ClearSkyCloud { get; } = new( 1.28f, 1.28f, 1.32f, 1f );
	static readonly Color DefaultCloud = Color.White;
	static readonly Color OvercastCloud = new( 0.78f, 0.80f, 0.84f );
	static readonly Color RainCloud = new( 0.55f, 0.57f, 0.62f );
	static readonly Color StormCloud = new( 0.48f, 0.50f, 0.54f );
	static readonly Color FogBank = new( 0.78f, 0.80f, 0.84f );
	static readonly Color SnowCloud = new( 0.90f, 0.92f, 0.96f );
	static readonly Color DustStorm = new( 0.74f, 0.66f, 0.54f );
	static readonly Color ToxicGas = new( 0.62f, 0.72f, 0.52f );
	static readonly Color AshCloud = new( 0.56f, 0.54f, 0.50f );

	/// <summary>
	/// Derives tint from blended atmospheric amounts (typically global weather from <see cref="WeatherManagerComponent"/>).
	/// </summary>
	/// <summary>
	/// Direct tint for editor preview from <see cref="WeatherType"/> presets.
	/// </summary>
	public static Color GetCloudTintForWeatherType( WeatherType type ) => type switch
	{
		WeatherType.Clear => ClearSkyCloud,
		WeatherType.Cloudy => new Color( 0.94f, 0.95f, 0.98f, 1f ),
		WeatherType.Overcast => OvercastCloud,
		WeatherType.Rain or WeatherType.HeavyRain => RainCloud,
		WeatherType.Storm => StormCloud,
		WeatherType.Snow or WeatherType.Blizzard => SnowCloud,
		WeatherType.Fog => FogBank,
		_ => DefaultCloud,
	};

	public static bool IsClearSkyTint( Color tint ) =>
		tint.r >= 0.99f && tint.g >= 0.99f && tint.b >= 0.99f;

	public static Color GetCloudTint( WeatherSample sample )
	{
		if ( sample.CloudDensity <= 0.001f
			&& sample.RainAmount <= 0.001f
			&& sample.StormAmount <= 0.001f
			&& sample.SnowAmount <= 0.001f
			&& sample.FogAmount <= 0.001f )
		{
			return ClearSkyCloud;
		}

		var tint = DefaultCloud;

		var cloudDensity = MathX.Clamp( sample.CloudDensity, 0f, 1f );
		tint = Color.Lerp( tint, OvercastCloud, cloudDensity * 0.55f );

		var rainAmount = MathX.Clamp( sample.RainAmount, 0f, 1f );
		tint = Color.Lerp( tint, RainCloud, rainAmount );

		var stormAmount = MathX.Clamp( sample.StormAmount, 0f, 1f );
		tint = Color.Lerp( tint, StormCloud, stormAmount * 0.85f );

		var snowAmount = MathX.Clamp( sample.SnowAmount, 0f, 1f );
		tint = Color.Lerp( tint, SnowCloud, snowAmount * 0.75f );

		var fogAmount = MathX.Clamp( sample.FogAmount, 0f, 1f );
		tint = Color.Lerp( tint, FogBank, fogAmount * 0.35f );

		return tint;
	}

	public static Color GetCloudTint( WeatherVolumeType type ) => type switch
	{
		WeatherVolumeType.ClearCloud => ClearSkyCloud,
		WeatherVolumeType.RainCloud => RainCloud,
		WeatherVolumeType.StormCloud => StormCloud,
		WeatherVolumeType.FogBank => FogBank,
		WeatherVolumeType.SnowCloud => SnowCloud,
		WeatherVolumeType.DustStorm => DustStorm,
		WeatherVolumeType.ToxicGas => ToxicGas,
		WeatherVolumeType.AshCloud => AshCloud,
		_ => DefaultCloud,
	};

	public static bool IsExoticVolumeType( WeatherVolumeType type ) => type is
		WeatherVolumeType.DustStorm or
		WeatherVolumeType.ToxicGas or
		WeatherVolumeType.AshCloud;
}
