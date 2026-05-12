namespace Sandbox.GameEvents;

public record TeamScoreIncrementedEvent( Team Team, int Score ) : IGameEvent;