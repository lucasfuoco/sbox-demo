namespace Sandbox;

/// <summary>
/// Procedural sky blend weights and night visibility driven by time of day.
/// </summary>
public readonly struct SkyCycleBlend
{
	public float Day { get; init; }
	public float Night { get; init; }
	public float Sunrise { get; init; }
	public float Sunset { get; init; }
	public float StarIntensity { get; init; }
	public float MilkyWayIntensity { get; init; }

	public static SkyCycleBlend FromTimeOfDay( float hour )
	{
		hour = (hour % 24f + 24f) % 24f;

		var sunElevation = WorldAtmospherePalette.GetSunElevationDegrees( hour );
		var dayAmount = SmoothAboveHorizon( sunElevation );
		var nightAmount = 1f - SmoothAboveHorizon( sunElevation + 2f );

		var sunrise = WindowPeak( hour, 5.5f, 6.5f, 7.5f );
		var sunset = WindowPeak( hour, 17.5f, 18.75f, 20f );

		if ( dayAmount > 0.65f )
		{
			sunrise *= 1f - (dayAmount - 0.65f) / 0.35f;
			sunset *= 1f - (dayAmount - 0.65f) / 0.35f;
		}

		var starIntensity = MathX.Clamp( nightAmount * 1.15f - dayAmount * 0.85f, 0f, 1f );
		var milkyWayIntensity = MathX.Clamp( nightAmount * 1.05f - dayAmount * 0.75f, 0f, 1f );

		return new SkyCycleBlend
		{
			Day = dayAmount,
			Night = nightAmount,
			Sunrise = sunrise,
			Sunset = sunset,
			StarIntensity = starIntensity,
			MilkyWayIntensity = milkyWayIntensity,
		};
	}

	static float SmoothAboveHorizon( float elevationDegrees )
	{
		return MathX.Clamp( elevationDegrees / 8f, 0f, 1f );
	}

	static float WindowPeak( float hour, float start, float peak, float end )
	{
		if ( hour < start || hour > end )
			return 0f;

		var halfWidth = Math.Max( (end - start) * 0.5f, 0.001f );
		var delta = hour - peak;
		var normalized = delta / halfWidth;
		return MathF.Exp( -normalized * normalized );
	}
}
