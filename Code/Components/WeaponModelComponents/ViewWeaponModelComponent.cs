using Sandbox;
using Sandbox.Components;
using Sandbox.Components.PawnComponents;
using Sandbox.Components.WeaponEquipmentComponents;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents.AimableWeaponInputActionEquipmentComponents;
using Sandbox.GameEvents;
using Sandbox.GameResources;
using Sandbox.SceneEvents;

namespace Sandbox.Components.WeaponModelComponents;

/// <summary>
/// A weapon's viewmodel. It's responsibility is to listen to events from a weapon.
/// It should only exist on the client for the currently possessed pawn.
/// </summary>
public class ViewWeaponModelComponent : WeaponModelComponent, ICameraSetup, IGameEventHandler<PlayerUseEvent>, Component.ExecuteInEditor
{
	/// <summary>
	/// A reference to the <see cref="Equipment"/> we want to listen to.
	/// </summary>
	EquipmentComponent _equipment;
	public EquipmentComponent Equipment
	{
		get => _equipment;
		set
		{
			if ( _equipment == value )
				return;

			if ( Owner.IsValid() )
				Owner.OnJump -= OnOwnerJumped;

			_equipment = value;

			if ( !Equipment.IsValid() )
				return;

			OnEquipmentAssigned();
		}
	}

	/// <summary>
	/// Whether the viewmodel fire animation has finished. Non-anim-graph weapons are always ready.
	/// </summary>
	public bool IsFireAnimationReady
	{
		get
		{
			var ready = true;
			UpdateFireAnimationReady( ref ready );
			return ready;
		}
	}

	protected virtual void UpdateFireAnimationReady( ref bool ready ) { }

	protected virtual bool UsesCustomAnimationParameters => false;

	protected virtual void EnsureAnimGraphSetup() { }

	protected virtual void ApplyCustomAnimationParameters() { }

	protected virtual void OnOwnerJumped() { }

	public virtual void PulseFire( bool isLastShot ) { }

	public virtual void PulseDraw( bool isFirstDraw = false ) { }

	public virtual void BeginReloadAnimation( bool empty, int reloadType, bool fastReload ) { }

	public virtual void EndReloadAnimation() { }

	public virtual float GetReloadDuration( bool empty ) => 0f;

	public virtual int GetMagReloadType() => 0;

	public virtual bool IsFastReload() => ReloadSpeed > 1f;

	/// <summary>
	/// The resource
	/// </summary>
	public EquipmentResource Resource { get; set; }

	/// <summary>
	/// Weapon attachment slot profile on this viewmodel (perk, mag, barrel, …).
	/// </summary>
	[Property, Group( "Attachments" )]
	public WeaponAttachmentProfileComponent AttachmentProfile { get; set; }

	/// <summary>
	/// Arms rig on this viewmodel prefab. Assign in the editor instead of spawning at runtime.
	/// </summary>
	[Property, Group( "Configuration" )]
	public ViewModelArmsRigComponent ArmsRigSource { get; set; }

	/// <summary>
	/// Resolved arms rig used for animation and glove attachments.
	/// </summary>
	public ViewModelArmsRigComponent ArmsRig { get; private set; }

	/// <summary>
	/// Arms mesh used for the anim graph.
	/// </summary>
	public SkinnedModelRenderer Arms => ArmsRig.IsValid() ? ArmsRig.Arms : null;

	/// <summary>
	/// Is this a throwable?
	/// </summary>
	[Property, Group( "Configuration" )] public bool IsThrowable { get; set; }

	/// <summary>
	/// Looks up the tree to find the player controller.
	/// </summary>
	protected PlayerPawnComponent Owner => Equipment.IsValid() ? Equipment.Owner : null;

	[Property, Range( 0, 1 ), Group( "Configuration" )] public float IronsightsFireScale { get; set; } = 0.2f;
	[Property, Group( "Configuration" )] public bool UseMovementInertia { get; set; } = true;

	/// <summary>
	/// When enabled in the editor (no equipped owner), snaps this viewmodel to <see cref="Scene.Camera"/> for offset tuning.
	/// Disable to leave the prefab at its authored world transform.
	/// </summary>
	[Property, Group( "Configuration" )] public bool PreviewOnCamera { get; set; } = true;

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
		if ( !Owner.IsValid() )
			return;

		WorldPosition = cc.WorldPosition;
		WorldRotation = cc.WorldRotation;

		ApplyOffsets();

		if ( Owner.CharacterController.IsValid() )
		{
			ApplyInertia();
			ApplyVelocity();
		}

		if ( IsThrowable )
		{
			ApplyThrowableAnimations();
		}
		else
		{
			ApplyAnimationParameters();
		}

		var baseFov = GameSettingsSystem.Current.FieldOfView;

		TargetFieldOfView = TargetFieldOfView.LerpTo( baseFov + FieldOfViewOffset, Time.Delta * 10f );
		FieldOfViewOffset = 0;
	}

	void ICameraSetup.PostSetup( CameraComponent cc )
	{
		if ( !Owner.IsValid() )
			return;

		ApplyViewModelBoneOffsets();
	}

	protected override void OnPreRender()
	{
		// In play mode, offsets run once from ICameraSetup.PostSetup after animation.
		if ( Game.IsPlaying && Owner.IsValid() )
			return;

		if ( PreviewOnCamera )
			ApplyEditorPreviewTransform();

		ApplyEditorPreviewAnimation();
		ApplyViewModelBoneOffsets();
	}

	void ApplyViewModelBoneOffsets()
	{
		var components = GameObject.GetComponentsInChildren<BoneOffsetComponent>( true ).ToList();
		for ( var i = 0; i < components.Count; i++ )
		{
			var component = components[i];

			if ( component.LastShouldApply != component.ShouldApply )
				component.HandleApplyStateChanged();
			else
				component.ApplyForRoot( GameObject, prepareSkeleton: i == 0 );
		}
	}

	void ApplyEditorPreviewTransform()
	{
		if ( !PreviewOnCamera )
			return;

		var camera = Scene.Camera;
		if ( !camera.IsValid() )
			return;

		WorldPosition = camera.WorldPosition;
		WorldRotation = camera.WorldRotation;
	}

	void ApplyEditorPreviewAnimation()
	{
		if ( IsThrowable )
			ApplyThrowableAnimations();
		else
			ApplyAnimationParameters();
	}

	protected override void OnAwake()
	{

	}

	protected override void OnStart()
	{
		EnsureAttachmentProfile();
		EnsureArmsRig();
		ResolveAttachmentPoints();

		if ( Equipment.IsValid() )
			OnEquipmentAssigned();
	}

	void OnEquipmentAssigned()
	{
		EnsureArmsRig();
		EnsureAttachmentProfile();

		if ( Owner.IsValid() )
			Owner.OnJump += OnOwnerJumped;

		if ( Equipment.GetComponentInChildren<ShootableWeaponInputActionEquipmentComponent>() is { } shoot )
			OnFireMode( shoot.CurrentFireMode );

		Equipment.GetComponentInChildren<WeaponAttachmentLoadoutComponent>()?.EnsureInitialized();

		if ( PlayDeployEffects )
			PulseDraw( isFirstDraw: true );
	}

	protected override void OnDestroy()
	{
		ArmsRig = null;
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor )
			return;

		EnsureAttachmentProfile();
		EnsureArmsRig();
	}

	void EnsureAttachmentProfile()
	{
		if ( !AttachmentProfile.IsValid() )
			AttachmentProfile = GetComponentInChildren<WeaponAttachmentProfileComponent>();

		if ( AttachmentProfile.IsValid() )
			AttachmentProfile.RebuildProfile();
	}

	/// <summary>
	/// Root object for slot meshes (weapon attachments on this viewmodel, gloves on <see cref="ArmsRig"/>).
	/// </summary>
	public override GameObject GetSlotRoot( string category )
	{
		if ( category.Equals( "glove", StringComparison.OrdinalIgnoreCase ) && ArmsRig.IsValid() )
			return ArmsRig.GetSlotRoot( category );

		return GameObject;
	}

	/// <summary>
	/// Resolve the arms rig for glove slots and anim graph access. Bone merge is authored on the prefab.
	/// </summary>
	void EnsureArmsRig()
	{
		ArmsRig = ResolveArmsRig();
		if ( ArmsRig.IsValid() )
		{
			ArmsRig.ResolveComponents();
			ArmsRig.Loadout?.Apply();
		}

		EnsureAnimGraphSetup();
	}

	ViewModelArmsRigComponent ResolveArmsRig()
	{
		if ( ArmsRigSource.IsValid() )
			return ArmsRigSource;

		return GetComponentInChildren<ViewModelArmsRigComponent>( true );
	}

	/// <summary>
	/// Prefer skeleton bones from <see cref="SkinnedModelRenderer.CreateBoneObjects"/> when present.
	/// Preserves a <see cref="Muzzle"/> or <see cref="EjectionPort"/> already assigned on the prefab.
	/// </summary>
	void ResolveAttachmentPoints()
	{
		if ( !Muzzle.IsValid() )
		{
			var muzzleBone = FindDescendant( "Muzzle", "tag_flash", "tag_flash_end", "tag_silencer_end", "tag_barrel_attach", "tag_silencer" );
			if ( muzzleBone.IsValid() )
				Muzzle = muzzleBone;
		}

		if ( !EjectionPort.IsValid() )
		{
			var ejectionBone = FindDescendant( "slide", "j_slide" );
			if ( ejectionBone.IsValid() )
				EjectionPort = ejectionBone;
		}
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
		if ( !Equipment.IsValid() || !Equipment.Owner.IsValid() )
			return;

		var camera = Equipment.Owner.CameraGameObject;
		if ( !camera.IsValid() )
			return;

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

		if ( UsesCustomAnimationParameters )
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
		if ( UsesCustomAnimationParameters )
		{
			ApplyCustomAnimationParameters();
			return;
		}

		ApplyLegacyAnimationParameters();
	}

	void ApplyLegacyAnimationParameters()
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
	public bool PlayDeployEffects { get; private set; } = true;

	public void SetPlayDeployEffects( bool value )
	{
		PlayDeployEffects = value;
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
