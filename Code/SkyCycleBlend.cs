namespace Sandbox;

/// <summary>
/// Normalized blend weights for the four sky cycle panoramas.
/// </summary>
public readonly struct SkyCycleBlend
{
	public float Day { get; init; }
	public float Sunrise { get; init; }
	public float Sunset { get; init; }
	public float Night { get; init; }

	public SkyCycleBlend Normalized()
	{
		var total = Day + Sunrise + Sunset + Night;
		if ( total <= 0.0001f )
			return new SkyCycleBlend { Night = 1f };

		return new SkyCycleBlend
		{
			Day = Day / total,
			Sunrise = Sunrise / total,
			Sunset = Sunset / total,
			Night = Night / total,
		};
	}

	/// <summary>
	/// Smooth weights for day, sunrise, sunset, and night across a 24-hour clock.
	/// </summary>
	public static SkyCycleBlend FromTimeOfDay( float hour )
	{
		hour = (hour % 24f + 24f) % 24f;

		var sunrise = Bell( hour, 6f, 1.6f );
		var sunset = Bell( hour, 18f, 1.6f );
		var day = Bell( hour, 12f, 5.5f );
		var night = Bell( hour, 0f, 3.5f ) + Bell( hour, 24f, 3.5f );

		if ( hour is >= 21f or < 3f )
			night += 0.65f;

		return new SkyCycleBlend
		{
			Day = day,
			Sunrise = sunrise,
			Sunset = sunset,
			Night = night,
		}.Normalized();
	}

	static float Bell( float hour, float center, float width )
	{
		var delta = hour - center;

		if ( center <= 3f && hour > 12f )
			delta = hour - 24f - center;
		else if ( center >= 21f && hour < 12f )
			delta = hour + 24f - center;

		var normalized = delta / Math.Max( width, 0.001f );
		return MathF.Exp( -normalized * normalized );
	}
}
