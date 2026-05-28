using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Applies arms and glove selections via prefab slot meshes on the arms rig.
/// Profile from <see cref="ViewModelArmsRigComponent.ArmsProfile"/>.
/// </summary>
[Title( "Arms Loadout" ), Group( "Viewmodel" )]
public partial class ViewModelArmsLoadoutComponent : Component, Component.ExecuteInEditor
{
	[Hide, Sync( SyncFlags.FromHost )]
	public NetDictionary<string, string> Selections { get; private set; } = new();

	[Property, Group( "Editor Preview" )]
	public string EditorArms { get; set; } = "eastern";

	[Property, Group( "Editor Preview" )]
	public string EditorGlove { get; set; } = "mechanix_black";

	ViewModelArmsRigComponent _armsRig;
	ViewModelArmsProfile _profile;
	bool _validating;

	protected override void OnStart()
	{
		if ( !TryInitialize() )
			return;

		EnsureDefaultSelections();
		Apply();
	}

	protected override void OnEnabled()
	{
		if ( !Game.IsEditor )
			return;

		if ( TryInitialize() )
			Apply();
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor || _validating )
			return;

		_validating = true;
		try
		{
			if ( TryInitialize() )
				Apply();
		}
		finally
		{
			_validating = false;
		}
	}

	bool TryInitialize()
	{
		_armsRig ??= GetComponent<ViewModelArmsRigComponent>()
			?? GetComponentInParent<ViewModelArmsRigComponent>();

		if ( !_armsRig.IsValid() )
			return false;

		_armsRig.ResolveComponents();

		if ( Game.IsEditor )
			_armsRig.EnsureProfile();

		_profile ??= _armsRig.ArmsProfile?.Profile;

		if ( _profile is null )
			return false;

		if ( !_armsRig.Arms.IsValid() )
			return false;

		if ( string.IsNullOrWhiteSpace( EditorArms ) )
			EditorArms = _profile.GetDefaultOption( "arms" );

		if ( string.IsNullOrWhiteSpace( EditorGlove ) )
			EditorGlove = _profile.GetDefaultOption( "glove" );

		return true;
	}

	void EnsureDefaultSelections()
	{
		if ( _profile is null )
			return;

		foreach ( var slot in _profile.Slots )
		{
			if ( !Selections.ContainsKey( slot.Category ) )
				Selections[slot.Category] = slot.DefaultOption;
		}
	}

	public string GetSelection( string category )
	{
		if ( Game.IsEditor && category.Equals( "arms", StringComparison.OrdinalIgnoreCase ) )
			return EditorArms;

		if ( Game.IsEditor && category.Equals( "glove", StringComparison.OrdinalIgnoreCase ) )
			return EditorGlove;

		if ( Selections.TryGetValue( category, out var selected ) )
			return selected;

		return _profile?.GetDefaultOption( category ) ?? "none";
	}

	public void SetSelection( string category, string optionId )
	{
		if ( _profile is null )
			return;

		var slot = _profile.GetSlot( category );
		if ( slot is null || slot.FindOption( optionId ) is null )
			return;

		if ( Game.IsEditor && category.Equals( "arms", StringComparison.OrdinalIgnoreCase ) )
			EditorArms = optionId;
		else if ( Game.IsEditor && category.Equals( "glove", StringComparison.OrdinalIgnoreCase ) )
			EditorGlove = optionId;
		else
			Selections[category] = optionId;

		Apply();
	}

	public void CycleSelection( string category )
	{
		if ( _profile is null )
			return;

		var slot = _profile.GetSlot( category );
		if ( slot is null || slot.Options.Count == 0 )
			return;

		var options = slot.Options.Select( o => o.Id ).ToList();
		var current = GetSelection( category );
		var index = options.FindIndex( o => o.Equals( current, StringComparison.OrdinalIgnoreCase ) );
		var next = options[(index + 1) % options.Count];
		SetSelection( category, next );
	}

	public void Apply()
	{
		if ( _profile is null || !_armsRig.IsValid() || !_armsRig.Arms.IsValid() )
			return;

		ApplyMeshVisibility();
	}

	public void ApplyMeshVisibility()
	{
		if ( !_armsRig.IsValid() )
			return;

		foreach ( var slot in _profile.Slots )
		{
			var root = _armsRig.GetSlotRoot( slot.Category );
			if ( !root.IsValid() )
				continue;

			var activeOption = GetSelection( slot.Category );
			var slotComponent = root.Components.Get<ViewModelArmsSlotComponent>();
			if ( slotComponent.IsValid() )
			{
				foreach ( var option in slotComponent.GetOptionComponents() )
				{
					if ( !option.IsValid() )
						continue;

					var isActive = option.OptionId.Equals( activeOption, StringComparison.OrdinalIgnoreCase );
					option.GameObject.Enabled = isActive;

					foreach ( var renderer in option.GameObject.Components.GetAll<SkinnedModelRenderer>( FindMode.EverythingInSelf ) )
						renderer.Enabled = isActive;
				}

				continue;
			}

			AttachmentSlotUtility.SetSlotVisible( root, slot.Category, activeOption );
		}
	}

	// --- Dev helpers ---

	[DeveloperCommand( "Arms Cycle Arms", "Weapons" )]
	private static void DevCycleArms() => WithLoadout( l => l.CycleSelection( "arms" ) );

	[DeveloperCommand( "Arms Cycle Glove", "Weapons" )]
	private static void DevCycleGlove() => WithLoadout( l => l.CycleSelection( "glove" ) );

	[DeveloperCommand( "Arms Refresh", "Weapons" )]
	private static void DevRefreshArms() => WithLoadout( l =>
	{
		l.Apply();
		Log.Info( $"Arms refreshed: arms={l.GetSelection( "arms" )}, glove={l.GetSelection( "glove" )}" );
	} );

	static void WithLoadout( Action<ViewModelArmsLoadoutComponent> action )
	{
		var loadout = ClientComponent.Local?.PlayerPawn?.CurrentEquipment?.ViewWeaponModel?.ArmsRig?.Loadout;

		if ( !loadout.IsValid() )
		{
			Log.Warning( "Current viewmodel has no arms loadout." );
			return;
		}

		action( loadout );
	}
}
