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

	[Property, Group( "Progression" ), Title( "Random Blend" ), Description( "0 = realistic neighbor transitions, 1 = pick any weather type with equal chance." ), Range( 0f, 1f )]
	public float RandomBlend { get; set; } = 0.45f;

	float _nextChangeInterval = float.MaxValue;
	RealTimeSince _sinceLastChange;
	bool _ready;

	bool IsWeatherAuthority =>
		Networking.IsHost
		|| !Networking.IsActive;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	protected override void OnAwake()
	{
		EnsureReferences();
	}

	protected override void OnStart()
	{
		EnsureReferences();

		if ( !Weather.IsValid() || !Time.IsValid() )
		{
			Log.Warning( $"{nameof( WeatherProgressionComponent )} is missing required weather or time components." );
			return;
		}

		if ( IsWeatherAuthority )
			ScheduleNextChange();

		_ready = true;
	}

	protected override void OnFixedUpdate()
	{
		if ( !_ready || !EnableAutoProgression || !IsWeatherAuthority || IsEditMode )
			return;

		if ( !Weather.IsValid() || !Time.IsValid() )
			return;

		if ( Weather.CurrentWeather != Weather.TargetWeather )
			return;

		if ( _sinceLastChange < _nextChangeInterval )
			return;

		var next = WeatherProgression.PickNext(
			Weather.CurrentWeather,
			Time.TimeOfDay,
			TimeOfDayInfluence,
			RandomBlend );
		Weather.SetTargetWeather( next );
		ScheduleNextChange();
	}

	void EnsureReferences()
	{
		Weather ??= Components.Get<WeatherManagerComponent>();
		Time ??= Components.Get<WorldTimeComponent>();
	}

	void ScheduleNextChange()
	{
		var min = Math.Min( MinIntervalSeconds, MaxIntervalSeconds );
		var max = Math.Max( MinIntervalSeconds, MaxIntervalSeconds );
		_nextChangeInterval = Random.Shared.Float( min, max );
		_sinceLastChange = 0;
	}
}
