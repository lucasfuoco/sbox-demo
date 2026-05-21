using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents;
using Sandbox.Components.WeaponModelComponents;

namespace Sandbox.Components;

/// <summary>
/// Plays <see cref="WeaponViewModelAnimationProfile"/> states on the viewmodel weapon + arms meshes.
/// </summary>
[Title( "Animation Controller" ), Group( "Weapon Components" )]
public sealed class WeaponViewModelAnimationControllerComponent : Component
{
	[Property] public ViewWeaponModelComponent ViewModel { get; set; }

	[Property] public WeaponViewModelAnimationProfileComponent ProfileSource { get; set; }

	public WeaponViewModelAnimationProfile Profile => ProfileSource?.Profile;

	public string CurrentStateId { get; private set; }

	TimeSince _stateTime;
	readonly HashSet<int> _firedEvents = new();
	WeaponViewModelAnimationState _activeState;
	float _activeDuration;

	public bool HasProfile => Profile is not null && Profile.HasStates;

	protected override void OnStart()
	{
		ResolveReferences();
		if ( !HasProfile )
			return;

		if ( ViewModel.IsValid() && ViewModel.PlayDeployEffects && ProfileSource.IsValid() )
			Play( ProfileSource.ResolveDeployStateId( ViewModel.PlayDeployEffects ) );
		else
			Play( Profile.DefaultStateId );
	}

	protected override void OnUpdate()
	{
		if ( !HasProfile || _activeState is null )
			return;

		TickEvents();
		TickTransition();
	}

	public void ResolveReferences()
	{
		if ( !ViewModel.IsValid() )
			ViewModel = GetComponentInParent<ViewWeaponModelComponent>();

		if ( !ProfileSource.IsValid() )
			ProfileSource = GetComponentInChildren<WeaponViewModelAnimationProfileComponent>()
				?? GetComponentInParent<WeaponViewModelAnimationProfileComponent>();
	}

	public bool Play( string stateId )
	{
		ResolveReferences();

		if ( !HasProfile || !Profile.TryGetState( stateId, out var state ) )
			return false;

		_activeState = state;
		CurrentStateId = state.Id;
		_stateTime = 0;
		_firedEvents.Clear();

		var sequence = PickSequence( state );
		if ( string.IsNullOrWhiteSpace( sequence ) )
			return false;

		foreach ( var renderer in GetSequenceRenderers() )
			ApplySequence( renderer, sequence, state );

		_activeDuration = ResolveDuration( state, sequence );
		return true;
	}

	public bool TryGetDuration( string stateId, out float duration )
	{
		duration = 0f;
		if ( !HasProfile || !Profile.TryGetState( stateId, out var state ) )
			return false;

		var sequence = PickSequence( state );
		duration = ResolveDuration( state, sequence );
		return duration > 0f;
	}

	void TickEvents()
	{
		if ( _activeState.Events is null )
			return;

		for ( var i = 0; i < _activeState.Events.Count; i++ )
		{
			if ( _firedEvents.Contains( i ) )
				continue;

			var evt = _activeState.Events[i];
			if ( _stateTime < evt.Time )
				continue;

			_firedEvents.Add( i );
			ExecuteEvent( evt );
		}
	}

	void TickTransition()
	{
		if ( _activeState.Loop )
			return;

		if ( _activeDuration <= 0f )
			return;

		if ( _stateTime < _activeDuration )
			return;

		var next = _activeState.NextStateId;
		if ( string.IsNullOrWhiteSpace( next ) )
			next = Profile.DefaultStateId;

		if ( string.Equals( next, _activeState.Id, StringComparison.OrdinalIgnoreCase ) )
			return;

		Play( next );
	}

	void ExecuteEvent( WeaponViewModelAnimationEvent evt )
	{
		if ( evt is null )
			return;

		switch ( evt.Action )
		{
			case WeaponViewModelAnimationAction.PlaySound:
				if ( evt.Sound.IsValid() )
					GameObject.PlaySound( evt.Sound );
				break;

			case WeaponViewModelAnimationAction.MuzzleFlash:
				GetShootable()?.SpawnMuzzleFlash();
				break;

			case WeaponViewModelAnimationAction.ShellEject:
				GetShootable()?.SpawnShellEject();
				break;

			default:
				if ( evt.Sound.IsValid() )
					GameObject.PlaySound( evt.Sound );
				break;
		}
	}

	ShootableWeaponInputActionEquipmentComponent GetShootable()
	{
		if ( !ViewModel.IsValid() || !ViewModel.Equipment.IsValid() )
			return null;

		return ViewModel.Equipment.GetComponentInChildren<ShootableWeaponInputActionEquipmentComponent>();
	}

	IEnumerable<SkinnedModelRenderer> GetSequenceRenderers()
	{
		if ( !ViewModel.IsValid() )
			yield break;

		var weapon = ViewModel.GameObject.Components.Get<SkinnedModelRenderer>();
		if ( weapon.IsValid() )
			yield return weapon;

		var arms = ViewModel.Arms;
		if ( arms.IsValid() && arms != weapon )
			yield return arms;
	}

	void ApplySequence( SkinnedModelRenderer renderer, string sequence, WeaponViewModelAnimationState state )
	{
		renderer.UseAnimGraph = false;
		renderer.PlaybackRate = state.Fps / 30f;
		renderer.Sequence.Name = sequence;
		renderer.Sequence.Looping = state.Loop;
	}

	string PickSequence( WeaponViewModelAnimationState state )
	{
		if ( state.Sequences is null || state.Sequences.Length == 0 )
			return null;

		if ( state.Sequences.Length == 1 )
			return state.Sequences[0];

		return state.Sequences[Game.Random.Int( 0, state.Sequences.Length - 1 )];
	}

	float ResolveDuration( WeaponViewModelAnimationState state, string sequence )
	{
		if ( state.Length > 0f )
			return state.Length;

		foreach ( var renderer in GetSequenceRenderers() )
		{
			if ( !renderer.IsValid() )
				continue;

			if ( renderer.Sequence.Duration > 0f )
				return renderer.Sequence.Duration;
		}

		return 0f;
	}
}
