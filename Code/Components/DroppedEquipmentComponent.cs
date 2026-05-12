using Sandbox.Diagnostics;
using Sandbox.GameEvents;
using Sandbox.Attributes;
using Sandbox.Components.PawnComponents;
using Sandbox.GameResources;
using Sandbox.Valids;

namespace Sandbox.Components;

public partial class DroppedEquipmentComponent : Component, IUseValid, Component.ICollisionListener, IMarkerObjectValid
{
	[Property] public EquipmentResource Resource { get; set; }

	public Rigidbody Rigidbody { get; private set; }

	/// <summary>
	/// Creates a world instance of a dropped piece of equipment. Takes in a <see cref="EquipmentResource"/>, position, rotation, and optionally a held weapon to inherit data from.
	/// </summary>
	/// <param name="resource"></param>
	/// <param name="positon"></param>
	/// <param name="rotation"></param>
	/// <param name="heldWeapon"></param>
	/// <param name="networkSpawn"></param>
	/// <returns></returns>
	public static DroppedEquipmentComponent Create( EquipmentResource resource, Vector3 positon, Rotation? rotation = null, EquipmentComponent heldWeapon = null, bool networkSpawn = true )
	{
		Assert.True( Networking.IsHost );

		var go = new GameObject();
		go.WorldPosition = positon;
		go.WorldRotation = rotation ?? Rotation.Identity;
		go.Name = resource.Name;
		go.Tags.Add( "pickup" );

		var wmPrefabFile = resource.MainPrefab.Scene.Source as PrefabFile;
		var worldModel = resource.WorldModel;
		var bounds = worldModel.Bounds;

		var droppedWeapon = go.Components.Create<DroppedEquipmentComponent>();
		droppedWeapon.Resource = resource;

		var renderer = go.Components.Create<SkinnedModelRenderer>();
		renderer.Model = worldModel;

		renderer.BodyGroups |= resource.WorldModelBodyGroups;

		var min = bounds.Mins;
		var max = bounds.Maxs;

		var collider = go.Components.Create<BoxCollider>();
		collider.Scale = new Vector3( max.x - min.x, max.y - min.y, max.z - min.z );
		collider.Center = new Vector3( 0, 0, (max.z - min.z) / 2 );

		droppedWeapon.Rigidbody = go.Components.Create<Rigidbody>();

		go.Components.Create<DestroyBetweenRoundsComponent>();

		if ( resource.Slot == EquipmentSlot.Special )
		{
			Game.ActiveScene.Dispatch( new BombDroppedEvent() );

			SpottableComponent spottable = go.GetComponent<SpottableComponent>();
			spottable.Team = Team.Terrorist;
		}

		Game.ActiveScene.Dispatch( new EquipmentDroppedEvent( droppedWeapon, heldWeapon?.Owner ) );

		if ( heldWeapon is not null )
		{
			foreach ( var state in heldWeapon.GetComponents<IDroppedWeaponState>() )
			{
				state.CopyToDroppedWeapon( droppedWeapon );
			}
		}

		if ( networkSpawn )
		{
			go.NetworkSpawn();
		}

		return droppedWeapon;
	}

	public UseResult CanUse( PlayerPawnComponent player )
	{
		if ( player.Inventory.CanTake( Resource ) == PlayerInventoryComponent.PickupResult.None ) return "Can't pick this up";
		return true;
	}

	private bool _isUsed;

	public void OnUse( PlayerPawnComponent player )
	{
		if ( _isUsed ) return;
		_isUsed = true;

		if ( !player.IsValid() )
			return;

		var currentActiveSlot = player.CurrentEquipment?.Resource.Slot ?? EquipmentSlot.Melee;
		var weapon = player.Inventory.Give( Resource, Resource.Slot < currentActiveSlot );

		if ( !weapon.IsValid() )
			return;

		foreach ( var state in weapon.GetComponents<IDroppedWeaponState>() )
		{
			state.CopyFromDroppedWeapon( this );
		}

		Game.ActiveScene.Dispatch( new EquipmentPickedUpEvent( player, this, weapon ) );

		GameObject.Destroy();
	}

	void ICollisionListener.OnCollisionStart( Collision collision )
	{
		if ( !Networking.IsHost ) return;

		// Conna: this is longer than Daenerys Targaryen's full title.
		if ( collision.Other.GameObject.Root.GetComponentInChildren<PlayerPawnComponent>() is { } player )
		{
			// Don't pickup weapons if we're dead.
			if ( player.HealthComponent.State != LifeState.Alive )
				return;

			// If we last respawned less than 2 seconds ago then don't pickup. This is because
			// we need to give a chance for the owner to update its position. I want to add a way
			// to specify that Transform can be changed on non-owner too (prediction.)
			if ( player.TimeSinceLastRespawn < 2f )
				return;

			if ( player.Inventory.CanTake( Resource ) != PlayerInventoryComponent.PickupResult.Pickup )
				return;

			// Don't auto-pickup if we already have a weapon in this slot.
			if ( player.Inventory.HasInSlot( Resource.Slot ) )
				return;

			OnUse( player );
		}
	}

	/// <summary>
	/// Where is the marker?
	/// </summary>
	Vector3 IMarkerObjectValid.MarkerPosition => WorldPosition + Vector3.Up * 8f;

	/// <summary>
	/// What text?
	/// </summary>
	string IMarkerObjectValid.DisplayText => $"{Resource.Name}";

	float IMarkerObjectValid.MarkerMaxDistance => 128f;

	string IMarkerObjectValid.InputHint => "Use";

	bool IMarkerObjectValid.LookOpacity => false;
}
