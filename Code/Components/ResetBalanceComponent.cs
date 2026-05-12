using Sandbox.GameEvents;
using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Reset player cash to the given amount.
/// </summary>
public sealed class ResetBalanceComponent : Component,
	IGameEventHandler<EnterStateEvent>
{
	[Property]
	public int Value { get; set; } = 800;

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		foreach ( var player in GameUtils.PlayerPawns )
		{
			player.Client.SetCash( Value );
		}
	}
}
