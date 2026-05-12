using Sandbox.GameEvents;
using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Give the specified team the given amount of income.
/// </summary>
public sealed class GiveTeamIncomeComponent : Component,
	IGameEventHandler<EnterStateEvent>
{
	[Property]
	public Team Team { get; set; }

	[Property]
	public int Value { get; set; } = 3250;

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		var incomeEventArgs = new TeamIncomeGameEvent( Team ) { Value = Value };

		Scene.Dispatch( incomeEventArgs );

		foreach ( var player in GameUtils.GetPlayers( Team ) )
		{
			player.GiveCash( incomeEventArgs.Value );
		}
	}
}
