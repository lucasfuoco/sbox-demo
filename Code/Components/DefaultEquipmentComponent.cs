using Sandbox.GameEvents;
using Sandbox.GameResources;

namespace Sandbox.Components;

public class Loadout
{
	[KeyProperty] public Team Team { get; set; }
	[KeyProperty] public List<EquipmentResource> Equipment { get; set; }
}

public sealed class DefaultEquipmentComponent : Component,
	IGameEventHandler<PlayerSpawnedEvent>
{
	/// <summary>
	/// A weapon set that we'll give the player when they spawn.
	/// </summary>
	[Property] public List<Loadout> TeamLoadouts { get; set; }

	[Property] public int Armor { get; set; }
	[Property] public bool Helmet { get; set; }
	[Property] public bool DefuseKit { get; set; }
	[Property] public bool RefillAmmo { get; set; } = true;
	[Property] public bool LoadoutsEnabled { get; set; } = true;

	public Loadout GetLoadout( Team team )
	{
		if ( TeamLoadouts is null || TeamLoadouts.Count == 0 )
			return null;

		if ( TeamLoadouts.FirstOrDefault( x => x.Team == team ) is { } loadout )
		{
			return loadout;
		}

		return TeamLoadouts.FirstOrDefault();
	}

	public bool Contains( Team team, EquipmentResource resource )
	{
		var loadout = GetLoadout( team );
		if ( loadout is null ) return false;

		return loadout.Equipment is not null && loadout.Equipment.Contains( resource );
	}

	void IGameEventHandler<PlayerSpawnedEvent>.OnGameEvent( PlayerSpawnedEvent eventArgs )
	{
		var loadout = GetLoadout( eventArgs.Player.Team );
		if ( loadout is null )
			return;

		var player = eventArgs.Player;

		if ( LoadoutsEnabled && player.Client.Loadout.Equipment is { } clientEquipment )
		{
			foreach ( var resource in clientEquipment )
			{
				if ( resource is null )
					continue;

				if ( !player.Inventory.HasInSlot( resource.Slot ) )
				{
					player.Inventory.Give( resource, false );
				}
			}
		}

		if ( loadout.Equipment is null )
			return;

		foreach ( var weapon in loadout.Equipment )
		{
			if ( !player.Inventory.HasInSlot( weapon.Slot ) )
				player.Inventory.Give( weapon, false );
		}

		player.Inventory.SwitchToBest();

		player.ArmorComponent.Armor = Math.Max( player.ArmorComponent.Armor, Armor );
		player.ArmorComponent.HasHelmet |= Helmet;

		if ( DefuseKit && player.Team == Team.CounterTerrorist )
		{
			player.Inventory.HasDefuseKit = true;
		}

		if ( RefillAmmo )
		{
			player.Inventory.RefillAmmo();
		}
	}
}
