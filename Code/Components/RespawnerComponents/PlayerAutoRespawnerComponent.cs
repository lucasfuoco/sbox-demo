using Sandbox.GameEvents;

namespace Sandbox.Components.RespawnerComponents;

/// <summary>
/// Respawn players after a delay.
/// </summary>
public sealed class PlayerAutoRespawnerComponent : RespawnerComponent,
	IGameEventHandler<UpdateStateGameEvent>
{
}
