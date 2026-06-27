namespace Sandbox;

/// <summary>
/// Target atmospheric values for a <see cref="WeatherType"/>.
/// </summary>
public sealed class WeatherProfile
{
	public WeatherType Type { get; init; }
	public float RainAmount { get; init; }
	public float SnowAmount { get; init; }
	public float FogAmount { get; init; }
	public float CloudAmount { get; init; }
	public float WindStrength { get; init; }
	public Vector3 WindDirection { get; init; } = Vector3.Forward;
	public float Temperature { get; init; }

	static readonly Dictionary<WeatherType, WeatherProfile> Presets = new()
	{
		[WeatherType.Clear] = new()
		{
			Type = WeatherType.Clear,
			CloudAmount = 0.1f,
			WindStrength = 0.15f,
			WindDirection = new Vector3( 1f, 0f, 0.2f ).Normal,
			Temperature = 24f,
		},
		[WeatherType.Cloudy] = new()
		{
			Type = WeatherType.Cloudy,
			CloudAmount = 0.45f,
			WindStrength = 0.25f,
			WindDirection = new Vector3( 0.8f, 0f, 0.4f ).Normal,
			Temperature = 20f,
		},
		[WeatherType.Overcast] = new()
		{
			Type = WeatherType.Overcast,
			CloudAmount = 0.85f,
			WindStrength = 0.35f,
			WindDirection = new Vector3( 0.6f, 0f, 0.8f ).Normal,
			Temperature = 17f,
		},
		[WeatherType.Rain] = new()
		{
			Type = WeatherType.Rain,
			CloudAmount = 0.9f,
			RainAmount = 0.55f,
			WindStrength = 0.45f,
			WindDirection = new Vector3( 0.9f, 0f, 0.3f ).Normal,
			Temperature = 14f,
		},
		[WeatherType.HeavyRain] = new()
		{
			Type = WeatherType.HeavyRain,
			CloudAmount = 1f,
			RainAmount = 1f,
			WindStrength = 0.65f,
			WindDirection = new Vector3( 1f, 0f, 0.1f ).Normal,
			Temperature = 11f,
		},
		[WeatherType.Snow] = new()
		{
			Type = WeatherType.Snow,
			CloudAmount = 0.8f,
			SnowAmount = 0.65f,
			WindStrength = 0.3f,
			WindDirection = new Vector3( 0.4f, 0f, 0.9f ).Normal,
			Temperature = -2f,
		},
		[WeatherType.Blizzard] = new()
		{
			Type = WeatherType.Blizzard,
			CloudAmount = 1f,
			SnowAmount = 1f,
			FogAmount = 0.25f,
			WindStrength = 0.95f,
			WindDirection = new Vector3( 0.2f, 0f, 1f ).Normal,
			Temperature = -8f,
		},
		[WeatherType.Fog] = new()
		{
			Type = WeatherType.Fog,
			CloudAmount = 0.35f,
			FogAmount = 0.85f,
			WindStrength = 0.08f,
			WindDirection = Vector3.Forward,
			Temperature = 10f,
		},
		[WeatherType.Storm] = new()
		{
			Type = WeatherType.Storm,
			CloudAmount = 1f,
			RainAmount = 0.9f,
			WindStrength = 1f,
			WindDirection = new Vector3( 0.7f, 0f, 0.7f ).Normal,
			Temperature = 13f,
		},
	};

	public static WeatherProfile GetPreset( WeatherType type ) =>
		Presets.GetValueOrDefault( type, Presets[WeatherType.Clear] );

	public static IEnumerable<WeatherProfile> AllPresets => Presets.Values;
}
