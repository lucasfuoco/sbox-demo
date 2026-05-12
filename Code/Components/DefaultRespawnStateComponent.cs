namespace Sandbox.Components;

public sealed class DefaultRespawnStateComponent : Component
{
	[Property] public RespawnState RespawnState { get; set; } = RespawnState.Delayed;
}
