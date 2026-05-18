using Sandbox.Attributes;
using Sandbox.Components.WeaponModelComponents;

namespace Sandbox.Components;

/// <summary>
/// Applies sleeve and glove selections via prefab slot meshes under the viewmodel Arms object.
/// Profile from <see cref="ViewModelArmsProfileComponent"/>.
/// Prefab children: slot_{category}_{option} (e.g. slot_glove_mechanix_black).
/// </summary>
[Title( "Arms Loadout" ), Group( "Viewmodel" )]
public partial class ViewModelArmsLoadoutComponent : Component, Component.ExecuteInEditor
{
	[Hide, Sync( SyncFlags.FromHost )]
	public NetDictionary<string, string> Selections { get; private set; } = new();

	[Property, Group( "Editor Preview" )]
	public string EditorSleeve { get; set; } = "gorka_1";

	[Property, Group( "Editor Preview" )]
	public string EditorGlove { get; set; } = "mechanix_black";

	ViewWeaponModelComponent _viewModel;
	ViewModelArmsProfile _profile;

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
		if ( !Game.IsEditor )
			return;

		if ( TryInitialize() )
			Apply();
	}

	bool TryInitialize()
	{
		_viewModel ??= GetComponentInParent<ViewWeaponModelComponent>();
		_profile ??= GetComponent<ViewModelArmsProfileComponent>()?.Profile;

		if ( _profile is null )
			return false;

		if ( !_viewModel.IsValid() || !_viewModel.Arms.IsValid() )
			return false;

		if ( string.IsNullOrWhiteSpace( EditorSleeve ) )
			EditorSleeve = _profile.GetDefaultOption( "sleeve" );

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
		if ( Game.IsEditor )
		{
			return category switch
			{
				"sleeve" => EditorSleeve,
				"glove" => EditorGlove,
				_ => _profile?.GetDefaultOption( category ) ?? "none"
			};
		}

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

		if ( Game.IsEditor )
		{
			if ( category == "sleeve" ) EditorSleeve = optionId;
			if ( category == "glove" ) EditorGlove = optionId;
		}
		else
		{
			Selections[category] = optionId;
		}

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
		if ( _profile is null || !_viewModel.IsValid() || !_viewModel.Arms.IsValid() )
			return;

		ApplyMeshVisibility();
	}

	public void ApplyMeshVisibility()
	{
		if ( !_viewModel.IsValid() )
			return;

		foreach ( var slot in _profile.Slots )
		{
			var root = _viewModel.GetSlotRoot( slot.Category );
			if ( !root.IsValid() )
				continue;

			AttachmentSlotUtility.SetSlotVisible( root, slot.Category, GetSelection( slot.Category ) );
		}
	}

	// --- Dev helpers ---

	[DeveloperCommand( "Arms Cycle Sleeve", "Weapons" )]
	private static void DevCycleSleeve() => WithLoadout( l => l.CycleSelection( "sleeve" ) );

	[DeveloperCommand( "Arms Cycle Glove", "Weapons" )]
	private static void DevCycleGlove() => WithLoadout( l => l.CycleSelection( "glove" ) );

	[DeveloperCommand( "Arms Refresh", "Weapons" )]
	private static void DevRefreshArms() => WithLoadout( l =>
	{
		l.Apply();
		Log.Info( $"Arms refreshed: sleeve={l.GetSelection( "sleeve" )}, glove={l.GetSelection( "glove" )}" );
	} );

	static void WithLoadout( Action<ViewModelArmsLoadoutComponent> action )
	{
		var loadout = ClientComponent.Local?.PlayerPawn?.CurrentEquipment?.ViewWeaponModel
			?.GetComponent<ViewModelArmsLoadoutComponent>();

		if ( !loadout.IsValid() )
		{
			Log.Warning( "Current viewmodel has no ViewModelArmsLoadoutComponent." );
			return;
		}

		action( loadout );
	}
}
