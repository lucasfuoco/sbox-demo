namespace Sandbox.Components.EquipmentComponents.WeaponInputActionEquipmentComponents.AimableWeaponInputActionEquipmentComponents;

public interface IViewWeaponModelOffset
{
	public Vector3 PositionOffset { get; }
	public Angles AngleOffset { get; }
}

[Title( "ADS (w/ Aim Offset)" ), Group( "Weapon Components" )]
public partial class ManualOffsetAimableWeaponInputActionEquipmentComponent : AimableWeaponInputActionEquipmentComponent, IViewWeaponModelOffset
{
	[Property] public Vector3 AimOffset { get; set; }
	[Property] public Angles AimAngleOffset { get; set; }

	Vector3 IViewWeaponModelOffset.PositionOffset => IsAiming ? AimOffset : Vector3.Zero;
	Angles IViewWeaponModelOffset.AngleOffset => IsAiming ? AimAngleOffset : Angles.Zero;
}
