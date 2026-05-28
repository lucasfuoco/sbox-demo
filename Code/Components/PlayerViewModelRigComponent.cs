using Sandbox.Attributes;
using Sandbox.Components.PawnComponents;
using Sandbox.Components.WeaponModelComponents;
using Sandbox.GameEvents;

namespace Sandbox.Components;

/// <summary>
/// Per-player viewmodel arms rigs (western vs eastern by team). Arms prefabs are authored on the player,
/// not on weapon viewmodels. Glove slots live on each arms rig prefab.
/// </summary>
[Title( "Viewmodel Arms Rig" ), Group( "Player" )]
public sealed class PlayerViewModelRigComponent : Component,
	IGameEventHandler<TeamChangedEvent>
{
	public struct FactionRigEntry
	{
		/// <summary>
		/// Embedded arms rig instance on the player (not cloned at runtime).
		/// </summary>
		[Property] public GameObject ArmsRigObject { get; set; }
	}

	[Property] public PlayerPawnComponent PlayerPawn { get; set; }

	/// <summary>
	/// Parent to restore arms rigs to when unequipping a weapon.
	/// </summary>
	[Property] public GameObject RigRoot { get; set; }

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

	public ViewModelArmsRigComponent GetActiveArmsRig()
	{
		var entry = GetActiveRig();
		if ( !entry.ArmsRigObject.IsValid() )
			return null;

		return entry.ArmsRigObject.Components.Get<ViewModelArmsRigComponent>()
			?? entry.ArmsRigObject.Components.GetInChildren<ViewModelArmsRigComponent>();
	}

	public void ApplyActiveFactionArms()
	{
		SetFactionArmsEnabled( ViewModelArmsFaction.Western, Western.ArmsRigObject );
		SetFactionArmsEnabled( ViewModelArmsFaction.Eastern, Eastern.ArmsRigObject );
	}

	void SetFactionArmsEnabled( ViewModelArmsFaction faction, GameObject armsObject )
	{
		if ( !armsObject.IsValid() )
			return;

		armsObject.Enabled = GetFaction() == faction;
	}

	public void ReturnArmsToRig( ViewModelArmsRigComponent rig )
	{
		if ( !rig.IsValid() )
			return;

		var root = RigRoot.IsValid() ? RigRoot : PlayerPawn?.GameObject;
		if ( !root.IsValid() )
			return;

		rig.GameObject.SetParent( root );
	}

	void IGameEventHandler<TeamChangedEvent>.OnGameEvent( TeamChangedEvent eventArgs )
	{
		if ( !PlayerPawn.IsValid() )
			return;

		ApplyActiveFactionArms();
		RefreshActiveViewWeaponArms();
	}

	/// <summary>
	/// Re-binds embedded arms on the locally equipped viewmodel after a team change.
	/// </summary>
	public void RefreshActiveViewWeaponArms()
	{
		if ( !PlayerPawn.IsValid() || !PlayerPawn.IsViewer )
			return;

		var viewModel = PlayerPawn.CurrentEquipment?.ViewWeaponModel;
		if ( !viewModel.IsValid() )
			return;
	}
}
