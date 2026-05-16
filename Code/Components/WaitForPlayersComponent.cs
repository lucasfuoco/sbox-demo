using Sandbox.GameEvents;
using Sandbox.Attributes;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Skip to the next state if enough players are connected.
/// </summary>
public sealed class WaitForPlayersComponent : Component,
	IGameEventHandler<EnterStateEvent>,
	IGameEventHandler<UpdateStateEvent>
{
	[RequireComponent] public StateComponent State { get; private set; }

	[DeveloperCommand( "Pause Game Start", "Game Loop" )]
	public static void DevToggle()
	{
		GameModeSingletonComponent.Instance
			?.Get<WaitForPlayersComponent>()
			?.Toggle();
	}

	/// <summary>
	/// Only start the game if there are at least this many players.
	/// </summary>
	[Property, Sync( SyncFlags.FromHost )]
	public int MinPlayerCount { get; set; } = 2;

	/// <summary>
	/// Immediately start the game if this number of players are connected.
	/// </summary>
	[Property, Sync( SyncFlags.FromHost )]
	public int SkipPlayerCount { get; set; } = 10;

	[Sync( SyncFlags.FromHost )]
	public bool IsPostponed { get; set; }

	public float Remaining => State.DefaultDuration - Time.Now + GameModeSingletonComponent.Instance.StateMachine.NextStateTime;

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		IsPostponed = false;
	}

	void IGameEventHandler<UpdateStateEvent>.OnGameEvent( UpdateStateEvent eventArgs )
	{
		var stateMachine = GameModeSingletonComponent.Instance.StateMachine;
		var playerCount = GameUtils.AllPlayers.Count( x => x.IsConnected );

		if ( IsPostponed || playerCount < MinPlayerCount )
		{
			stateMachine.ClearTransition();
			return;
		}

		if ( playerCount >= SkipPlayerCount )
		{
			stateMachine.Transition( eventArgs.State.DefaultNextState! );
			return;
		}

		if ( stateMachine.NextState is null || float.IsPositiveInfinity( stateMachine.NextStateTime ) )
		{
			stateMachine.Transition( eventArgs.State.DefaultNextState!, eventArgs.State.DefaultDuration );
		}
	}

	private void Toggle()
	{
		if ( IsPostponed ) Restart();
		else Postpone();
	}

	private void Postpone()
	{
		IsPostponed = true;

		GameModeSingletonComponent.Instance.ShowStatusText( "Paused" );
		GameModeSingletonComponent.Instance.HideTimer();
	}

	private void Restart()
	{
		State.Transition( State );
	}
}
