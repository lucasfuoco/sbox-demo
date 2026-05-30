using Sandbox.Components;
using Sandbox.Components.WeaponEquipmentComponents;
using Sandbox.GameResources;

namespace Sandbox.Components.WeaponModelComponents.ViewWeaponModelComponents;

public class PistolViewWeaponModelComponent : ViewWeaponModelComponent
{
	public const string AnimGraphPath = "animgraphs/rigged_human_pistol.vanmgrph";

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
				SetAnimGraph( "fire", false );
				_firePhase = 0;
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
			weaponRenderer.AnimationGraph = ResourceLibrary.Get<AnimationGraph>( AnimGraphPath );

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

		var aiming = Equipment.HasTag( "aiming" );
		SetAnimGraph( "ads", aiming );

		SetAnimGraph( "sprint", Owner.IsSprinting );

		var moveLen = Owner.CharacterController.Velocity.Length;
		var isMoving = moveLen > 10f;
		SetAnimGraph( "jog", isMoving && !Owner.IsSprinting );
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
		QueueFire( IsMagEmpty() );
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
