using Sandbox.Components;

namespace Sandbox.GameEvents;

/// <summary>
/// Event dispatched on the host every fixed update while a <see cref="StateComponent"/> is active.
/// Only invoked on components on the same object as the state.
/// </summary>
public record UpdateStateGameEvent( StateComponent State ) : IGameEvent;