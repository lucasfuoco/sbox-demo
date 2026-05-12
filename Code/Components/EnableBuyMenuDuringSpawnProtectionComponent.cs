using Sandbox.GameEvents;
using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Enable the buy menu for players that are spawn protected.
/// </summary>
public sealed class EnableBuyMenuDuringSpawnProtectionComponent : Component,
	IGameEventHandler<UpdateStateEvent>,
	IGameEventHandler<LeaveStateEvent>
{
	void IGameEventHandler<UpdateStateEvent>.OnGameEvent( UpdateStateEvent eventArgs )
	{
		foreach ( var player in GameUtils.AllPlayers )
		{
			player.BuyMenuMode = player.PlayerPawn is { HealthComponent: { IsGodMode: true } }
				? BuyMenuMode.EnabledEverywhere
				: BuyMenuMode.Disabled;
		}
	}

	void IGameEventHandler<LeaveStateEvent>.OnGameEvent( LeaveStateEvent eventArgs )
	{
		foreach ( var player in GameUtils.AllPlayers )
		{
			player.BuyMenuMode = BuyMenuMode.Disabled;
		}
	}
}
