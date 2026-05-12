namespace Sandbox.GameEvents;

public record OnScoreAddedEvent : IGameEvent
{
	public int Score { get; set; }
	public string Reason { get; set; }
}