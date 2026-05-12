using Sandbox.GameEvents;
using Sandbox.GameResources;
using Sandbox.Components.PawnComponents;
using Sandbox.Components.PawnCameraControllerComponents;
using Sandbox.Components.WeaponModelComponents;
using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// An equipment component.
/// </summary>
public partial class EquipmentComponent : Component, Component.INetworkListener, IDescription
{
	/// <summary>
	/// A reference to the equipment's <see cref="EquipmentResource"/>.
	/// </summary>
	[Property, Group( "Resources" )] public EquipmentResource Resource { get; set; }

	/// <summary>
	/// A tag binder for this equipment.
	/// </summary>
	[RequireComponent] public TagBinderComponent TagBinder { get; set; }

	/// <summary>
	/// Shorthand to bind a tag.
	/// </summary>
	/// <param name="tag"></param>
	/// <param name="predicate"></param>
	internal void BindTag( string tag, Func<bool> predicate ) => TagBinder.BindTag( tag, predicate );

	/// <summary>
	/// The default holdtype for this equipment.
	/// </summary>
	[Property, Group( "Animation" )] protected AnimationHelperComponent.HoldTypes HoldType { get; set; } = AnimationHelperComponent.HoldTypes.Rifle;

	/// <summary>
	/// The default holdtype for this equipment.
	/// </summary>
	[Property, Group( "Animation" )] public AnimationHelperComponent.Hand Handedness { get; set; } = AnimationHelperComponent.Hand.Right;

	/// <summary>
	/// What sound should we play when taking this gun out?
	/// </summary>
	[Property, Group( "Sounds" )] public SoundEvent DeploySound { get; set; }

	/// <summary>
	/// How slower do we walk with this equipment out?
	/// </summary>
	[Property, Group( "Movement" )] public float SpeedPenalty { get; set; } = 0f;

	/// <summary>
	/// What prefab should we spawn as the mounted version of this piece of equipment?
	/// </summary>
	[Property, Group( "Mount Points" )] public GameObject MountedPrefab { get; set; }

	/// <summary>
	/// Should we enable the crosshair?
	/// </summary>
	[Property, Group( "UI" )] public bool UseCrosshair { get; set; } = true;

	/// <summary>
	/// What type of crosshair do we wanna use
	/// </summary>
	[Property, Group( "UI" )] public CrosshairType CrosshairType { get; set; } = CrosshairType.Default;

	/// <summary>
	/// The <see cref="PlayerPawn"/> who owns this.
	/// </summary>
	[Sync( SyncFlags.FromHost )] public PlayerPawnComponent Owner { get; set; }

	/// <summary>
	/// What flags do we have?
	/// </summary>
	[Sync] protected NetList<string> EquipmentTags { get; set; } = new();

	public bool HasTag( string tag )
	{
		return EquipmentTags.Contains( tag );
	}

	public void SetTag( string tag, bool value = true )
	{
		if ( value && !HasTag( tag ) ) EquipmentTags.Add( tag );
		if ( !value && HasTag( tag ) ) EquipmentTags.Remove( tag );

		GameObject.Dispatch( new EquipmentTagChanged( this, tag, value ) );
	}

	public void ToggleTag( string tag )
	{
		SetTag( tag, !HasTag( tag ) );
	}

	// IDescription
	string IDescription.DisplayName => Resource.Name;
	// string IDescription.Icon => Resource.Icon;

	/// <summary>
	/// Is this equipment currently deployed by the player?
	/// </summary>
	[Sync, Change( nameof( OnIsDeployedPropertyChanged ) )]
	public bool IsDeployed { get; private set; }
	private bool _wasDeployed { get; set; }
	private bool _hasStarted { get; set; }

	[DeveloperCommand( "Toggle View Model", "Visuals" )]
	private static void ToggleViewModel()
	{
		var player = ClientComponent.Local.PlayerPawn;

		player.CurrentEquipment.ViewWeaponModel.ModelRenderer.Enabled = !player.CurrentEquipment.ViewWeaponModel.ModelRenderer.Enabled;
		player.CurrentEquipment.ViewWeaponModel.Arms.Enabled = !player.CurrentEquipment.ViewWeaponModel.Arms.Enabled;
	}

	/// <summary>
	/// Updates the render mode, if we're locally controlling a player, we want to hide the world model.
	/// </summary>
	public void UpdateRenderMode( bool force = false )
	{
		if ( WorldWeaponModel.IsValid() )
		{
			WorldWeaponModel.Enabled = IsDeployed || force;
		}
	}

	private ViewWeaponModelComponent viewWeaponModel;

	/// <summary>
	/// A reference to the equipment's <see cref="ViewWeaponModelComponent"/> if it has one.
	/// </summary>
	public ViewWeaponModelComponent ViewWeaponModel
	{
		get => viewWeaponModel;
		set
		{
			viewWeaponModel = value;

			if ( viewWeaponModel.IsValid() )
			{
				viewWeaponModel.Equipment = this;
			}
		}
	}

	void INetworkListener.OnDisconnected( Connection connection )
	{
		if ( !Networking.IsHost )
			return;

		if ( !Resource.DropOnDisconnect )
			return;

		var player = GameUtils.PlayerPawns.FirstOrDefault( x => x.Network.Owner == connection );
		if ( !player.IsValid() ) return;

		DroppedEquipmentComponent.Create( Resource, player.WorldPosition + Vector3.Up * 32f, Rotation.Identity, this );
	}

	/// <summary>
	/// Deploy this equipment.
	/// </summary>
	[Rpc.Owner]
	public void Deploy()
	{
		if ( IsDeployed )
			return;

		// We must first holster all other equipment items.
		if ( Owner.IsValid() )
		{
			var equipment = Owner.Inventory.Equipment.ToList();

			foreach ( var item in equipment )
				item.Holster();
		}

		IsDeployed = true;
	}

	/// <summary>
	/// Holster this equipment.
	/// </summary>
	[Rpc.Owner]
	public void Holster()
	{
		if ( !IsDeployed )
			return;

		IsDeployed = false;
	}

	/// <summary>
	/// Allow equipment to override holdtypes at any notice.
	/// </summary>
	/// <returns></returns>
	public virtual AnimationHelperComponent.HoldTypes GetHoldType()
	{
		return HoldType;
	}

	private void OnIsDeployedPropertyChanged( bool oldValue, bool newValue )
	{
		// Conna: If `OnStart` hasn't been called yet, don't do anything. It'd be nice to have a property on
		// a Component that can indicate this.
		if ( !_hasStarted ) return;
		UpdateDeployedState();
	}

	private void UpdateDeployedState()
	{
		if ( IsDeployed == _wasDeployed )
			return;

		switch ( _wasDeployed )
		{
			case false when IsDeployed:
				OnDeployed();
				break;
			case true when !IsDeployed:
				OnHolstered();
				break;
		}

		_wasDeployed = IsDeployed;
	}

	public void DestroyViewWeaponModel()
	{
		if ( ViewWeaponModel.IsValid() )
			ViewWeaponModel.GameObject.Destroy();
	}

	public WorldWeaponModelComponent WorldWeaponModel { get; set; }

	protected void CreateWorldWeaponModel()
	{
		DestroyWorldWeaponModel();

		if ( Resource.WorldModelPrefab is null )
		{
			return;
		}

		var parentBone = Owner.HoldGameObject;
		var wm = Resource.WorldModelPrefab.Clone( new CloneConfig { Parent = parentBone, StartEnabled = false, Transform = global::Transform.Zero } );

		wm.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
		wm.Enabled = true;

		WorldWeaponModel = wm.GetComponent<WorldWeaponModelComponent>();
	}

	protected void DestroyWorldWeaponModel()
	{
		WorldWeaponModel?.DestroyGameObject();
		WorldWeaponModel = null;
	}

	/// <summary>
	/// Creates a viewweaponmodel for the player to use.
	/// </summary>
	public void CreateViewWeaponModel( bool playDeployEffects = true )
	{
		var player = Owner;
		if ( !player.IsValid() ) return;

		var resource = Resource;

		DestroyViewWeaponModel();
		UpdateRenderMode();

		if ( resource.ViewModelPrefab.IsValid() )
		{
			// Create the equipment prefab and put it on the equipment gameobject.
			var viewWeaponModelGameObject = resource.ViewModelPrefab.Clone( new CloneConfig()
			{
				Transform = new(),
				Parent = GameObject,
				StartEnabled = true,
			} );

			viewWeaponModelGameObject.Flags |= GameObjectFlags.Absolute;

			var viewWeaponModelComponent = viewWeaponModelGameObject.GetComponent<ViewWeaponModelComponent>();
			if ( !viewWeaponModelComponent.IsValid() )
				return;

			viewWeaponModelComponent.PlayDeployEffects = playDeployEffects;

			ViewWeaponModel = viewWeaponModelComponent;

			viewWeaponModelGameObject.BreakFromPrefab();
		}

		if ( !playDeployEffects )
			return;

		if ( DeploySound is null )
			return;

		var snd = Sound.Play( DeploySound, WorldPosition );
		if ( !snd.IsValid() ) return;

		snd.SpacialBlend = Owner.IsViewer ? 0 : snd.SpacialBlend;
	}

	protected override void OnStart()
	{
		_wasDeployed = IsDeployed;
		_hasStarted = true;

		if ( IsDeployed )
			OnDeployed();
		else
			OnHolstered();
	}

	[Sync] bool HasCreatedViewModel { get; set; } = false;


	[Property, Group( "Extras" )]
	public float AimFovOffset { get; set; } = -5;

	protected virtual void OnDeployed()
	{
		if ( Owner.IsValid() && Owner.IsViewer && Owner.CameraController.Mode == CameraMode.FirstPerson )
			CreateViewWeaponModel( !HasCreatedViewModel );

		if ( !IsProxy )
			HasCreatedViewModel = true;

		UpdateRenderMode();

		CreateWorldWeaponModel();

		GameObject.Root.Dispatch( new EquipmentDeployedEvent( this ) );
	}

	protected virtual void OnHolstered()
	{
		UpdateRenderMode();
		DestroyWorldWeaponModel();
		DestroyViewWeaponModel();

		HasCreatedViewModel = false;

		GameObject.Root.Dispatch( new EquipmentHolsteredEvent( this ) );
	}

	protected override void OnDestroy()
	{
		DestroyViewWeaponModel();

		GameObject.Root.Dispatch( new EquipmentDestroyedEvent( this ) );
	}
}
