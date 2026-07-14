using Sandbox.Components.SingletonComponents;
using Sandbox.Components;

namespace Sandbox;

/// <summary>
/// Time-of-day and weather multipliers shared by spatial ambient emitters.
/// </summary>
public readonly struct WorldAmbientConditions
{
	public float Rain { get; init; }
	public float Snow { get; init; }
	public float Wind { get; init; }
	public float OvercastAmount { get; init; }
	public float StormAmount { get; init; }
	public float AudioMuffleAmount { get; init; }
	public float VisibilityMultiplier { get; init; }
	public float Night { get; init; }
	public float Evening { get; init; }
	public float DeepNight { get; init; }
	public float ThunderChance { get; init; }
	public Vector3 WindDirection { get; init; }
	public float TimeSeconds { get; init; }

	public static WorldAmbientConditions FromWorld( WorldManagerComponent world, float timeSeconds ) =>
		FromWorld( world, timeSeconds, localWeather: null );

	public static WorldAmbientConditions FromWorld( WorldManagerComponent world, float timeSeconds, WeatherSample? localWeather )
	{
		var sample = localWeather ?? WeatherSample.FromGlobal( world );
		var rain = MathX.Clamp( sample.RainAmount, 0f, 1f );
		var snow = MathX.Clamp( sample.SnowAmount, 0f, 1f );
		var wind = MathX.Clamp( sample.WindStrength + rain * 0.25f + snow * 0.35f, 0f, 1f );

		return new WorldAmbientConditions
		{
			Rain = MathX.Clamp( rain + snow * 0.15f, 0f, 1f ),
			Snow = snow,
			Wind = wind,
			OvercastAmount = MathX.Clamp( sample.CloudDensity, 0f, 1f ),
			StormAmount = MathX.Clamp( sample.StormAmount, 0f, 1f ),
			AudioMuffleAmount = MathX.Clamp( sample.AudioMuffleAmount, 0f, 1f ),
			VisibilityMultiplier = MathX.Clamp( sample.VisibilityMultiplier, 0.05f, 1f ),
			Night = GetNightBlend( world.TimeOfDay ),
			Evening = GetEveningBlend( world.TimeOfDay ),
			DeepNight = GetDeepNightBlend( world.TimeOfDay ),
			ThunderChance = MathX.Clamp( sample.StormAmount * 0.85f + rain * 0.55f + sample.WindStrength * 0.35f, 0f, 1f ),
			WindDirection = WeatherSample.NormalizeWindDirection( sample.WindDirection ),
			TimeSeconds = timeSeconds,
		};
	}

	static float GetNightBlend( float hours )
	{
		hours = NormalizeHours( hours );

		if ( hours >= 21f || hours < 4f )
			return 1f;

		if ( hours is >= 4f and < 6f )
			return 1f - (hours - 4f) / 2f;

		if ( hours is >= 19f and < 21f )
			return (hours - 19f) / 2f;

		return 0f;
	}

	static float GetEveningBlend( float hours )
	{
		hours = NormalizeHours( hours );

		if ( hours is >= 18f and < 24f )
			return 1f - (hours - 18f) / 6f;

		if ( hours < 2f )
			return 1f - hours / 2f;

		return 0f;
	}

	static float GetDeepNightBlend( float hours )
	{
		hours = NormalizeHours( hours );

		if ( hours is >= 22f or < 3f )
			return 1f;

		if ( hours is >= 3f and < 5f )
			return 1f - (hours - 3f) / 2f;

		if ( hours is >= 21f and < 22f )
			return hours - 21f;

		return 0f;
	}

	static float NormalizeHours( float hours ) => ((hours % 24f) + 24f) % 24f;
}
