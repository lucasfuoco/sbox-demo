using Sandbox;
using Sandbox.Components;
using Sandbox.GameEvents;
using Sandbox.Components.PawnComponents;
using Sandbox.SceneEvents;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents.AimableWeaponInputActionEquipmentComponents;
using Sandbox.GameResources;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents;

namespace Sandbox.Components.WeaponModelComponents;

/// <summary>
/// A weapon's viewmodel. It's responsibility is to listen to events from a weapon.
/// It should only exist on the client for the currently possessed pawn.
/// </summary>
public partial class ViewWeaponModelComponent : WeaponModelComponent, ICameraSetup, IGameEventHandler<PlayerUseEvent>, Component.ExecuteInEditor
{
	/// <summary>
	/// A reference to the <see cref="Equipment"/> we want to listen to.
	/// </summary>
	public EquipmentComponent Equipment { get; set; }

	/// <summary>
	/// The resource
	/// </summary>
	public EquipmentResource Resource { get; set; }

	/// <summary>
	/// Arms rig prefab (sleeves, profile, loadout). Spawned as a child at runtime.
	/// </summary>
	[Property, Group( "Prefabs" )] public GameObject ArmsPrefab { get; set; }

	/// <summary>
	/// Optional glove slot prefab, parented under the arms instance when spawned.
	/// </summary>
	[Property, Group( "Prefabs" )] public GameObject GlovesPrefab { get; set; }

	/// <summary>
	/// Spawned arms instance. Use for slot authoring root (sleeves).
	/// </summary>
	public GameObject ArmsInstance { get; private set; }

	/// <summary>
	/// Spawned gloves instance when <see cref="GlovesPrefab"/> is set.
	/// </summary>
	public GameObject GlovesInstance { get; private set; }

	/// <summary>
	/// Arms mesh used for the anim graph. Resolved from <see cref="ArmsPrefab"/> or an embedded Arms child.
	/// </summary>
	public SkinnedModelRenderer Arms { get; private set; }

	/// <summary>
	/// Is this a throwable?
	/// </summary>
	[Property, Group( "Configuration" )] public bool IsThrowable { get; set; }

	/// <summary>
	/// Looks up the tree to find the player controller.
	/// </summary>
	PlayerPawnComponent Owner => Equipment.IsValid() ? Equipment.Owner : null;

	[Property, Range( 0, 1 ), Group( "Configuration" )] public float IronsightsFireScale { get; set; } = 0.2f;
	[Property, Group( "Configuration" )] public bool UseMovementInertia { get; set; } = true;

	[Property]
	public float ReloadSpeed { get; set; } = 1f;

	private float YawInertiaScale => 2f;
	private float PitchInertiaScale => -2f;
	private bool activateInertia = false;
	private float lastPitch;
	private float lastYaw;
	private float YawInertia;
	private float PitchInertia;

	IEnumerable<IViewWeaponModelOffset> Offsets => Equipment.GetComponentsInChildren<IViewWeaponModelOffset>();

	void ICameraSetup.Setup( CameraComponent cc )
	{
		if ( !Owner.IsValid() || !Owner.CharacterController.IsValid() )
			return;

		WorldPosition = cc.WorldPosition;
		WorldRotation = cc.WorldRotation;

		ApplyInertia();
		ApplyOffsets();

		if ( IsThrowable )
		{
			ApplyThrowableAnimations();
		}
		else
		{
			ApplyAnimationParameters();
		}

		ApplyVelocity();
		ApplyAnimationTransform();

		var baseFov = GameSettingsSystem.Current.FieldOfView;

		TargetFieldOfView = TargetFieldOfView.LerpTo( baseFov + FieldOfViewOffset, Time.Delta * 10f );
		FieldOfViewOffset = 0;
	}

	protected override void OnAwake()
	{
		SetOnAnimGraphRenderers( "b_deploy_skip", true );
	}

	protected override void OnStart()
	{
		EnsureRigPrefabs();
		ResolveAttachmentPoints();

		// Somehow?
		if ( Owner.IsValid() )
			Owner.OnJump += OnPlayerJumped;

		// Somehow this can happen?
		if ( !Equipment.IsValid() )
			return;

		if ( Equipment.GetComponentInChildren<ShootableWeaponInputActionEquipmentComponent>() is { } shoot )
		{
			OnFireMode( shoot.CurrentFireMode );
		}
	}

	protected override void OnDestroy()
	{
		DestroyRigPrefabs();
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor )
			return;

		EnsureRigPrefabs();
	}

	/// <summary>
	/// Root object for attachment slots in a category (sleeves on arms, gloves on gloves prefab when set).
	/// </summary>
	public GameObject GetSlotRoot( string category )
	{
		if ( category.Equals( "glove", StringComparison.OrdinalIgnoreCase ) && GlovesInstance.IsValid() )
			return GlovesInstance;

		if ( ArmsInstance.IsValid() )
			return ArmsInstance;

		return Arms.IsValid() ? Arms.GameObject : null;
	}

	void EnsureRigPrefabs()
	{
		if ( !Game.IsEditor )
			ApplyOwnerRigPrefabs();

		if ( ArmsPrefab.IsValid() && !ArmsInstance.IsValid() )
			SpawnArmsPrefab();

		if ( GlovesPrefab.IsValid() && !GlovesInstance.IsValid() )
			SpawnGlovesPrefab();

		if ( !Arms.IsValid() )
			ResolveEmbeddedArms();

		if ( Arms.IsValid() && !ModelRenderer.IsValid() )
			ModelRenderer = Arms;

		ArmsInstance?.GetComponent<ViewModelArmsLoadoutComponent>()?.Apply();
	}

	/// <summary>
	/// Re-spawns arms/gloves from the owner's <see cref="PlayerViewModelRigComponent"/> (e.g. after team change).
	/// </summary>
	public void RefreshArmsRig()
	{
		DestroyRigPrefabs();
		EnsureRigPrefabs();
	}

	void ApplyOwnerRigPrefabs()
	{
		if ( !Owner.IsValid() )
			return;

		var rig = Owner.GetComponent<PlayerViewModelRigComponent>();
		if ( !rig.IsValid() )
			return;

		var entry = rig.GetActiveRig();
		if ( entry.ArmsPrefab.IsValid() )
			ArmsPrefab = entry.ArmsPrefab;

		GlovesPrefab = entry.GlovesPrefab.IsValid() ? entry.GlovesPrefab : null;
	}

	void SpawnArmsPrefab()
	{
		ArmsInstance = ArmsPrefab.Clone( new CloneConfig
		{
			Parent = GameObject,
			Transform = new(),
			StartEnabled = true
		} );

		ArmsInstance.Name = "Arms";
		Arms = FindArmsRenderer( ArmsInstance );
	}

	void SpawnGlovesPrefab()
	{
		var parent = ArmsInstance.IsValid() ? ArmsInstance : GameObject;

		GlovesInstance = GlovesPrefab.Clone( new CloneConfig
		{
			Parent = parent,
			Transform = new(),
			StartEnabled = true
		} );

		GlovesInstance.Name = "Gloves";
	}

	void DestroyRigPrefabs()
	{
		if ( GlovesInstance.IsValid() )
		{
			GlovesInstance.Destroy();
			GlovesInstance = null;
		}

		if ( ArmsInstance.IsValid() )
		{
			ArmsInstance.Destroy();
			ArmsInstance = null;
		}

		Arms = null;
	}

	/// <summary>
	/// Legacy: arms embedded directly on the viewmodel prefab instead of via <see cref="ArmsPrefab"/>.
	/// </summary>
	void ResolveEmbeddedArms()
	{
		foreach ( var go in GameObject.GetAllObjects( true ) )
		{
			if ( !go.Name.Equals( "Arms", StringComparison.OrdinalIgnoreCase ) )
				continue;

			if ( go == ArmsInstance || go == GlovesInstance )
				continue;

			var renderer = FindArmsRenderer( go );
			if ( !renderer.IsValid() )
				continue;

			ArmsInstance = go;
			Arms = renderer;
			return;
		}
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

	/// <summary>
	/// Prefer skeleton bones from <see cref="SkinnedModelRenderer.CreateBoneObjects"/> when present.
	/// </summary>
	void ResolveAttachmentPoints()
	{
		var muzzleBone = FindDescendant( "tag_barrel_attach", "tag_silencer" );
		if ( muzzleBone.IsValid() )
			Muzzle = muzzleBone;

		var ejectionBone = FindDescendant( "slide" );
		if ( ejectionBone.IsValid() )
			EjectionPort = ejectionBone;
	}

	GameObject FindDescendant( params string[] names )
	{
		foreach ( var name in names )
		{
			foreach ( var child in GameObject.GetAllObjects( true ) )
			{
				if ( child.Name.Equals( name, StringComparison.OrdinalIgnoreCase ) )
					return child;
			}
		}

		return null;
	}

	void OnPlayerJumped()
	{
		SetOnAnimGraphRenderers( "b_jump", true );
	}

	void ApplyAnimationTransform()
	{
		var meshRenderer = WeaponMeshRenderer;
		if ( !meshRenderer.IsValid() ) return;
		if ( !meshRenderer.Enabled ) return;
		if ( !Equipment.IsValid() ) return;
		if ( !Equipment.Owner.IsValid() ) return;
		if ( !meshRenderer.SceneModel.IsValid() ) return;

		var bone = meshRenderer.SceneModel.GetBoneLocalTransform( "camera" );
		var camera = Equipment.Owner.CameraGameObject;
		if ( !camera.IsValid() ) return;

		var scale = GameSettingsSystem.Current.ViewBob / 100f;

		camera.LocalPosition += bone.Position * scale;
		camera.LocalRotation *= bone.Rotation * scale;
	}

	private Vector3 scopedOffset = 0;
	private Vector3 lerpedPositionOffset;
	private Rotation lerpedRotationOffset;

	void ApplyOffsets()
	{
		var targetPositionOffset = Vector3.Zero;
		var targetRotationOffset = Rotation.Identity;

		// Accumulate all target offsets
		foreach ( var offset in Offsets )
		{
			targetPositionOffset += offset.PositionOffset;
			targetRotationOffset *= offset.AngleOffset.ToRotation();
		}

		// Smoothly interpolate position and rotation
		lerpedPositionOffset = lerpedPositionOffset.LerpTo( targetPositionOffset, Time.Delta * 10f );
		lerpedRotationOffset = Rotation.Lerp( lerpedRotationOffset, targetRotationOffset, Time.Delta * 10f );

		// Apply the lerped offsets
		WorldRotation *= lerpedRotationOffset;
		WorldPosition += WorldRotation * lerpedPositionOffset;

		// Keep existing scoped offset behavior
		scopedOffset = scopedOffset.LerpTo( Owner.HasEquipmentTag( "scoped" ) ? (Vector3.Down * 1.36f + Vector3.Forward * 0.2f) : 0, Time.Delta * 10f );
		LocalPosition += WorldRotation * scopedOffset;
	}

	void ApplyInertia()
	{
		var camera = Equipment.Owner.CameraGameObject;
		var inRot = camera.WorldRotation;

		// Need to fetch data from the camera for the first frame
		if ( !activateInertia )
		{
			lastPitch = inRot.Pitch();
			lastYaw = inRot.Yaw();
			YawInertia = 0;
			PitchInertia = 0;
			activateInertia = true;
		}

		var newPitch = camera.WorldRotation.Pitch();
		var newYaw = camera.WorldRotation.Yaw();

		PitchInertia = Angles.NormalizeAngle( newPitch - lastPitch );
		YawInertia = Angles.NormalizeAngle( lastYaw - newYaw );

		lastPitch = newPitch;
		lastYaw = newYaw;
	}

	private Vector3 lerpedWishMove;

	bool IsLeftFoot = false;
	private float LastStepProgress;
	float lenMult = 0;

	protected void ApplyVelocity()
	{
		if ( !Equipment.IsValid() )
			return;

		var moveVel = Owner.CharacterController.Velocity;
		var moveLen = moveVel.Length;
		var isMoving = moveLen > 10f; // Small threshold to determine if actually moving

		var wishMove = Owner.WishMove.Normal * 1f;
		if ( Equipment.HasTag( "aiming" ) ) wishMove = 0;

		if ( Owner.IsSlowWalking || Owner.IsCrouching ) moveLen *= 0.5f;

		lerpedWishMove = lerpedWishMove.LerpTo( wishMove, Time.Delta * 7.0f );

		var footsteps = Owner.GetComponent<PlayerFootstepsComponent>();
		var timeSince = footsteps.TimeSinceStep;
		var freq = footsteps.GetStepFrequency();

		// Set move_bob based on movement
		lenMult = lenMult.LerpTo( isMoving ? moveLen.Remap( 0, 300, 0, 1, true ) : 0, Time.Delta * 10f );
		SetOnAnimGraphRenderers( "move_bob", lenMult );

		// Handle cycle when moving vs stopped
		float cycleProgress;

		if ( isMoving )
		{
			// Track step alternation when moving
			if ( timeSince < Time.Delta )
			{
				IsLeftFoot = !IsLeftFoot;
				LastStepProgress = 0f;
			}

			// Calculate progress based on current step (0-0.5 for first step, 0.5-1 for second)
			var stepProgress = (timeSince / freq);
			LastStepProgress = IsLeftFoot
				? stepProgress * 0.5f              // First step: 0 to 0.5
				: 0.5f + (stepProgress * 0.5f);    // Second step: 0.5 to 1

			cycleProgress = LastStepProgress;
		}
		else
		{
			// When stopped, smoothly return to 0
			LastStepProgress = LastStepProgress.LerpTo( 0, Time.Delta * 4.0f );
			cycleProgress = LastStepProgress;
		}

		SetOnAnimGraphRenderers( "move_bob_cycle_control", cycleProgress );

		if ( UseMovementInertia )
			YawInertia += lerpedWishMove.y * 10f;

		SetOnAnimGraphRenderers( "aim_yaw_inertia", YawInertia * YawInertiaScale );
		SetOnAnimGraphRenderers( "aim_pitch_inertia", PitchInertia * PitchInertiaScale );
	}

	private float FieldOfViewOffset = 0f;
	private float TargetFieldOfView = 90f;

	void ApplyAnimationParameters()
	{
		SetOnAnimGraphRenderers( "b_sprint", Owner.IsSprinting );
		SetOnAnimGraphRenderers( "b_grounded", Owner.IsGrounded );

		var aiming = Equipment.HasTag( "aiming" );
		// Ironsights
		SetOnAnimGraphRenderers( "ironsights", aiming ? 1 : 0 );
		SetOnAnimGraphRenderers( "ironsights_fire_scale", aiming ? IronsightsFireScale : 0f );

		SetOnAnimGraphRenderers( "speed_ironsights", 1f );

		SetOnAnimGraphRenderers( "reload_speed", ReloadSpeed );

		SetOnAnimGraphRenderers( "b_grab", Owner.Hovered.IsValid() );

		SetOnAnimGraphRenderers( "b_lower_weapon", Equipment.HasTag( "lowered" ) );

		// Handedness
		SetOnAnimGraphRenderers( "b_twohanded", true );

		// Weapon state
		SetOnAnimGraphRenderers( "b_empty", !Equipment.GetComponentInChildren<WeaponAmmoComponent>()?.HasAmmo ?? false );
	}

	/// <summary>
	/// Should we play deploy effects?
	/// </summary>
	public bool PlayDeployEffects
	{
		set
		{
			SetOnAnimGraphRenderers( "b_deploy", value );
			SetOnAnimGraphRenderers( "b_deploy_skip", !value );
		}
	}

	private void ApplyThrowableAnimations()
	{
		if ( !Equipment.IsValid() )
			return;

		var throwFn = Equipment.GetComponentInChildren<ThrowableWeaponInputActionEquipmentComponent>();

		if ( !throwFn.IsValid() )
			return;

		SetOnAnimGraphRenderers( "b_idle", throwFn.ThrowState == ThrowableWeaponInputActionEquipmentComponent.State.Idle );
		SetOnAnimGraphRenderers( "b_pull", throwFn.ThrowState == ThrowableWeaponInputActionEquipmentComponent.State.Cook );
		SetOnAnimGraphRenderers( "b_throw", throwFn.ThrowState == ThrowableWeaponInputActionEquipmentComponent.State.Throwing );
	}

	public void OnFireMode( FireMode currentFireMode )
	{
		var mode = currentFireMode switch
		{
			FireMode.Semi => 1,
			FireMode.Automatic => 3,
			FireMode.Burst => 2,
			_ => 0
		};

		SetOnAnimGraphRenderers( "firing_mode", mode );
	}

	void IGameEventHandler<PlayerUseEvent>.OnGameEvent( PlayerUseEvent e )
	{
		SetOnAnimGraphRenderers( "grab_action", (int)e.Object.GetGrabAction() );
	}
}
