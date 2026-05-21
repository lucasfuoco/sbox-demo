using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Per-weapon viewmodel animation table (replaces per-weapon <c>animations.lua</c>).
/// Assign on <see cref="WeaponModelComponents.ViewWeaponModelComponent"/> for each viewmodel prefab.
/// </summary>
[Title( "Animation Profile" ), Group( "Weapon Components" )]
public sealed class WeaponViewModelAnimationProfileComponent : Component, Component.ExecuteInEditor
{
	[Property] public string DefaultStateId { get; set; } = "Idle";

	/// <summary>
	/// Animation states for this weapon. When empty, all child <see cref="WeaponViewModelAnimationStateComponent"/> are used.
	/// </summary>
	[Property, Group( "States" )]
	public List<WeaponViewModelAnimationStateComponent> States { get; set; } = new();

	[Property, Group( "State Ids" )] public string IdleStateId { get; set; } = "Idle";
	[Property, Group( "State Ids" )] public string DrawStateId { get; set; } = "Draw";
	[Property, Group( "State Ids" )] public string EquipStateId { get; set; } = "Equip";
	[Property, Group( "State Ids" )] public string HolsterStateId { get; set; } = "Holster";
	[Property, Group( "State Ids" )] public string FireStateId { get; set; } = "Fire";
	[Property, Group( "State Ids" )] public string FireLastStateId { get; set; } = "Fire_Last";
	[Property, Group( "State Ids" )] public string ReloadStateId { get; set; } = "Reload";
	[Property, Group( "State Ids" )] public string ReloadEmptyStateId { get; set; } = "Reload_Empty";

	public WeaponViewModelAnimationProfile Profile { get; private set; }

	protected override void OnAwake() => RebuildProfile();

	protected override void OnValidate()
	{
		if ( Game.IsEditor )
			RebuildProfile();
	}

	public IEnumerable<WeaponViewModelAnimationStateComponent> GetStateComponents()
	{
		if ( States is { Count: > 0 } )
		{
			foreach ( var state in States )
			{
				if ( state.IsValid() )
					yield return state;
			}

			yield break;
		}

		foreach ( var state in Components.GetAll<WeaponViewModelAnimationStateComponent>( FindMode.EverythingInDescendants ) )
		{
			if ( state.IsValid() )
				yield return state;
		}
	}

	public void RebuildProfile()
	{
		var profile = new WeaponViewModelAnimationProfile
		{
			DefaultStateId = string.IsNullOrWhiteSpace( DefaultStateId ) ? IdleStateId : DefaultStateId,
		};

		foreach ( var stateComponent in GetStateComponents() )
			profile.AddState( stateComponent.ToState() );

		Profile = profile;
	}

	/// <summary>
	/// Optional starter for pistols. Copy and edit sequence names / timing per weapon model.
	/// </summary>
	internal void ApplyCorePistolTemplate()
	{
		ClearStateChildren();
		States.Clear();

		foreach ( var state in WeaponViewModelAnimationDefaults.CreateCorePistolTemplate() )
			States.Add( CreateStateChild( state ) );

		RebuildProfile();
	}

	void ClearStateChildren()
	{
		foreach ( var state in States.ToList() )
		{
			if ( state.IsValid() )
				state.GameObject.Destroy();
		}

		States.Clear();

		foreach ( var state in Components.GetAll<WeaponViewModelAnimationStateComponent>( FindMode.EverythingInDescendants ).ToList() )
		{
			if ( state.IsValid() )
				state.GameObject.Destroy();
		}
	}

	WeaponViewModelAnimationStateComponent CreateStateChild( WeaponViewModelAnimationState state )
	{
		var child = new GameObject( true, state.Id );
		child.Parent = GameObject;
		var component = child.Components.Create<WeaponViewModelAnimationStateComponent>();
		component.CopyFrom( state );
		return component;
	}

	public string ResolveDeployStateId( bool firstEquip )
	{
		if ( firstEquip && TryGetState( EquipStateId, out _ ) )
			return EquipStateId;

		if ( TryGetState( DrawStateId, out _ ) )
			return DrawStateId;

		return DefaultStateId;
	}

	public string ResolveReloadStateId( bool hasAmmoInMag )
	{
		var id = hasAmmoInMag ? ReloadStateId : ReloadEmptyStateId;
		if ( TryGetState( id, out _ ) )
			return id;

		if ( TryGetState( ReloadStateId, out _ ) )
			return ReloadStateId;

		return DefaultStateId;
	}

	public string ResolveFireStateId( bool isLastShot )
	{
		if ( isLastShot && TryGetState( FireLastStateId, out _ ) )
			return FireLastStateId;

		if ( TryGetState( FireStateId, out _ ) )
			return FireStateId;

		return DefaultStateId;
	}

	public bool TryGetState( string id, out WeaponViewModelAnimationState state )
	{
		if ( Profile is null )
		{
			state = null;
			return false;
		}

		return Profile.TryGetState( id, out state );
	}

	public float GetStateDuration( string id )
	{
		if ( !TryGetState( id, out var state ) || state is null )
			return 0f;

		return state.Length > 0f ? state.Length : 0f;
	}
}
