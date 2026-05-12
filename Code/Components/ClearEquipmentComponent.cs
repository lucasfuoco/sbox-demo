using Sandbox.GameEvents;

namespace Sandbox.Components;

/// <summary>
/// Clear all player equipment when entering this state.
/// </summary>
public sealed class ClearEquipmentComponent : Component,
	IGameEventHandler<EnterStateEvent>
{
	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		foreach ( var player in GameUtils.PlayerPawns )
		{
			player.Inventory.Clear();
		}
	}
}