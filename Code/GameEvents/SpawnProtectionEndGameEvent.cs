using Sandbox.Components.PawnComponents;

namespace Sandbox.GameEvents;

/// <summary>
/// Dispatched on the host when a player stops being spawn protected.
/// </summary>
public record SpawnProtectionEndGameEvent( PlayerPawnComponent Player ) : IGameEvent;