using Sandbox.GameEvents;
using Sandbox.Components.SingletonComponents;
using Sandbox.UI.Panels;

namespace Sandbox.Components;

/// <summary>
/// Transition to the given state when one team's score reaches the given value.
/// </summary>
public sealed class TeamEarlyWinConditionComponent : Component,
	IGameEventHandler<RoundCounterIncrementedEvent>,
	IGameEventHandler<TeamScoreIncrementedEvent>
{
	/// <summary>
	/// Transition when either team reaches this score.
	/// </summary>
	[Property, Sync( SyncFlags.FromHost )]
	public int TargetScore { get; set; } = 16;

	/// <summary>
	/// Transition to this state when <see cref="Team.Terrorist"/> reaches the target score.
	/// </summary>
	[Property]
	public StateComponent TerroristVictoryState { get; set; }

	/// <summary>
	/// Transition to this state when <see cref="Team.CounterTerrorist"/> reaches the target score.
	/// </summary>
	[Property]
	public StateComponent CounterTerroristVictoryState { get; set; }

	[Property] public bool MatchPoint { get; set; } = true;

	private TeamScoringComponent TeamScoring => GameModeSingletonComponent.Instance.Get<TeamScoringComponent>( true );

	private int GetWonRounds( Team team )
	{
		return TeamScoring.Scores.GetValueOrDefault( team );
	}

	void IGameEventHandler<RoundCounterIncrementedEvent>.OnGameEvent( RoundCounterIncrementedEvent eventArgs )
	{
		if ( !MatchPoint )
			return;

		if ( GetWonRounds( Team.Terrorist ) == TargetScore - 1 || GetWonRounds( Team.CounterTerrorist ) == TargetScore - 1 )
		{
			ToastPanel.Instance.Show( "Match Point", ToastType.Generic );
		}
	}

	void IGameEventHandler<TeamScoreIncrementedEvent>.OnGameEvent( TeamScoreIncrementedEvent eventArgs )
	{
		if ( GetWonRounds( Team.Terrorist ) == TargetScore && TerroristVictoryState is not null )
		{
			GameModeSingletonComponent.Instance.StateMachine.Transition( TerroristVictoryState );
		}
		else if ( GetWonRounds( Team.CounterTerrorist ) == TargetScore && CounterTerroristVictoryState is not null )
		{
			GameModeSingletonComponent.Instance.StateMachine.Transition( CounterTerroristVictoryState );
		}
	}
}
