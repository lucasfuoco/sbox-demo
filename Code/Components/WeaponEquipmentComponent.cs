using Sandbox.Components.PawnComponents;

namespace Sandbox.Components;

/// <summary>
/// A weapon component. This can be anything that controls a weapon. Aiming, recoil, sway, shooting..
/// </summary>
[Icon( "track_changes" )]
public abstract class WeaponEquipmentComponent : Component
{
	/// <summary>
	/// The weapon.
	/// </summary>
	protected EquipmentComponent Equipment { get; set; }

	/// <summary>
	/// The player.
	/// </summary>
	protected PlayerPawnComponent Player => Equipment.Owner;

	protected void BindTag( string tag, Func<bool> predicate ) => Equipment.BindTag( tag, predicate );

	protected void SetTagFor( string tag, float time )
	{
		Equipment.SetTag( tag, true );

		Invoke( time, () =>
		{
			Equipment.SetTag( tag, false );
		} );
	}

	protected override void OnAwake()
	{
		// Cache the weapon on awake
		Equipment = GetComponentInParent<EquipmentComponent>();

		base.OnAwake();
	}
}

/// <summary>
/// Show this property in the equipment resource editor.
/// </summary>
[AttributeUsage( AttributeTargets.Property )]
public sealed class EquipmentResourcePropertyAttribute : Attribute
{

}
