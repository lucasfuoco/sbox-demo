using Sandbox.Components.PawnComponents;

namespace Sandbox.GameEvents;

/// <summary>
/// Dispatched on the host when a player starts being spawn protected.
/// </summary>
public record SpawnProtectionStartGameEvent( PlayerPawnComponent Player ) : IGameEvent;