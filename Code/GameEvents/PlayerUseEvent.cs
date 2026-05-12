using Sandbox.Valids;

namespace Sandbox.GameEvents;

/// <summary>
/// Called on the player using something, when using something
/// </summary>
public record PlayerUseEvent( IUseValid Object ) : IGameEvent;