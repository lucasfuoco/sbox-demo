using Sandbox.Components;

namespace Sandbox.GameEvents;

/// <summary>
/// Event dispatched on the host when a <see cref="StateMachineComponent"/> changes state.
/// Only invoked on components on the same object as the new state.
/// </summary>
public record EnterStateGameEvent( StateComponent State ) : IGameEvent;