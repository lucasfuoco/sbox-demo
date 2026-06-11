using Sandbox.Components;
using Sandbox.Components.WeaponEquipmentComponents;
using Sandbox.GameResources;

namespace Sandbox.Components.WeaponModelComponents.ViewModelWeaponComponents;

public class PistolViewModelWeaponComponent : ViewModelWeaponComponent
{
	const string DefaultAnimGraphPath = "animgraphs/rigged_human_pistol.vanmgrph";

	[Property, Group( "Configuration" )]
	public AnimationGraph AnimGraphReference { get; set; }

	const float FireStateBlendDuration = 0.2f;
	const float DefaultFireAnimDuration = 0.35f;
	const float DefaultFireLastAnimDuration = 0.42f;

	public enum ReloadType
	{
		Default = 0,
		Mmag = 1,
		Xmag = 2,
		XmagLrg = 3,
	}

	public enum InspectType
	{
		Default = 0,
		Drum = 1,
		Xmag = 2,
	}

	public enum DrawFirstType
	{
		Default = 0,
		Drum = 1,
	}

	int _firePhase;
	readonly Queue<bool> _fireQueue = new();
	TimeUntil _timeUntilFireAnimComplete;

	bool _drawPulse;
	bool _inspectPulse;
	bool _meleePulse;
	bool _chargePulse;
	bool _jumpPulse;
	bool _jumpLandPulse;

	bool _reloadEmpty;
	int _reloadType;
	bool _reloadFast;
	int _inspectType;
	bool _drawFirst;
	int _drawFirstType;

	bool _meleeHit;
	bool _meleeFatal;
	bool _reloading;
	int _reloadStartPhase;

	protected override void UpdateFireAnimationReady( ref bool ready )
	{
		ready = _timeUntilFireAnimComplete;
	}

	protected override bool UsesCustomAnimationParameters => UsesAnimGraph;

	bool UsesAnimGraph
	{
		get
		{
			var renderer = WeaponMeshRenderer;
			return renderer.IsValid()
				&& renderer.UseAnimGraph
				&& renderer.AnimationGraph.IsValid();
		}
	}

	void SetAnimGraph( string param, bool value )
	{
		if ( !UsesAnimGraph )
			return;

		WeaponMeshRenderer?.Set( param, value );
	}

	void SetAnimGraph( string param, int value )
	{
		if ( !UsesAnimGraph )
			return;

		WeaponMeshRenderer?.Set( param, value );
	}

	void SetAnimGraph( string param, float value )
	{
		if ( !UsesAnimGraph )
			return;

		WeaponMeshRenderer?.Set( param, value );
	}

	enum JogState
	{
		In = 0,
		Out = 1
	}

	enum SprintState
	{
		Idle = 0,
		In = 1,
		InToSub = 2,
		OffsetToSub = 3,
		Out = 4,
		OutToSub = 5,
		SuperIn = 6,
		SuperOut = 7
	}

	enum AdsState
	{
		In = 0,
		Out = 1
	}

	bool _wasJogging;
	bool _wasSprinting;
	TimeSince _timeSinceJogStateChange;
	TimeSince _timeSinceSprintStateChange;
	JogState _jogState = JogState.Out;
	SprintState _sprintState = SprintState.Out;
	float _aimOffsetLerp;
	float _locomotionDeltaLerp;
	float _reloadDeltaLerp = 1f;

	static float CosineInterp01( float t )
	{
		t = Math.Clamp( t, 0f, 1f );
		return (1f - MathF.Cos( t * MathF.PI )) * 0.5f;
	}

	void QueueFire( bool isLastShot )
	{
		_fireQueue.Enqueue( isLastShot );
	}

	void ApplyFirePulse()
	{
		switch ( _firePhase )
		{
			case 0:
				SetAnimGraph( "fire", false );
				if ( _fireQueue.Count > 0 )
					_firePhase = 1;
				break;

			case 1:
				var isLastShot = _fireQueue.Dequeue();
				SetAnimGraph( "fire", false );
				SetAnimGraph( "fire_last", false );
				SetAnimGraph( "fire_last", isLastShot );
				SetAnimGraph( "fire", true );
				_timeUntilFireAnimComplete = GetFireAnimationDuration( isLastShot );
				_firePhase = 2;
				break;

			case 2:
				if ( _timeUntilFireAnimComplete > 0f )
				{
					SetAnimGraph( "fire", true );
				}
				else
				{
					SetAnimGraph( "fire", false );
					_firePhase = 0;
				}
				break;
		}

		if ( _firePhase == 0 && _fireQueue.Count == 0 )
			SetAnimGraph( "fire_last", false );
	}

	void TriggerBool( string param )
	{
		SetAnimGraph( param, false );
		SetAnimGraph( param, true );
	}

	void ApplyBoolPulse( string param, bool pulse )
	{
		if ( pulse )
			TriggerBool( param );
		else
			SetAnimGraph( param, false );
	}

	static float GetFireAnimationDuration( bool isLastShot )
	{
		var sequenceDuration = isLastShot ? DefaultFireLastAnimDuration : DefaultFireAnimDuration;
		return sequenceDuration + FireStateBlendDuration;
	}

	protected override void EnsureAnimGraphSetup()
	{
		var weaponRenderer = WeaponMeshRenderer;
		if ( !weaponRenderer.IsValid() )
			return;

		weaponRenderer.BoneMergeTarget = null;

		if ( !weaponRenderer.AnimationGraph.IsValid() )
		{
			weaponRenderer.AnimationGraph = AnimGraphReference.IsValid()
				? AnimGraphReference
				: ResourceLibrary.Get<AnimationGraph>( DefaultAnimGraphPath );
		}

		if ( !weaponRenderer.AnimationGraph.IsValid() )
			return;

		weaponRenderer.UseAnimGraph = true;

		if ( ArmsRig.IsValid() && ArmsRig.Arms.IsValid() )
		{
			var armsRenderer = ArmsRig.Arms;
			armsRenderer.UseAnimGraph = false;
			armsRenderer.AnimationGraph = null;
			armsRenderer.BoneMergeTarget = weaponRenderer;
		}
	}

	protected override void ApplyCustomAnimationParameters()
	{
		if ( !UsesAnimGraph )
			return;

		ApplyActionParameters();
		ApplyMovementParameters();
		ApplyReloadParameters();
	}

	void ApplyActionParameters()
	{
		ApplyFirePulse();

		if ( _drawPulse )
		{
			SetAnimGraph( "draw", false );
			SetAnimGraph( "is_draw_first", _drawFirst );
			SetAnimGraph( "draw_first_type", _drawFirstType );
			TriggerBool( "draw" );
		}
		else
		{
			SetAnimGraph( "draw", false );
		}
		_drawPulse = false;

		if ( _inspectPulse )
		{
			SetAnimGraph( "inspect", false );
			SetAnimGraph( "inspect_type", _inspectType );
			TriggerBool( "inspect" );
		}
		else
		{
			SetAnimGraph( "inspect", false );
		}
		_inspectPulse = false;

		if ( _meleePulse )
		{
			SetAnimGraph( "melee", false );
			SetAnimGraph( "is_melee_hit", _meleeHit );
			SetAnimGraph( "is_melee_fatal", _meleeFatal );
			TriggerBool( "melee" );
		}
		else
		{
			SetAnimGraph( "melee", false );
			SetAnimGraph( "is_melee_hit", false );
			SetAnimGraph( "is_melee_fatal", false );
		}
		_meleePulse = false;
		_meleeHit = false;
		_meleeFatal = false;

		ApplyBoolPulse( "charge", _chargePulse );
		_chargePulse = false;

		ApplyBoolPulse( "jump", _jumpPulse );
		_jumpPulse = false;

		ApplyBoolPulse( "is_jump_land", _jumpLandPulse );
		_jumpLandPulse = false;
	}

	void ApplyMovementParameters()
	{
		if ( !Owner.IsValid() || !Owner.CharacterController.IsValid() )
			return;

		// Use raw RMB for local viewmodel aiming so jog state doesn't latch from stale tags.
		var aiming = Owner.IsLocallyControlled ? Input.Down( "attack2" ) : Equipment.HasTag( "aiming" );

		var moveVel = Owner.CharacterController.Velocity.WithZ( 0f );
		var moveLen = MathF.Max( moveVel.Length, 0.01f );
		var isGrounded = Owner.IsGrounded;
		var isSprinting = Owner.IsSprinting && isGrounded;

		var walkSpeed = Math.Max( Owner.Global?.WalkSpeed ?? 220f, 1f );
		var slowWalkSpeed = Math.Max( Owner.Global?.SlowWalkSpeed ?? 100f, 1f );
		var sprintingSpeed = Math.Max( Owner.Global?.SprintingSpeed ?? 300f, walkSpeed + 1f );

		var lerpSpeed = _reloading ? -1f : 1f;
		_reloadDeltaLerp = Math.Clamp( _reloadDeltaLerp + lerpSpeed * Time.Delta, 0f, 1f );

		if ( !isGrounded )
		{
			_locomotionDeltaLerp = _locomotionDeltaLerp.LerpTo( 0f, Time.Delta * 6f );
		}
		else
		{
			var moveNorm = moveLen / walkSpeed;
			_locomotionDeltaLerp = _locomotionDeltaLerp.LerpTo( moveNorm, Time.Delta * 4f );
		}

		var slowWalkPoint = Math.Clamp( slowWalkSpeed / walkSpeed, 0.01f, 1f );
		var slowWalkDelta = 1f - (MathF.Abs( slowWalkPoint - _locomotionDeltaLerp ) / slowWalkPoint);
		slowWalkDelta = Math.Clamp( slowWalkDelta, 0f, 1f );

		var jogDelta = _locomotionDeltaLerp - slowWalkDelta;
		var isJogging = jogDelta > 0.5f && !isSprinting;
		var sprintAiming = isSprinting && aiming;

		var jogAiming = isJogging && aiming;
		SetAnimGraph( "jog", jogAiming );
		SetAnimGraph( "sprint", sprintAiming );
		// ADS transition clips are disabled; aim is driven by aim_offset only.
		SetAnimGraph( "ads", false );
		SetAnimGraph( "ads_state", (int)AdsState.Out );

		_aimOffsetLerp = _aimOffsetLerp.LerpTo( aiming ? 1f : 0f, Time.Delta * 30f );
		// Lua: Lerp( m_AimDeltaLerp, 1, 0.03 * ... ) so hip-fire keeps locomotion strong.
		var aimTarget = 0.03f;
		var aimDelta = 1f + (aimTarget - 1f) * _aimOffsetLerp;

		var sprintPoint = sprintingSpeed / walkSpeed;
		var sprintDenom = Math.Max( sprintPoint - 1f, 0.001f );
		var sprintDelta = (_locomotionDeltaLerp - 1f) / sprintDenom;

		var jogLoop = Math.Clamp( MathF.Min( jogDelta * aimDelta, aimDelta ), 0f, 1f );
		var walkLoop = Math.Clamp( MathF.Min( slowWalkDelta * aimDelta, aimDelta ), 0f, 1f );

		var z = MathF.Min( Owner.CharacterController.Velocity.z, 0f );
		var freefallDelta = MathF.Min( z + 500f, 0f ) / -1100f;
		var freefallAimScale = 1f + (0.1f - 1f) * _aimOffsetLerp;
		var freefallLoop = Math.Clamp( freefallDelta * freefallAimScale, 0f, 1f );

		var sprintLoop = Math.Clamp( MathF.Min( sprintDelta, aimDelta ) * aimDelta * _reloadDeltaLerp, 0f, 1f );
		var sprintOffset = Math.Clamp( sprintDelta, 0f, 1f );

		var offsetDelta = CosineInterp01( _locomotionDeltaLerp * Math.Clamp( 1f - sprintDelta, 0f, 1f ) );
		var jogOffset = Math.Clamp( offsetDelta * (1f - Math.Clamp( _aimOffsetLerp * 2f, 0f, 1f )), 0f, 1f );

		SetAnimGraph( "jog_loop", jogLoop );
		SetAnimGraph( "jog_offset", jogOffset );
		SetAnimGraph( "walk_loop", walkLoop );
		SetAnimGraph( "sprint_loop", sprintLoop );
		SetAnimGraph( "sprint_offset", sprintOffset );
		SetAnimGraph( "freefall_loop", freefallLoop );
		SetAnimGraph( "aim_offset", _aimOffsetLerp );
		SetAnimGraph( "empty_offset", IsMagEmpty() ? 1f : 0f );

		if ( jogAiming )
		{
			// In = start animation, Out = end animation.
			var desiredJogState = JogState.In;
			if ( _jogState != desiredJogState )
			{
				_jogState = desiredJogState;
				_timeSinceJogStateChange = 0;
			}
		}
		else
		{
			// Not aiming jog path -> end animation.
			if ( _jogState != JogState.Out )
			{
				_jogState = JogState.Out;
				_timeSinceJogStateChange = 0;
			}
		}

		SetAnimGraph( "jog_state", (int)_jogState );
		_wasJogging = isJogging;

		if ( sprintAiming )
		{
			// In = start animation, Out = end animation.
			if ( _sprintState != SprintState.In )
			{
				_sprintState = SprintState.In;
				_timeSinceSprintStateChange = 0;
			}
		}
		else
		{
			if ( _sprintState != SprintState.Out )
			{
				_sprintState = SprintState.Out;
				_timeSinceSprintStateChange = 0;
			}
		}

		SetAnimGraph( "sprint_state", (int)_sprintState );
		_wasSprinting = isSprinting;
	}

	void ApplyReloadParameters()
	{
		if ( !_reloading )
		{
			SetAnimGraph( "is_reload_empty", false );
			SetAnimGraph( "is_reload_fast", false );
			SetAnimGraph( "reload", false );
			return;
		}

		SetAnimGraph( "is_reload_empty", _reloadEmpty );
		SetAnimGraph( "reload_type", _reloadType );
		SetAnimGraph( "is_reload_fast", _reloadFast );

		switch ( _reloadStartPhase )
		{
			case 1:
				SetAnimGraph( "reload", false );
				_reloadStartPhase = 2;
				break;

			case 2:
				SetAnimGraph( "reload", true );
				_reloadStartPhase = 0;
				break;

			default:
				SetAnimGraph( "reload", true );
				break;
		}
	}

	public override void PulseFire( bool isLastShot )
	{
		QueueFire( isLastShot );
	}

	bool IsMagEmpty()
	{
		var ammo = Equipment?.GetComponentInChildren<WeaponAmmoComponent>();
		return ammo.IsValid() && ammo.IsEmpty;
	}

	public override void PulseDraw( bool isFirstDraw = false )
	{
		_drawPulse = true;
		_drawFirst = isFirstDraw;
		_drawFirstType = (int)GetDrawFirstType();
	}

	public override void BeginReloadAnimation( bool empty, int reloadType, bool fastReload )
	{
		_reloading = true;
		_reloadEmpty = empty;
		_reloadType = reloadType;
		_reloadFast = fastReload;
		_reloadStartPhase = 1;
	}

	public override void EndReloadAnimation()
	{
		_reloading = false;
		_reloadEmpty = false;
		_reloadFast = false;
		_reloadStartPhase = 0;

		if ( !UsesAnimGraph )
			return;

		SetAnimGraph( "reload", false );
		SetAnimGraph( "is_reload_empty", false );
		SetAnimGraph( "is_reload_fast", false );
	}

	public void PulseInspect( InspectType inspectType = InspectType.Default )
	{
		_inspectPulse = true;
		_inspectType = (int)inspectType;
	}

	public void PulseMelee( bool hit, bool fatal = false )
	{
		_meleePulse = true;
		_meleeHit = hit;
		_meleeFatal = fatal;
	}

	public void PulseCharge()
	{
		_chargePulse = true;
	}

	public void PulseJump( bool isLand = false )
	{
		if ( isLand )
			_jumpLandPulse = true;
		else
			_jumpPulse = true;
	}

	public override int GetMagReloadType()
	{
		var loadout = Equipment?.GetComponentInChildren<WeaponAttachmentLoadoutComponent>();
		if ( !loadout.IsValid() )
			return (int)ReloadType.Default;

		var mag = loadout.GetSelection( "mag" );

		if ( mag.Contains( "drum", StringComparison.OrdinalIgnoreCase )
			|| mag.Contains( "xmaglrg", StringComparison.OrdinalIgnoreCase ) )
			return (int)ReloadType.XmagLrg;

		if ( mag.Contains( "xmag", StringComparison.OrdinalIgnoreCase ) )
			return (int)ReloadType.Xmag;

		if ( mag.Contains( "mmag", StringComparison.OrdinalIgnoreCase ) )
			return (int)ReloadType.Mmag;

		return (int)ReloadType.Default;
	}

	public int GetInspectType()
	{
		var loadout = Equipment?.GetComponentInChildren<WeaponAttachmentLoadoutComponent>();
		if ( !loadout.IsValid() )
			return (int)InspectType.Default;

		var mag = loadout.GetSelection( "mag" );

		if ( mag.Contains( "drum", StringComparison.OrdinalIgnoreCase )
			|| mag.Contains( "xmaglrg", StringComparison.OrdinalIgnoreCase ) )
			return (int)InspectType.Drum;

		if ( mag.Contains( "xmag", StringComparison.OrdinalIgnoreCase ) )
			return (int)InspectType.Xmag;

		return (int)InspectType.Default;
	}

	DrawFirstType GetDrawFirstType()
	{
		var loadout = Equipment?.GetComponentInChildren<WeaponAttachmentLoadoutComponent>();
		if ( !loadout.IsValid() )
			return DrawFirstType.Default;

		var mag = loadout.GetSelection( "mag" );

		if ( mag.Contains( "drum", StringComparison.OrdinalIgnoreCase )
			|| mag.Contains( "xmaglrg", StringComparison.OrdinalIgnoreCase ) )
			return DrawFirstType.Drum;

		return DrawFirstType.Default;
	}

	public override bool IsFastReload()
	{
		var loadout = Equipment?.GetComponentInChildren<WeaponAttachmentLoadoutComponent>();
		if ( loadout.IsValid() && loadout.GetSelection( "perk" ).Contains( "soh", StringComparison.OrdinalIgnoreCase ) )
			return true;

		return ReloadSpeed > 1f;
	}

	public override float GetReloadDuration( bool empty )
	{
		if ( !UsesAnimGraph )
			return 0f;

		return GetReloadDuration( empty, GetMagReloadType(), IsFastReload() );
	}

	static float GetReloadDuration( bool empty, int reloadType, bool fastReload )
	{
		if ( fastReload )
		{
			if ( empty )
				return reloadType == (int)ReloadType.XmagLrg ? 1.8f : 1.36f;

			return reloadType == (int)ReloadType.XmagLrg ? 1.6f : 1.2f;
		}

		if ( empty )
			return reloadType == (int)ReloadType.XmagLrg ? 2.53f : 2.26f;

		return reloadType == (int)ReloadType.XmagLrg ? 2.06f : 1.66f;
	}

	protected override void OnOwnerJumped()
	{
		PulseJump();
	}
}
