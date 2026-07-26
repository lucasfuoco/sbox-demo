using Sandbox.Attributes;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Skip to the next state once procedural terrain chunks around the stream position are loaded.
/// </summary>
public sealed class WaitForMapToLoadComponent : Component,
	IGameEventHandler<EnterStateEvent>,
	IGameEventHandler<UpdateStateEvent>
{
	[RequireComponent] public StateComponent State { get; private set; }

	[Property, Title( "Timeout Seconds" ), Description( "Stop blocking the match if terrain never finishes loading." )]
	public float TimeoutSeconds { get; set; } = 12f;

	TimeSince _sinceEntered;

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		_sinceEntered = 0;
	}

	[Late]
	void IGameEventHandler<UpdateStateEvent>.OnGameEvent( UpdateStateEvent eventArgs )
	{
		if ( IsMapLoaded() || _sinceEntered > MathF.Max( TimeoutSeconds, 1f ) )
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
