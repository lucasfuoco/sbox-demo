using Sandbox.Components;

namespace Sandbox;

/// <summary>
/// Interface for components on weapons that persist when dropped.
/// </summary>
public interface IDroppedWeaponState
{
	void CopyToDroppedWeapon( DroppedEquipmentComponent dropped );
	void CopyFromDroppedWeapon( DroppedEquipmentComponent dropped );
}

/// <summary>
/// Interface for components on weapons that persist when dropped.
/// Default implementation will create a copy of this component on the dropped weapon, then copy it back on pickup.
/// </summary>
public interface IDroppedWeaponState<T> : IDroppedWeaponState
	where T : Component, IDroppedWeaponState<T>, new()
{
	void IDroppedWeaponState.CopyToDroppedWeapon( DroppedEquipmentComponent dropped )
	{
		var state = dropped.GetOrAddComponent<T>();

		((T)this).CopyPropertiesTo( state );
	}

	void IDroppedWeaponState.CopyFromDroppedWeapon( DroppedEquipmentComponent dropped )
	{
		if ( dropped.GetComponent<T>() is {} state )
		{
			state.CopyPropertiesTo( (T) this );
		}
	}
}