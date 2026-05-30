using Sandbox.Components;
using Sandbox.Components.WeaponEquipmentComponents;
using Sandbox.Components.WeaponModelComponents;
using Sandbox.GameEvents;
namespace Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents;

[Title( "Reload" ), Group( "Weapon Components" )]
public partial class ReloadableWeaponInputActionEquipmentComponent : WeaponInputActionEquipmentComponent,
	IGameEventHandler<EquipmentHolsteredEvent>
{
	/// <summary>
	/// How long does it take to reload?
	/// </summary>
	[Property] public float ReloadTime { get; set; } = 1.0f;

	/// <summary>
	/// How long does it take to reload while empty?
	/// </summary>
	[Property] public float EmptyReloadTime { get; set; } = 2.0f;

	[Property] public bool SingleReload { get; set; } = false;

	/// <summary>
	/// This is really just the magazine for the weapon. 
	/// </summary>
	[Property] public WeaponAmmoComponent AmmoComponent { get; set; }

	private TimeUntil TimeUntilReload { get; set; }
	[Sync] public bool IsReloading { get; set; }

	protected override void OnEnabled()
	{
		BindTag( "reloading", () => IsReloading );
	}

	protected override void OnInput()
	{
		if ( CanReload() )
		{
			StartReload();
		}
	}

	protected override void OnUpdate()
	{
		if ( !Player.IsValid() )
			return;

		if ( !Player.IsLocallyControlled )
		{
			if ( Player.Client.IsBot )
			{
				if ( IsReloading && TimeUntilReload )
				{
					EndReload();
				}
				return;
			}
			return;
		}

		if ( SingleReload && IsReloading && Input.Pressed( "Attack1" ) )
		{
			_queueCancel = true;
		}

		if ( IsReloading && TimeUntilReload )
		{
			EndReload();
		}
	}

	void IGameEventHandler<EquipmentHolsteredEvent>.OnGameEvent( EquipmentHolsteredEvent eventArgs )
	{
		if ( !IsProxy && IsReloading )
		{
			// Conna: if we're no longer deployed cancel reloading.
			CancelReload();
		}
	}

	bool CanReload()
	{
		if ( Input.Down( "Use" ) ) return false; // Don't reload if we're using something.

		return !IsReloading && AmmoComponent.IsValid() && !AmmoComponent.IsFull;
	}

	float GetReloadTime()
	{
		var empty = AmmoComponent.IsValid() && AmmoComponent.IsEmpty;

		var viewModel = Equipment.ViewWeaponModel;
		if ( viewModel.IsValid() )
		{
			var duration = viewModel.GetReloadDuration( empty );
			if ( duration > 0f )
				return duration;
		}

		if ( empty )
			return EmptyReloadTime;

		return ReloadTime;
	}

	Dictionary<float, SoundEvent> GetReloadSounds()
	{
		if ( !AmmoComponent.HasAmmo ) return EmptyReloadSounds;
		return TimedReloadSounds;
	}

	bool _queueCancel = false;

	[Rpc.Owner]
	public void StartReload()
	{
		_queueCancel = false;

		bool isContinuedReload = IsReloading;

		if ( !IsProxy )
		{
			IsReloading = true;
			TimeUntilReload = GetReloadTime();
			Equipment.SetTag( "reloading", true );
		}

		if ( SingleReload )
		{
			WeaponModelComponent.SetOnEquipmentAnimGraphRenderers( Equipment, "b_reloading", true );

			bool hasAmmo = AmmoComponent.HasAmmo;
			WeaponModelComponent.SetOnEquipmentAnimGraphRenderers( Equipment, !hasAmmo ? "b_reloading_first_shell" : "b_reloading_shell", true );
		}
		else if ( Equipment.ViewWeaponModel.IsValid() )
		{
			var emptyReload = AmmoComponent.IsValid() && AmmoComponent.IsEmpty;
			Equipment.ViewWeaponModel.BeginReloadAnimation(
				emptyReload,
				Equipment.ViewWeaponModel.GetMagReloadType(),
				Equipment.ViewWeaponModel.IsFastReload() );
		}

		foreach ( var kv in GetReloadSounds() )
		{
			// Play this sound after a certain time but only if we're reloading.
			PlayAsyncSound( kv.Key, kv.Value, () => IsReloading );
		}

		Equipment.Owner?.BodyRenderer?.Set( "b_reload", true );
	}

	[Rpc.Owner]
	void CancelReload()
	{
		if ( !IsProxy )
			IsReloading = false;

		Equipment.SetTag( "reloading", false );

		// Tags will be better so we can just react to stimuli.
		Equipment.Owner?.BodyRenderer?.Set( "b_reload", false );
		WeaponModelComponent.SetOnEquipmentAnimGraphRenderers( Equipment, "b_reloading", false );
		Equipment.ViewWeaponModel?.EndReloadAnimation();
	}

	[Rpc.Owner]
	void EndReload()
	{
		if ( !IsProxy )
		{
			if ( SingleReload )
			{
				AmmoComponent.Ammo++;
				AmmoComponent.Ammo = AmmoComponent.Ammo.Clamp( 0, AmmoComponent.MaxAmmo );

				// Reload more!
				if ( !_queueCancel && AmmoComponent.Ammo < AmmoComponent.MaxAmmo )
					StartReload();
				else
				{
					WeaponModelComponent.SetOnEquipmentAnimGraphRenderers( Equipment, "b_reloading", false );
					IsReloading = false;
					Equipment.SetTag( "reloading", false );
				}
			}
			else
			{
				IsReloading = false;
				Equipment.SetTag( "reloading", false );
				// Refill the ammo container.
				AmmoComponent.Ammo = AmmoComponent.MaxAmmo;
			}
		}

		Equipment.ViewWeaponModel?.EndReloadAnimation();
	}

	[Property] public Dictionary<float, SoundEvent> TimedReloadSounds { get; set; } = new();
	[Property] public Dictionary<float, SoundEvent> EmptyReloadSounds { get; set; } = new();

	async void PlayAsyncSound( float delay, SoundEvent snd, Func<bool> playCondition = null )
	{
		await GameTask.DelaySeconds( delay );

		// Can we play this sound?
		if ( playCondition != null && !playCondition.Invoke() )
			return;

		if ( !GameObject.IsValid() )
			return;

		GameObject.PlaySound( snd );
	}
}
