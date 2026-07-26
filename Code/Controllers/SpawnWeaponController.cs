using Sandbox.Components;
using Sandbox.GameEvents;
using Sandbox.GameResources;

namespace Sandbox.Controllers;

/// <summary>
/// Gives every player a configured weapon when they spawn.
/// </summary>
[Title( "Spawn Weapon" ), Category( "Gameplay" )]
public sealed class SpawnWeaponController : Component,
	IGameEventHandler<PlayerSpawnedEvent>
{
	[Property, Group( "Loadout" )]
	public EquipmentResource Weapon { get; set; }

	void IGameEventHandler<PlayerSpawnedEvent>.OnGameEvent( PlayerSpawnedEvent eventArgs )
	{
		if ( !Networking.IsHost || Weapon is null )
			return;

		var player = eventArgs.Player;
		if ( !player.IsValid() || !player.Inventory.IsValid() )
			return;

		var equipment = player.Inventory.Equipment
			.FirstOrDefault( item => item.IsValid() && item.Resource == Weapon );

		equipment ??= player.Inventory.Give( Weapon, true );
		if ( equipment.IsValid() )
			player.Inventory.Switch( equipment );

		player.Inventory.RefillAmmo();
	}
}
