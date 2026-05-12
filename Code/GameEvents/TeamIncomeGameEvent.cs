namespace Sandbox.GameEvents;

/// <summary>
/// Event dispatched when a team is granted income.
/// The income value can be modified by event handlers.
/// </summary>
public record TeamIncomeGameEvent( Team Team ) : IGameEvent
{
	public int Value { get; set; }
}