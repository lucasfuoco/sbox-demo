using Sandbox.Attributes;
using Sandbox.GameEvents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Skip to the next state once procedural terrain chunks around the stream position are loaded.
/// </summary>
public sealed class WaitForMapToLoadComponent : Component,
	IGameEventHandler<UpdateStateEvent>
{
	[RequireComponent] public StateComponent State { get; private set; }

	[Late]
	void IGameEventHandler<UpdateStateEvent>.OnGameEvent( UpdateStateEvent eventArgs )
	{
		if ( IsMapLoaded() )
			return;

		var stateMachine = GameModeSingletonComponent.Instance?.StateMachine;
		if ( !stateMachine.IsValid() )
			return;

		stateMachine.ClearTransition();
	}

	bool IsMapLoaded()
	{
		if ( Scene is null )
			return true;

		var hasStreamer = false;

		foreach ( var streamer in Scene.GetAllComponents<ChunkStreamerComponent>() )
		{
			if ( !streamer.IsValid() || !streamer.Enabled )
				continue;

			hasStreamer = true;

			if ( !streamer.IsViewLoaded() )
				return false;
		}

		return true;
	}
}
