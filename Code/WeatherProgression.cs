namespace Sandbox;

/// <summary>
/// Picks the next weather state for automatic progression on the host.
/// </summary>
public static class WeatherProgression
{
	static readonly WeatherType[] AllTypes = Enum.GetValues<WeatherType>();

	public static WeatherType PickNext( WeatherType current, float timeOfDayHours, float timeInfluence )
	{
		timeInfluence = MathX.Clamp( timeInfluence, 0f, 1f );

		var weights = new Dictionary<WeatherType, float>();

		foreach ( var type in AllTypes )
		{
			var weight = GetTransitionWeight( current, type );
			weight *= Lerp( 1f, GetTimeOfDayWeight( type, timeOfDayHours ), timeInfluence );

			if ( weight > 0.001f )
				weights[type] = weight;
		}

		if ( weights.Count == 0 )
			return current;

		return PickWeighted( weights );
	}

	static WeatherType PickWeighted( Dictionary<WeatherType, float> weights )
	{
		var total = 0f;
		foreach ( var weight in weights.Values )
			total += weight;

		if ( total <= 0f )
			return weights.Keys.First();

		var roll = Game.Random.Float( 0f, total );
		foreach ( var (type, weight) in weights )
		{
			roll -= weight;
			if ( roll <= 0f )
				return type;
		}

		return weights.Keys.Last();
	}

	static float GetTransitionWeight( WeatherType from, WeatherType to )
	{
		if ( from == to )
			return 0.12f;

		var distance = GetTransitionDistance( from, to );
		return distance switch
		{
			0 => 0.12f,
			1 => 1f,
			2 => 0.35f,
			3 => 0.08f,
			_ => 0.02f,
		};
	}

	static int GetTransitionDistance( WeatherType from, WeatherType to )
	{
		if ( from == to )
			return 0;

		if ( IsWet( from ) && IsCold( to ) )
			return 4;

		if ( IsCold( from ) && IsWet( to ) )
			return 4;

		if ( from == WeatherType.Fog && (to is WeatherType.Storm or WeatherType.Blizzard or WeatherType.HeavyRain) )
			return 4;

		if ( to == WeatherType.Fog && from is WeatherType.Storm or WeatherType.Blizzard )
			return 3;

		return from switch
		{
			WeatherType.Clear => to switch
			{
				WeatherType.Cloudy or WeatherType.Fog => 1,
				WeatherType.Overcast => 2,
				_ => 3,
			},
			WeatherType.Cloudy => to switch
			{
				WeatherType.Clear or WeatherType.Overcast or WeatherType.Fog => 1,
				WeatherType.Rain or WeatherType.Snow => 2,
				_ => 3,
			},
			WeatherType.Overcast => to switch
			{
				WeatherType.Cloudy or WeatherType.Rain or WeatherType.Snow or WeatherType.Fog => 1,
				WeatherType.HeavyRain or WeatherType.Blizzard => 2,
				WeatherType.Storm => 3,
				_ => 2,
			},
			WeatherType.Rain => to switch
			{
				WeatherType.Overcast or WeatherType.HeavyRain => 1,
				WeatherType.Cloudy or WeatherType.Storm => 2,
				_ => 3,
			},
			WeatherType.HeavyRain => to switch
			{
				WeatherType.Rain or WeatherType.Storm => 1,
				WeatherType.Overcast => 2,
				_ => 3,
			},
			WeatherType.Storm => to switch
			{
				WeatherType.HeavyRain => 1,
				WeatherType.Rain => 2,
				_ => 3,
			},
			WeatherType.Snow => to switch
			{
				WeatherType.Overcast or WeatherType.Blizzard => 1,
				WeatherType.Cloudy => 2,
				_ => 3,
			},
			WeatherType.Blizzard => to switch
			{
				WeatherType.Snow => 1,
				WeatherType.Overcast => 2,
				_ => 3,
			},
			WeatherType.Fog => to switch
			{
				WeatherType.Clear or WeatherType.Cloudy => 1,
				WeatherType.Overcast => 2,
				_ => 3,
			},
			_ => 3,
		};
	}

	static float GetTimeOfDayWeight( WeatherType type, float hours )
	{
		hours = ((hours % 24f) + 24f) % 24f;

		var isNight = hours is < 6f or >= 20f;
		var isDawn = hours is >= 5f and < 9f;
		var isDay = hours is >= 9f and < 17f;
		var isDusk = hours is >= 17f and < 21f;

		return type switch
		{
			WeatherType.Clear when isDay => 2.5f,
			WeatherType.Clear when isNight => 1.2f,
			WeatherType.Cloudy when isDay => 1.6f,
			WeatherType.Overcast when isDusk => 1.8f,
			WeatherType.Fog when isDawn => 3f,
			WeatherType.Fog when isNight => 2f,
			WeatherType.Rain when isDusk => 2.2f,
			WeatherType.Rain when isDay => 0.8f,
			WeatherType.HeavyRain when isDusk => 1.5f,
			WeatherType.HeavyRain when isNight => 0.6f,
			WeatherType.Storm when isDusk => 2f,
			WeatherType.Storm when isNight => 1.2f,
			WeatherType.Snow when isNight => 1.4f,
			WeatherType.Snow when isDay => 0.7f,
			WeatherType.Blizzard when isNight => 1.8f,
			_ => 1f,
		};
	}

	static bool IsWet( WeatherType type ) =>
		type is WeatherType.Rain or WeatherType.HeavyRain or WeatherType.Storm;

	static bool IsCold( WeatherType type ) =>
		type is WeatherType.Snow or WeatherType.Blizzard;

	static float Lerp( float from, float to, float t ) => from + (to - from) * t;
}
