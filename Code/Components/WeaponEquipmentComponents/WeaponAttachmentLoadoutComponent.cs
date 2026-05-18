using Sandbox.Attributes;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents.AimableWeaponInputActionEquipmentComponents;
using Sandbox.GameResources;
using Sandbox;

namespace Sandbox.Components.WeaponEquipmentComponents;

/// <summary>
/// Applies weapon attachment selections to gameplay stats and viewmodel slot meshes.
/// Profile is resolved from a sibling <see cref="WeaponAttachmentProfileComponent"/>.
/// Viewmodel children: slot_{category}_{option} (e.g. slot_barrel_barsil).
/// </summary>
[Title( "Attachment Loadout" ), Group( "Weapon Components" )]
public partial class WeaponAttachmentLoadoutComponent : WeaponEquipmentComponent, IViewWeaponModelOffset
{
	[Hide, Sync( SyncFlags.FromHost )]
	public NetDictionary<string, string> Selections { get; private set; } = new();

	Vector3 IViewWeaponModelOffset.PositionOffset => IsAimingDownSights ? _aggregatedAimOffset : Vector3.Zero;
	Angles IViewWeaponModelOffset.AngleOffset => Angles.Zero;

	bool IsAimingDownSights =>
		Equipment.GetComponentInChildren<AimableWeaponInputActionEquipmentComponent>()?.IsAiming ?? false;

	Vector3 _aggregatedAimOffset;

	WeaponAttachmentProfile _resolvedProfile;
	WeaponAmmoComponent _ammo;
	ShootableWeaponInputActionEquipmentComponent _shoot;
	ShootRecoilEquipmentComponent _recoil;
	ReloadableWeaponInputActionEquipmentComponent _reload;

	SoundEvent _baseShootSound;
	float _baseFireRate;
	FireMode _baseFireMode;
	List<FireMode> _baseSupportedFireModes;
	RangedFloat _baseVerticalRecoil;
	RangedFloat _baseHorizontalRecoil;
	float _baseReloadTime;
	float _baseEmptyReloadTime;
	float _baseReloadSpeed;
	int _baseMaxAmmo;

	bool _viewModelBound;

	protected override void OnStart()
	{
		_resolvedProfile = ResolveProfile();
		if ( _resolvedProfile is null )
		{
			Log.Warning( $"WeaponAttachmentLoadout: no {nameof( WeaponAttachmentProfileComponent )} on {GameObject.Name}" );
			return;
		}

		_ammo = GetComponent<WeaponAmmoComponent>();
		_shoot = GetComponent<ShootableWeaponInputActionEquipmentComponent>();
		_recoil = GetComponent<ShootRecoilEquipmentComponent>();
		_reload = GetComponent<ReloadableWeaponInputActionEquipmentComponent>();

		EnsureDefaultSelections();
		CaptureBaseline();
		Apply();
	}

	protected override void OnUpdate()
	{
		if ( Equipment.ViewWeaponModel.IsValid() )
		{
			if ( !_viewModelBound )
			{
				_viewModelBound = true;
				ApplyMeshVisibility();
			}
		}
		else
		{
			_viewModelBound = false;
		}
	}

	WeaponAttachmentProfile ResolveProfile()
	{
		var profileComponent = ResolveProfileComponent();
		if ( !profileComponent.IsValid() )
			return null;

		if ( Game.IsEditor )
			profileComponent.RebuildProfile();

		return profileComponent.Profile;
	}

	WeaponAttachmentProfileComponent ResolveProfileComponent()
	{
		var onEquipment = Equipment.GetComponentInChildren<WeaponAttachmentProfileComponent>();
		if ( onEquipment.IsValid() )
			return onEquipment;

		return Equipment.ViewWeaponModel?.GetComponentInChildren<WeaponAttachmentProfileComponent>();
	}

	void EnsureDefaultSelections()
	{
		if ( _resolvedProfile is null )
			return;

		foreach ( var slot in _resolvedProfile.Slots )
		{
			if ( !Selections.ContainsKey( slot.Category ) )
				Selections[slot.Category] = slot.DefaultOption;
		}
	}

	public string GetSelection( string category )
	{
		if ( Selections.TryGetValue( category, out var selected ) )
			return selected;

		return _resolvedProfile?.GetDefaultOption( category ) ?? "none";
	}

	public void SetSelection( string category, string optionId )
	{
		if ( _resolvedProfile is null )
			return;

		var slot = _resolvedProfile.GetSlot( category );
		if ( slot is null || slot.FindOption( optionId ) is null )
			return;

		Selections[category] = optionId;
		Apply();
	}

	public void CycleSelection( string category )
	{
		if ( _resolvedProfile is null )
			return;

		var slot = _resolvedProfile.GetSlot( category );
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
		if ( _resolvedProfile is null )
			return;

		RestoreBaseline();
		ApplyAggregatedModifiers( BuildAggregatedModifiers() );
		ApplyMeshVisibility();
	}

	AggregatedAttachmentModifiers BuildAggregatedModifiers()
	{
		var aggregate = new AggregatedAttachmentModifiers
		{
			ReloadTimeMultiplier = 1f,
			EmptyReloadTimeMultiplier = 1f,
			ReloadSpeedMultiplier = 1f,
			VerticalRecoilMultiplier = 1f,
			HorizontalRecoilMultiplier = 1f
		};

		foreach ( var slot in _resolvedProfile.Slots )
		{
			var optionId = GetSelection( slot.Category );
			var option = slot.FindOption( optionId );
			option?.Modifiers.ApplyTo( ref aggregate );
		}

		_aggregatedAimOffset = aggregate.AimOffsetDelta;
		return aggregate;
	}

	void CaptureBaseline()
	{
		if ( _shoot.IsValid() )
		{
			_baseShootSound = _shoot.ShootSound;
			_baseFireRate = _shoot.FireRate;
			_baseFireMode = _shoot.CurrentFireMode;
			_baseSupportedFireModes = new List<FireMode>( _shoot.SupportedFireModes );
		}

		if ( _recoil.IsValid() )
		{
			_baseVerticalRecoil = _recoil.VerticalSpread;
			_baseHorizontalRecoil = _recoil.HorizontalSpread;
		}

		if ( _reload.IsValid() )
		{
			_baseReloadTime = _reload.ReloadTime;
			_baseEmptyReloadTime = _reload.EmptyReloadTime;
		}

		if ( Equipment.ViewWeaponModel.IsValid() )
			_baseReloadSpeed = Equipment.ViewWeaponModel.ReloadSpeed;

		if ( _ammo.IsValid() )
			_baseMaxAmmo = _ammo.MaxAmmo;
	}

	void RestoreBaseline()
	{
		if ( _shoot.IsValid() )
		{
			var standardSound = _resolvedProfile.StandardShootSound.IsValid()
				? _resolvedProfile.StandardShootSound
				: _baseShootSound;

			_shoot.ShootSound = standardSound;
			_shoot.FireRate = _baseFireRate;
			_shoot.CurrentFireMode = _baseFireMode;
			_shoot.SupportedFireModes = new List<FireMode>( _baseSupportedFireModes );
		}

		if ( _recoil.IsValid() )
		{
			_recoil.VerticalSpread = _baseVerticalRecoil;
			_recoil.HorizontalSpread = _baseHorizontalRecoil;
		}

		if ( _reload.IsValid() )
		{
			_reload.ReloadTime = _baseReloadTime;
			_reload.EmptyReloadTime = _baseEmptyReloadTime;
		}

		if ( Equipment.ViewWeaponModel.IsValid() )
			Equipment.ViewWeaponModel.ReloadSpeed = _baseReloadSpeed;

		if ( _ammo.IsValid() )
			_ammo.MaxAmmo = _baseMaxAmmo;
	}

	void ApplyAggregatedModifiers( AggregatedAttachmentModifiers mods )
	{
		if ( _ammo.IsValid() && mods.MaxAmmo.HasValue )
			_ammo.MaxAmmo = mods.MaxAmmo.Value;

		if ( _shoot.IsValid() )
		{
			if ( mods.FireRate.HasValue )
				_shoot.FireRate = mods.FireRate.Value;

			if ( mods.ForceAutomatic )
			{
				_shoot.SupportedFireModes = new List<FireMode> { FireMode.Automatic };
				_shoot.CurrentFireMode = FireMode.Automatic;
			}

			if ( mods.SuppressesSound && _resolvedProfile.SuppressedShootSound.IsValid() )
				_shoot.ShootSound = _resolvedProfile.SuppressedShootSound;
		}

		if ( _recoil.IsValid() )
		{
			_recoil.VerticalSpread = ScaleRangedFloat( _baseVerticalRecoil, mods.VerticalRecoilMultiplier );
			_recoil.HorizontalSpread = ScaleRangedFloat( _baseHorizontalRecoil, mods.HorizontalRecoilMultiplier );
		}

		if ( _reload.IsValid() )
		{
			_reload.ReloadTime = _baseReloadTime * mods.ReloadTimeMultiplier;
			_reload.EmptyReloadTime = _baseEmptyReloadTime * mods.EmptyReloadTimeMultiplier;
		}

		if ( Equipment.ViewWeaponModel.IsValid() )
			Equipment.ViewWeaponModel.ReloadSpeed = _baseReloadSpeed * mods.ReloadSpeedMultiplier;

		if ( _ammo.IsValid() )
			_ammo.Ammo = Math.Min( _ammo.Ammo, _ammo.MaxAmmo );
	}

	static RangedFloat ScaleRangedFloat( RangedFloat source, float scale )
	{
		return new RangedFloat( source.Min * scale, source.Max * scale );
	}

	public void ApplyMeshVisibility()
	{
		var vmRoot = Equipment.ViewWeaponModel?.GameObject;
		if ( !vmRoot.IsValid() || _resolvedProfile is null )
			return;

		foreach ( var slot in _resolvedProfile.Slots )
			AttachmentSlotUtility.SetSlotVisible( vmRoot, slot.Category, GetSelection( slot.Category ) );
	}

	// --- Dev helpers ---

	[DeveloperCommand( "Weapon Cycle Attachment: Magazine", "Weapons" )]
	private static void DevCycleMag() => WithLoadout( l => l.CycleSelection( "mag" ) );

	[DeveloperCommand( "Weapon Cycle Attachment: Barrel", "Weapons" )]
	private static void DevCycleBarrel() => WithLoadout( l => l.CycleSelection( "barrel" ) );

	[DeveloperCommand( "Weapon Cycle Attachment: Muzzle", "Weapons" )]
	private static void DevCycleMuzzle() => WithLoadout( l => l.CycleSelection( "muzzle" ) );

	[DeveloperCommand( "Weapon Cycle Attachment: Stock", "Weapons" )]
	private static void DevCycleStock() => WithLoadout( l => l.CycleSelection( "stock" ) );

	[DeveloperCommand( "Weapon Cycle Attachment: Grip", "Weapons" )]
	private static void DevCycleGrip() => WithLoadout( l => l.CycleSelection( "grip" ) );

	[DeveloperCommand( "Weapon Cycle Attachment: Sight", "Weapons" )]
	private static void DevCycleSight() => WithLoadout( l => l.CycleSelection( "sight" ) );

	[DeveloperCommand( "Weapon Cycle Attachment: Laser", "Weapons" )]
	private static void DevCycleLaser() => WithLoadout( l => l.CycleSelection( "laser" ) );

	[DeveloperCommand( "Weapon Cycle Attachment: Perk", "Weapons" )]
	private static void DevCyclePerk() => WithLoadout( l => l.CycleSelection( "perk" ) );

	[DeveloperCommand( "Weapon Refresh Attachments", "Weapons" )]
	private static void DevRefreshAttachments() => WithLoadout( l =>
	{
		l.Apply();
		Log.Info( $"Attachments refreshed on {l.Equipment?.GameObject?.Name}" );
	} );

	static void WithLoadout( Action<WeaponAttachmentLoadoutComponent> action )
	{
		var equipment = ClientComponent.Local?.PlayerPawn?.CurrentEquipment;
		var loadout = equipment?.GetComponentInChildren<WeaponAttachmentLoadoutComponent>();
		if ( !loadout.IsValid() )
		{
			Log.Warning( "Current equipment has no WeaponAttachmentLoadoutComponent." );
			return;
		}

		action( loadout );
	}
}
