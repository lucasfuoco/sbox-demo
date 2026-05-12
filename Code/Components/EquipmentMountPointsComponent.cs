using System.Text.Json.Serialization;
using Sandbox.GameEvents;
using Sandbox.GameResources;
using Sandbox.Components.PawnComponents;

namespace Sandbox.Components;

public sealed class EquipmentMountPointsComponent : Component,
	IGameEventHandler<EquipmentDeployedEvent>,
	IGameEventHandler<EquipmentHolsteredEvent>,
	IGameEventHandler<EquipmentDestroyedEvent>
{
	[Property] public PlayerPawnComponent Player { get;  set; }

	[Property] public List<MountPoint> MountPoints { get; set; } = new();

	public MountPoint GetMount( EquipmentComponent equipment )
	{
		var mount = MountPoints.FirstOrDefault( x => x.Slot == equipment.Resource.Slot );
		return mount;
	}

	void IGameEventHandler<EquipmentDeployedEvent>.OnGameEvent( EquipmentDeployedEvent eventArgs )
	{
		var mnt = GetMount( eventArgs.Equipment );
		mnt?.Unmount( eventArgs.Equipment, Player );
	}

	void IGameEventHandler<EquipmentHolsteredEvent>.OnGameEvent( EquipmentHolsteredEvent eventArgs )
	{
		var mnt = GetMount( eventArgs.Equipment );
		Log.Info( $"Holstering {eventArgs.Equipment}, {mnt}" );
		mnt?.Mount( eventArgs.Equipment, Player );
	}

	void IGameEventHandler<EquipmentDestroyedEvent>.OnGameEvent( EquipmentDestroyedEvent eventArgs )
	{
		var mnt = GetMount( eventArgs.Equipment );
		mnt?.Unmount( eventArgs.Equipment, Player );
	}
}
