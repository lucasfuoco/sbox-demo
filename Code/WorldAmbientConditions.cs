using Sandbox.Components.SingletonComponents;

namespace Sandbox;

/// <summary>
/// Time-of-day and weather multipliers shared by spatial ambient emitters.
/// </summary>
public readonly struct WorldAmbientConditions
{
	public float Rain { get; init; }
	public float Snow { get; init; }
	public float Wind { get; init; }
	public float CloudAmount { get; init; }
	public float Night { get; init; }
	public float Evening { get; init; }
	public float DeepNight { get; init; }
	public float ThunderChance { get; init; }
	public Vector3 WindDirection { get; init; }
	public float TimeSeconds { get; init; }

	public static WorldAmbientConditions FromWorld( WorldManagerComponent world, float timeSeconds )
	{
		var rain = MathX.Clamp( world.RainAmount, 0f, 1f );
		var snow = MathX.Clamp( world.SnowAmount, 0f, 1f );
		var wind = MathX.Clamp( world.WindStrength + rain * 0.25f + snow * 0.35f, 0f, 1f );

		return new WorldAmbientConditions
		{
			Rain = MathX.Clamp( rain + snow * 0.15f, 0f, 1f ),
			Snow = snow,
			Wind = wind,
			CloudAmount = MathX.Clamp( world.CloudAmount, 0f, 1f ),
			Night = GetNightBlend( world.TimeOfDay ),
			Evening = GetEveningBlend( world.TimeOfDay ),
			DeepNight = GetDeepNightBlend( world.TimeOfDay ),
			ThunderChance = MathX.Clamp( rain * 0.75f + world.WindStrength * 0.35f, 0f, 1f ),
			WindDirection = world.WindDirection,
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
