namespace Sandbox.GameEvents;

/// <summary>
/// Event dispatched on the host when <see cref="RoundCounter"/> should be reset.
/// </summary>
public record RoundCounterResetEvent : IGameEvent;

/// <summary>
/// Event dispatched on the host when <see cref="RoundCounter"/> should be incremented.
/// </summary>
public record RoundCounterIncrementedEvent : IGameEvent;