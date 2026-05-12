namespace Sandbox.GameEvents;

/// <summary>
/// Called on the host to clean up objects that shouldn't persist between rounds.
/// </summary>
public record BetweenRoundCleanupEvent : IGameEvent;
