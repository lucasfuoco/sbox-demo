using Sandbox.GameEvents;
using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Starting money for new players.
/// </summary>
public sealed class DefaultBalanceComponent : Component,
	IGameEventHandler<TeamAssignedEvent>
{
	[Property]
	public int Value { get; set; } = 800;

	void IGameEventHandler<TeamAssignedEvent>.OnGameEvent( TeamAssignedEvent eventArgs )
	{
		eventArgs.Player.SetCash( Value );
	}
}
