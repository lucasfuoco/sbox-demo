namespace Sandbox.Components;

/// <summary>
/// Root component for a viewmodel arms prefab. Owns the arms mesh, glove profile, and loadout.
/// Spawned under <see cref="WeaponModelComponents.ViewWeaponModelComponent"/>.
/// </summary>
[Title( "Arms Rig" ), Group( "Viewmodel" )]
public sealed class ViewModelArmsRigComponent : Component, Component.ExecuteInEditor
{
	[Property] public SkinnedModelRenderer Arms { get; set; }

	[Property, Group( "Attachments" )]
	public ViewModelArmsProfileComponent ArmsProfile { get; set; }

	public ViewModelArmsLoadoutComponent Loadout { get; private set; }

	protected override void OnAwake()
	{
		ResolveComponents();
		EnsureProfile();
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor )
			return;

		ResolveComponents();
		EnsureProfile();
	}

	public void ResolveComponents()
	{
		if ( !Arms.IsValid() )
			Arms = FindArmsRenderer( GameObject );

		if ( !ArmsProfile.IsValid() )
			ArmsProfile = GetComponentInChildren<ViewModelArmsProfileComponent>();

		Loadout = Components.Get<ViewModelArmsLoadoutComponent>();
		if ( !Loadout.IsValid() )
			Loadout = GetComponentInChildren<ViewModelArmsLoadoutComponent>();
	}

	public void EnsureProfile()
	{
		if ( Game.IsEditor && ArmsProfile.IsValid() )
			ArmsProfile.RebuildProfile();
	}

	/// <summary>
	/// Root for slot meshes (e.g. slot_glove_mechanix_black).
	/// </summary>
	public GameObject GetSlotRoot( string category ) => GameObject;

	static SkinnedModelRenderer FindArmsRenderer( GameObject go )
	{
		if ( !go.IsValid() )
			return null;

		var renderer = go.Components.Get<SkinnedModelRenderer>();
		if ( renderer.IsValid() )
			return renderer;

		return go.Components.GetInChildren<SkinnedModelRenderer>();
	}
}
