using Sandbox.Audio;
using Sandbox.GameEvents;
using Sandbox.GameResources;
using Sandbox;

namespace Sandbox.Components;

/// <summary>
/// Play a radio message at the start of this state.
/// </summary>
public sealed class PlayRadioComponent : Component,
	IGameEventHandler<EnterStateEvent>
{
	[Property]
	public bool BothTeams { get; set; }

	[Property, HideIf( nameof(BothTeams), true )]
	public Team Team { get; set; } = Team.Terrorist;

	[Property]
	public RadioSound Sound { get; set; }

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		if ( BothTeams )
		{
			RadioSoundsGameResource.Play( Team.Terrorist, Sound );
			RadioSoundsGameResource.Play( Team.CounterTerrorist, Sound );
		}
		else
		{
			RadioSoundsGameResource.Play( Team, Sound );
		}
	}
}
