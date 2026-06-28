namespace Sandbox.Components;

/// <summary>
/// Host-side automatic weather changes. Picks a new target when the current transition settles.
/// </summary>
[Title( "Weather Progression" ), Category( "World Simulation" )]
public sealed class WeatherProgressionComponent : Component
{
	[RequireComponent]
	public WeatherManagerComponent Weather { get; private set; }

	[RequireComponent]
	public WorldTimeComponent Time { get; private set; }

	[Property, Group( "Progression" ), Title( "Enable Auto Progression" )]
	public bool EnableAutoProgression { get; set; } = true;

	[Property, Group( "Progression" ), Title( "Min Interval (seconds)" ), Range( 30f, 3600f )]
	public float MinIntervalSeconds { get; set; } = 180f;

	[Property, Group( "Progression" ), Title( "Max Interval (seconds)" ), Range( 30f, 7200f )]
	public float MaxIntervalSeconds { get; set; } = 720f;

	[Property, Group( "Progression" ), Title( "Time Of Day Influence" ), Description( "How strongly dawn/day/dusk/night biases the next weather pick." ), Range( 0f, 1f )]
	public float TimeOfDayInfluence { get; set; } = 0.65f;

	float _nextChangeInterval;
	RealTimeSince _sinceLastChange;

	bool IsWeatherAuthority =>
		Networking.IsHost
		|| !Networking.IsActive;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	protected override void OnStart()
	{
		if ( IsWeatherAuthority )
			ScheduleNextChange();
	}

	protected override void OnFixedUpdate()
	{
		if ( !EnableAutoProgression || !IsWeatherAuthority || IsEditMode )
			return;

		if ( Weather.CurrentWeather != Weather.TargetWeather )
			return;

		if ( _sinceLastChange < _nextChangeInterval )
			return;

		var next = WeatherProgression.PickNext( Weather.CurrentWeather, Time.TimeOfDay, TimeOfDayInfluence );
		Weather.SetTargetWeather( next );
		ScheduleNextChange();
	}

	void ScheduleNextChange()
	{
		var min = Math.Min( MinIntervalSeconds, MaxIntervalSeconds );
		var max = Math.Max( MinIntervalSeconds, MaxIntervalSeconds );
		_nextChangeInterval = Game.Random.Float( min, max );
		_sinceLastChange = 0;
	}
}
