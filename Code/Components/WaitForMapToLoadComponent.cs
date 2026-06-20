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

	[Property, Title( "Chunk Streamer" ), Description( "Optional chunk streamer to wait on. When empty, all enabled streamers in the scene must finish loading." )]
	public ChunkStreamerComponent ChunkStreamer { get; set; }

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

		if ( ChunkStreamer.IsValid() )
			return ChunkStreamer.IsViewLoaded();

		foreach ( var streamer in Scene.GetAllComponents<ChunkStreamerComponent>() )
		{
			if ( !streamer.IsValid() || !streamer.Enabled )
				continue;

			if ( !streamer.IsViewLoaded() )
				return false;
		}

		return true;
	}
}
