namespace Sandbox.Components;

/// <summary>
/// Root component for a viewmodel arms prefab. Owns the arms mesh, glove profile, and loadout.
/// Spawned under <see cref="WeaponModelComponents.ViewWeaponModelComponent"/>.
/// </summary>
[Title( "Arms Rig" ), Group( "Viewmodel" )]
public sealed class ViewModelArmsRigComponent : Component, Component.ExecuteInEditor
{
	[Property] public SkinnedModelRenderer Arms { get; set; }

	[Property, Group( "Bone Merge" )]
	public bool UseBoneMerge { get; set; } = true;

	/// <summary>
	/// When set, arms merge to this renderer instead of the parent weapon mesh.
	/// Useful for editor preview or rigs that need a specific merge target.
	/// </summary>
	[Property, Group( "Bone Merge" )]
	public SkinnedModelRenderer BoneMergeTarget { get; set; }

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
		ApplyBoneMerge( GetParentWeaponRenderer( this ) );
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
	/// Binds <see cref="Arms"/> to a weapon renderer for bone merge, or clears merge when disabled.
	/// Uses <see cref="BoneMergeTarget"/> when set, otherwise <paramref name="weaponRenderer"/>.
	/// </summary>
	public void ApplyBoneMerge( SkinnedModelRenderer weaponRenderer = null )
	{
		if ( !Arms.IsValid() )
			return;

		if ( !UseBoneMerge )
		{
			Arms.BoneMergeTarget = null;
			return;
		}

		var target = BoneMergeTarget;
		if ( !target.IsValid() )
			target = weaponRenderer;

		if ( !target.IsValid() )
			return;

		Arms.BoneMergeTarget = target;
	}

	/// <summary>
	/// Root for slot meshes (e.g. slot_glove_mechanix_black).
	/// </summary>
	public GameObject GetSlotRoot( string category ) => GameObject;

	static SkinnedModelRenderer GetParentWeaponRenderer( Component rig )
	{
		var viewModel = rig.GetComponentInParent<WeaponModelComponents.ViewWeaponModelComponent>();
		if ( !viewModel.IsValid() )
			return null;

		return viewModel.GameObject.Components.Get<SkinnedModelRenderer>();
	}

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
