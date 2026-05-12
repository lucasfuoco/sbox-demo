using Sandbox.GameEvents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Show a warning message when entering this state, then throw everyone back to the menu when this state ends.
/// </summary>
public sealed class StartMapVotingOnEndComponent : Component,
	IGameEventHandler<EnterStateGameEvent>
{
	void IGameEventHandler<EnterStateGameEvent>.OnGameEvent( EnterStateGameEvent eventArgs )
	{
		// Start the vote system
		MapVoteSystemSingletonComponent.Create();
	}
}
