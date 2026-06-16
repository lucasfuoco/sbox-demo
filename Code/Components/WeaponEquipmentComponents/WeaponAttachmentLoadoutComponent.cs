using Sandbox.Attributes;
using Sandbox.Components.PawnComponents;
using Sandbox.Components.WeaponAttachmentOptionComponents;
using Sandbox.Components.WeaponAttachmentSlotComponents;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents.AimableWeaponInputActionEquipmentComponents;
using Sandbox.Components.WeaponModelComponents;
using Sandbox.GameResources;
using Sandbox;

namespace Sandbox.Components.WeaponEquipmentComponents;

/// <summary>
/// Applies weapon attachment selections to gameplay stats and weapon mesh slot visibility.
/// Profile is resolved from <see cref="ViewModelWeaponComponent.AttachmentProfile"/>.
/// Slot meshes: slot_{category}_{option} (e.g. slot_barrel_barsil) on view, world, and holstered mount models.
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

	float _baseFireRate;
	FireMode _baseFireMode;
	List<FireMode> _baseSupportedFireModes;
	RangedFloat _baseVerticalRecoil;
	RangedFloat _baseHorizontalRecoil;
	float _baseReloadTime;
	float _baseEmptyReloadTime;
	float _baseReloadSpeed;
	int _baseMaxAmmo;

	int _lastAttachmentTargetCount = -1;
	int _lastViewAmmoForBulletVisuals = int.MinValue;
	string _lastBulletSelectionForVisuals;
	int _lastTrackedBulletAmmoTotal = int.MinValue;
	readonly Dictionary<int, int> _trackedBulletsByMag = new();
	bool _initialized;

	sealed class BulletVisualOption
	{
		public GameObject GameObject { get; init; }
		public string OptionId { get; init; }
		public int MagIndex { get; init; }
		public int Count { get; init; }
		public SkinnedModelRenderer ReferencedRenderer { get; init; }
	}

	protected override void OnStart()
	{
		EnsureInitialized();
	}

	/// <summary>
	/// Initializes attachment selections once the viewmodel profile is available.
	/// </summary>
	public void EnsureInitialized()
	{
		if ( _resolvedProfile is null )
			_resolvedProfile = ResolveProfile();

		if ( _resolvedProfile is null )
			return;

		if ( !_initialized )
		{
			_ammo = GetComponent<WeaponAmmoComponent>();
			_shoot = GetComponent<ShootableWeaponInputActionEquipmentComponent>();
			_recoil = GetComponent<ShootRecoilEquipmentComponent>();
			_reload = GetComponent<ReloadableWeaponInputActionEquipmentComponent>();

			EnsureDefaultSelections();
			CaptureBaseline();
			_initialized = true;
		}

		Apply();
	}

	protected override void OnUpdate()
	{
		if ( Equipment.ViewWeaponModel.IsValid() && _resolvedProfile is null )
			EnsureInitialized();

		var targetCount = EnumerateAttachmentTargets().Count();
		if ( targetCount > 0 && targetCount != _lastAttachmentTargetCount )
		{
			_lastAttachmentTargetCount = targetCount;
			ApplyMeshVisibility();
		}
		else if ( targetCount == 0 )
		{
			_lastAttachmentTargetCount = -1;
		}

		UpdateViewModelBulletVisualsIfNeeded();
	}

	WeaponAttachmentProfile ResolveProfile()
	{
		var profileComponent = ResolveProfileComponent();
		if ( !profileComponent.IsValid() )
			return null;

		profileComponent.RebuildProfile();

		return profileComponent.Profile;
	}

	WeaponAttachmentProfileComponent ResolveProfileComponent()
	{
		var viewModel = Equipment.ViewWeaponModel;
		if ( viewModel.IsValid() && viewModel.AttachmentProfile.IsValid() )
			return viewModel.AttachmentProfile;

		return Equipment.GetComponentInChildren<WeaponAttachmentProfileComponent>();
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
			_resolvedProfile = ResolveProfile();

		if ( _resolvedProfile is null )
			return;

		RestoreBaseline();
		ApplyAggregatedModifiers( BuildAggregatedModifiers() );
		ApplyMeshVisibility();
		UpdateViewModelBulletVisuals();
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
		if ( _resolvedProfile is null )
			return;

		foreach ( var model in EnumerateAttachmentTargets() )
			ApplyMeshVisibilityToModel( model );
	}

	void UpdateViewModelBulletVisualsIfNeeded()
	{
		var ammoComponent = ResolveAmmoForBulletVisuals();
		if ( !ammoComponent.IsValid() || !Equipment.ViewWeaponModel.IsValid() )
			return;

		var ammo = ammoComponent.Ammo;
		var selectedBulletOption = GetSelection( "bullet" );

		if ( ammo == _lastViewAmmoForBulletVisuals
			&& string.Equals( selectedBulletOption, _lastBulletSelectionForVisuals, StringComparison.OrdinalIgnoreCase ) )
			return;

		UpdateViewModelBulletVisuals();
	}

	void UpdateViewModelBulletVisuals()
	{
		var ammoComponent = ResolveAmmoForBulletVisuals();
		if ( !ammoComponent.IsValid() || !Equipment.ViewWeaponModel.IsValid() )
			return;

		var viewModelRoot = Equipment.ViewWeaponModel.GetSlotRoot( "bullet" );
		if ( !viewModelRoot.IsValid() )
			return;

		var bulletOptionComponents = ResolveBulletOptionComponents( viewModelRoot );
		var bulletOptions = bulletOptionComponents
			.Select( option => new BulletVisualOption
			{
				GameObject = option.GameObject,
				OptionId = option.OptionId,
				MagIndex = Math.Max( option.MagIndex, 0 ),
				Count = option.BulletCount > 0
					? option.BulletCount
					: ParseBulletCountFromOption( option.OptionId ),
				ReferencedRenderer = option.BulletRenderer
			} )
			.Where( x => x.Count > 0 && x.ReferencedRenderer.IsValid() )
			.ToList();

		if ( bulletOptions.Count == 0 )
			return;

		var selectedBulletOption = GetSelection( "bullet" );
		var magCapacities = ResolveMagCapacities( bulletOptions, selectedBulletOption );
		SyncTrackedBulletsByMag( ammoComponent.Ammo, magCapacities );

		foreach ( var magGroup in bulletOptions.GroupBy( x => x.MagIndex ) )
		{
			var magIndex = magGroup.Key;
			var desiredVisibleCount = _trackedBulletsByMag.TryGetValue( magIndex, out var trackedCount ) ? trackedCount : 0;

			var active = magGroup
				.Where( x => x.Count <= desiredVisibleCount )
				.OrderByDescending( x => x.Count )
				.FirstOrDefault();

			// If this mag has bullets left but no option matched (e.g. non-local count ranges),
			// keep visibility within this mag-index group instead of showing empty.
			if ( active is null && desiredVisibleCount > 0 )
			{
				active = magGroup
					.OrderByDescending( x => x.Count )
					.FirstOrDefault();
			}

			foreach ( var entry in magGroup )
			{
				var enabled = active is not null && ReferenceEquals( entry.GameObject, active.GameObject );
				SetBulletVisualEnabled( entry, enabled );
			}
		}

		_lastViewAmmoForBulletVisuals = ammoComponent.Ammo;
		_lastBulletSelectionForVisuals = selectedBulletOption;
	}

	List<BulletAttachmentOptionComponent> ResolveBulletOptionComponents( GameObject viewModelRoot )
	{
		var bulletOptions = new List<BulletAttachmentOptionComponent>();
		var seenOptionObjects = new HashSet<GameObject>();

		void TryAddOption( BulletAttachmentOptionComponent option )
		{
			if ( !option.IsValid() )
				return;

			if ( !option.GameObject.IsValid() )
				return;

			if ( !seenOptionObjects.Add( option.GameObject ) )
				return;

			bulletOptions.Add( option );
		}

		var profileComponent = ResolveProfileComponent();
		if ( profileComponent.IsValid() )
		{
			foreach ( var slot in profileComponent.GetAssignedSlots() )
			{
				foreach ( var option in slot.GetOptionComponents().OfType<BulletAttachmentOptionComponent>() )
					TryAddOption( option );
			}
		}

		foreach ( var slot in viewModelRoot.Components.GetAll<WeaponAttachmentSlotComponent>( FindMode.EverythingInSelfAndDescendants ) )
		{
			foreach ( var option in slot.GetOptionComponents().OfType<BulletAttachmentOptionComponent>() )
				TryAddOption( option );
		}

		return bulletOptions;
	}

	static void SetBulletVisualEnabled( BulletVisualOption entry, bool enabled )
	{
		if ( entry is null || !entry.GameObject.IsValid() || !entry.ReferencedRenderer.IsValid() )
			return;

		entry.GameObject.Enabled = enabled;
		entry.ReferencedRenderer.Enabled = enabled;
		entry.ReferencedRenderer.RenderType = enabled
			? ModelRenderer.ShadowRenderType.On
			: ModelRenderer.ShadowRenderType.Off;
	}

	static Dictionary<int, int> ResolveMagCapacities( IEnumerable<BulletVisualOption> bulletOptions, string selectedBulletOption )
	{
		var capacities = new Dictionary<int, int>();

		foreach ( var group in bulletOptions.GroupBy( x => x.MagIndex ) )
		{
			var selectedConfiguredCount = group
				.Where( x =>
					x.OptionId.Equals( selectedBulletOption, StringComparison.OrdinalIgnoreCase )
					|| x.GameObject.Name.Equals( selectedBulletOption, StringComparison.OrdinalIgnoreCase ) )
				.Select( x => x.Count )
				.DefaultIfEmpty( ParseBulletCountFromOption( selectedBulletOption ) )
				.FirstOrDefault();

			var maxConfigured = group.Max( x => x.Count );
			var capacity = selectedConfiguredCount > 0 ? selectedConfiguredCount : maxConfigured;
			capacities[group.Key] = Math.Max( capacity, 0 );
		}

		return capacities;
	}

	void SyncTrackedBulletsByMag( int totalAmmo, Dictionary<int, int> magCapacities )
	{
		totalAmmo = Math.Max( totalAmmo, 0 );
		var sortedMagIndices = magCapacities.Keys.OrderBy( i => i ).ToList();
		if ( sortedMagIndices.Count == 0 )
			return;

		// Initialize tracked mags at full capacity.
		if ( _lastTrackedBulletAmmoTotal == int.MinValue )
		{
			_trackedBulletsByMag.Clear();
			foreach ( var magIndex in sortedMagIndices )
				_trackedBulletsByMag[magIndex] = Math.Max( magCapacities[magIndex], 0 );
		}

		// Clamp existing tracked counts to currently selected capacities.
		foreach ( var magIndex in sortedMagIndices )
		{
			_trackedBulletsByMag.TryGetValue( magIndex, out var current);
			_trackedBulletsByMag[magIndex] = Math.Clamp( current, 0, magCapacities[magIndex] );
		}

		// Ammo sync value represents active mag rounds. Keep other mags tracked independently.
		var activeMagIndex = sortedMagIndices[0];
		_trackedBulletsByMag[activeMagIndex] = Math.Clamp( totalAmmo, 0, magCapacities[activeMagIndex] );

		_lastTrackedBulletAmmoTotal = totalAmmo;
	}

	WeaponAmmoComponent ResolveAmmoForBulletVisuals()
	{
		if ( _ammo.IsValid() )
			return _ammo;

		_ammo = GetComponent<WeaponAmmoComponent>();
		if ( _ammo.IsValid() )
			return _ammo;

		return Equipment?.GetComponentInChildren<WeaponAmmoComponent>( true );
	}

	static int ParseBulletCountFromOption( params string[] values )
	{
		foreach ( var value in values )
		{
			if ( string.IsNullOrWhiteSpace( value ) )
				continue;

			var digits = new string( value.Where( char.IsDigit ).ToArray() );
			if ( int.TryParse( digits, out var count ) && count > 0 )
				return count;
		}

		return 0;
	}

	void ApplyMeshVisibilityToModel( WeaponModelComponent model )
	{
		if ( !model.IsValid() )
			return;

		foreach ( var slot in _resolvedProfile.Slots )
		{
			if ( ( slot.Category.Equals( "arms", StringComparison.OrdinalIgnoreCase )
					|| slot.Category.Equals( "glove", StringComparison.OrdinalIgnoreCase ) )
				&& model is not ViewModelWeaponComponent )
				continue;

			var root = model.GetSlotRoot( slot.Category );
			if ( !root.IsValid() )
				continue;

			AttachmentSlotUtility.SetSlotVisible( root, slot.Category, GetSelection( slot.Category ) );
		}
	}

	IEnumerable<WeaponModelComponent> EnumerateAttachmentTargets()
	{
		if ( Equipment.ViewWeaponModel.IsValid() )
			yield return Equipment.ViewWeaponModel;

		if ( Equipment.WorldWeaponModel.IsValid() )
			yield return Equipment.WorldWeaponModel;

		var mounted = TryGetMountedWeaponModel();
		if ( mounted.IsValid() )
			yield return mounted;
	}

	WeaponModelComponent TryGetMountedWeaponModel()
	{
		var owner = Equipment.Owner;
		if ( !owner.IsValid() )
			return null;

		var mountPoints = owner.Components.Get<EquipmentMountPointsComponent>();
		if ( !mountPoints.IsValid() )
			return null;

		var mount = mountPoints.GetMount( Equipment );
		if ( mount is null || !mount.Mounted.TryGetValue( Equipment, out var mountedGo ) || !mountedGo.IsValid() )
			return null;

		return mountedGo.Components.GetInChildren<WorldWeaponModelComponent>()
			?? mountedGo.Components.GetInChildren<WeaponModelComponent>();
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
