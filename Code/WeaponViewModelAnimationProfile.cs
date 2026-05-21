namespace Sandbox;

/// <summary>
/// Runtime lookup built from <see cref="Components.WeaponViewModelAnimationProfileComponent"/>.
/// </summary>
public sealed class WeaponViewModelAnimationProfile
{
	public string DefaultStateId { get; set; } = "Idle";

	public Dictionary<string, WeaponViewModelAnimationState> States { get; } = new( StringComparer.OrdinalIgnoreCase );

	public bool HasStates => States.Count > 0;

	public bool TryGetState( string id, out WeaponViewModelAnimationState state )
	{
		if ( string.IsNullOrWhiteSpace( id ) )
		{
			state = null;
			return false;
		}

		return States.TryGetValue( id, out state ) && state is not null;
	}

	public void AddState( WeaponViewModelAnimationState state )
	{
		if ( state is null || string.IsNullOrWhiteSpace( state.Id ) )
			return;

		States[state.Id] = state;
	}
}
