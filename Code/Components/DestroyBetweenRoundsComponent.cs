using Sandbox.GameEvents;

namespace Sandbox.Components;

/// <summary>
/// Destroy this object when a <see cref="BetweenRoundCleanupEventComponent"/> is dispatched.
/// </summary>
public sealed class DestroyBetweenRoundsComponent : Component,
	IGameEventHandler<BetweenRoundCleanupEvent>
{
	void IGameEventHandler<BetweenRoundCleanupEvent>.OnGameEvent( BetweenRoundCleanupEvent eventArgs )
	{
		GameObject.Destroy();
	}
}
