using Sandbox.GameEvents;
using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Dispatches a <see cref="BetweenRoundCleanupEvent"/> when entering this state.
/// </summary>
public sealed class BetweenRoundCleanupComponent : Component,
	IGameEventHandler<EnterStateEvent>
{
	[Early]
	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		Dispatch();
	}

	[Rpc.Broadcast( NetFlags.HostOnly )]
	public void Dispatch()
	{
		Scene.Dispatch( new BetweenRoundCleanupEvent() );
	}
}