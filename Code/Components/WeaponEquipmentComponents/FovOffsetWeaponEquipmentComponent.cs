using Sandbox.GameEvents;

namespace Sandbox.Components.WeaponEquipmentComponents;

[Title( "On Shot - FOV Offset" ), Icon( "pending" ), Group( "Weapon Components" )]
public class FovOffsetWeaponEquipmentComponent : WeaponEquipmentComponent, IGameEventHandler<WeaponShotEvent>
{
	[Property] public float Length { get; set; } = 0.3f;
	[Property] public float Size { get; set; } = 1.05f;
	[Property] public Curve Curve { get; set; }

	void IGameEventHandler<WeaponShotEvent>.OnGameEvent( WeaponShotEvent eventArgs )
	{
		var shake = new ScreenShake.Fov( Length, Size, Curve );
		ScreenShakerComponent.Main?.Add( shake );
	}
}
