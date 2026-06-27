namespace Sandbox.Components;

/// <summary>
/// Server-authoritative day/night cycle. Clients interpolate for smooth rendering.
/// </summary>
[Title( "World Time" ), Category( "World Simulation" )]
public sealed class WorldTimeComponent : Component, Component.ExecuteInEditor
{
	const float MinDayLengthSeconds = 1f;

	[Property, Group( "Time" ), Title( "Day Length (seconds)" ), Range( 60f, 7200f )]
	public float DayLengthSeconds { get; set; } = 1200f;

	[Property, Group( "Time" ), Title( "Starting Time Of Day" ), Range( 0f, 24f ), Change( nameof( OnStartingTimeOfDayChanged ) )]
	public float StartingTimeOfDay { get; set; } = 8f;

	[Property, Group( "Time" ), Title( "Pause Time" ), Description( "Stop the clock so you can scrub Time Of Day below." )]
	public bool PauseTime { get; set; }

	[Property, Group( "Time" ), Title( "Time Of Day" ), Range( 0f, 24f ), Change( nameof( OnTimeOfDayChanged ) )]
	public float TimeOfDaySlider { get; set; } = 8f;

	[Sync( SyncFlags.FromHost )]
	float SyncedTimeOfDay { get; set; }

	[Sync( SyncFlags.FromHost )]
	float SyncedDayLengthSeconds { get; set; } = 1200f;

	float _displayTimeOfDay;

	/// <summary>
	/// Current time of day from 0 to 24. Interpolated on clients.
	/// </summary>
	public float TimeOfDay => _displayTimeOfDay;

	/// <summary>
	/// Normalized time of day from 0 to 1.
	/// </summary>
	public float NormalizedTimeOfDay => TimeOfDay / 24f;

	public bool IsNight => TimeOfDay is < 6f or >= 20f;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	bool IsTimeAuthority =>
		Networking.IsHost
		|| !Networking.IsActive
		|| IsEditMode;

	protected override void OnStart()
	{
		if ( IsTimeAuthority )
		{
			ApplyTimeOfDay( StartingTimeOfDay );
			SyncedDayLengthSeconds = Math.Max( DayLengthSeconds, MinDayLengthSeconds );
		}
		else
		{
			_displayTimeOfDay = SyncedTimeOfDay;
		}
	}

	protected override void OnValidate()
	{
		if ( !IsEditMode )
			return;

		ApplyTimeOfDay( TimeOfDaySlider );
	}

	protected override void OnFixedUpdate()
	{
		if ( !IsTimeAuthority || IsEditMode )
			return;

		SyncedDayLengthSeconds = Math.Max( DayLengthSeconds, MinDayLengthSeconds );

		if ( PauseTime )
			return;

		var hoursPerSecond = 24f / SyncedDayLengthSeconds;
		SyncedTimeOfDay = (SyncedTimeOfDay + hoursPerSecond * Time.Delta) % 24f;
	}

	protected override void OnUpdate()
	{
		if ( IsEditMode )
			return;

		if ( IsTimeAuthority )
		{
			_displayTimeOfDay = SyncedTimeOfDay;

			if ( !PauseTime )
				TimeOfDaySlider = SyncedTimeOfDay;

			return;
		}

		_displayTimeOfDay = WorldSimulationInterpolation.NetworkLerpTimeOfDay(
			_displayTimeOfDay,
			SyncedTimeOfDay,
			Time.Delta,
			Scene.NetworkRate );
	}

	/// <summary>
	/// Set the authoritative time of day. Host only during play.
	/// </summary>
	public void SetTimeOfDay( float hours )
	{
		if ( !IsTimeAuthority )
			return;

		ApplyTimeOfDay( hours );
	}

	void ApplyTimeOfDay( float hours )
	{
		hours = MathX.Clamp( hours, 0f, 24f );

		if ( IsTimeAuthority )
			SyncedTimeOfDay = hours;

		_displayTimeOfDay = hours;
		TimeOfDaySlider = hours;
	}

	void OnTimeOfDayChanged( float oldValue, float newValue )
	{
		if ( !IsTimeAuthority )
			return;

		ApplyTimeOfDay( newValue );
	}

	void OnStartingTimeOfDayChanged( float oldValue, float newValue )
	{
		if ( !IsEditMode )
			return;

		ApplyTimeOfDay( newValue );
	}
}
