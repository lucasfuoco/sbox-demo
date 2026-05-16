namespace Sandbox.Components;

/// <summary>
/// An ammo container. It holds ammo for a weapon.
/// </summary>
[Title( "Ammo" ), Group( "Weapon Components" )]
public partial class WeaponAmmoComponent : Component, IDroppedWeaponState<WeaponAmmoComponent>
{
	/// <summary>
	/// How much ammo are we holding?
	/// </summary>
	[Property, Sync] public int Ammo
	{
		get => _ammo;
		set => _ammo = Math.Max( 0, value );
	}
	private int _ammo;

	[Property] public int MaxAmmo { get; set; } = 30;

	/// <summary>
	/// Do we have any ammo?
	/// </summary>
	[Property] public bool HasAmmo => Ammo > 0;

	/// <summary>
	/// Is this container full?
	/// </summary>
	public bool IsFull => Ammo == MaxAmmo;
}
