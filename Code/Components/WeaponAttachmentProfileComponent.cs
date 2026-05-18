using Sandbox;
using Sandbox.GameResources;

namespace Sandbox.Components;

/// <summary>
/// Builds a weapon attachment profile from assigned <see cref="WeaponAttachmentSlotComponent"/> references.
/// Pair with <see cref="WeaponAttachmentLoadoutComponent"/> on the weapon equipment.
/// </summary>
[Title( "Attachment Profile" ), Group( "Weapon Components" )]
public class WeaponAttachmentProfileComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Perk { get; set; }
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Stock { get; set; }
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Mag { get; set; }
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Grip { get; set; }
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Muzzle { get; set; }
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Sight { get; set; }
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Barrel { get; set; }
	[Property, Group( "Slots" )] public WeaponAttachmentSlotComponent Laser { get; set; }

	[Property, Group( "Sounds" )] public SoundEvent StandardShootSound { get; set; }
	[Property, Group( "Sounds" )] public SoundEvent SuppressedShootSound { get; set; }

	public WeaponAttachmentProfile Profile { get; private set; }

	protected override void OnAwake() => RebuildProfile();

	protected override void OnValidate()
	{
		if ( Game.IsEditor )
			RebuildProfile();
	}

	public void RebuildProfile()
	{
		Profile = BuildFromAssignedSlots();

		if ( StandardShootSound.IsValid() )
			Profile.StandardShootSound = StandardShootSound;

		if ( SuppressedShootSound.IsValid() )
			Profile.SuppressedShootSound = SuppressedShootSound;
	}

	WeaponAttachmentProfile BuildFromAssignedSlots()
	{
		var profile = new WeaponAttachmentProfile();

		foreach ( var slot in GetAssignedSlots() )
		{
			if ( !slot.IsValid() )
				continue;

			var definition = slot.ToDefinition();
			if ( definition.Options.Count == 0 )
				continue;

			profile.Slots.Add( definition );
		}

		return profile;
	}

	public IEnumerable<WeaponAttachmentSlotComponent> GetAssignedSlots()
	{
		yield return Perk;
		yield return Stock;
		yield return Mag;
		yield return Grip;
		yield return Muzzle;
		yield return Sight;
		yield return Barrel;
		yield return Laser;
	}
}
