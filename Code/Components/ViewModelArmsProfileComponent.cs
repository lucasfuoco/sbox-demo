using Sandbox;

namespace Sandbox.Components;

/// <summary>
/// Builds an arms profile from assigned <see cref="ViewModelArmsSlotComponent"/> references.
/// Assign on <see cref="ViewModelArmsRigComponent"/>; pair with <see cref="ViewModelArmsLoadoutComponent"/>.
/// </summary>
[Title( "Arms Profile" ), Group( "Viewmodel" )]
public class ViewModelArmsProfileComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Slots" )] public ViewModelArmsSlotComponent Glove { get; set; }

	public ViewModelArmsProfile Profile { get; private set; }

	protected override void OnAwake() => RebuildProfile();

	protected override void OnValidate()
	{
		if ( Game.IsEditor )
			RebuildProfile();
	}

	public void RebuildProfile()
	{
		Profile = BuildFromAssignedSlots();
	}

	ViewModelArmsProfile BuildFromAssignedSlots()
	{
		var profile = new ViewModelArmsProfile();

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

	public IEnumerable<ViewModelArmsSlotComponent> GetAssignedSlots()
	{
		yield return Glove;
	}
}
