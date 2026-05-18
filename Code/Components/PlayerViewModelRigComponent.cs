using Sandbox.Attributes;
using Sandbox.Components.PawnComponents;
using Sandbox.Components.WeaponModelComponents;
using Sandbox.GameEvents;

namespace Sandbox.Components;

/// <summary>
/// Per-character viewmodel arms and gloves prefabs (western vs eastern by team).
/// Pair with <see cref="ViewWeaponModelComponent"/> on weapons (weapon prefab arms are editor fallbacks only).
/// </summary>
[Title( "Viewmodel Arms Rig" ), Group( "Player" )]
public sealed class PlayerViewModelRigComponent : Component,
	IGameEventHandler<TeamChangedEvent>
{
	public struct FactionRigEntry
	{
		[Property] public GameObject ArmsPrefab { get; set; }
		[Property] public GameObject GlovesPrefab { get; set; }
	}

	[Property] public PlayerPawnComponent PlayerPawn { get; set; }

	[Property, Group( "Rigs" )] public FactionRigEntry Western { get; set; }
	[Property, Group( "Rigs" )] public FactionRigEntry Eastern { get; set; }

	public ViewModelArmsFaction GetFaction() =>
		PlayerPawn.IsValid() ? PlayerPawn.Team.GetViewModelArmsFaction() : ViewModelArmsFaction.Eastern;

	public FactionRigEntry GetRig( ViewModelArmsFaction faction ) =>
		faction == ViewModelArmsFaction.Western ? Western : Eastern;

	public FactionRigEntry GetRigForTeam( Team team ) =>
		GetRig( team.GetViewModelArmsFaction() );

	public FactionRigEntry GetActiveRig() =>
		GetRig( GetFaction() );

	void IGameEventHandler<TeamChangedEvent>.OnGameEvent( TeamChangedEvent eventArgs )
	{
		if ( !PlayerPawn.IsValid() )
			return;

		RefreshActiveViewWeaponArms();
	}

	/// <summary>
	/// Re-spawns arms/gloves on the locally equipped viewmodel after a team change.
	/// </summary>
	public void RefreshActiveViewWeaponArms()
	{
		if ( !PlayerPawn.IsValid() || !PlayerPawn.IsViewer )
			return;

		var viewModel = PlayerPawn.CurrentEquipment?.ViewWeaponModel;
		if ( !viewModel.IsValid() )
			return;

		viewModel.RefreshArmsRig();
	}
}
