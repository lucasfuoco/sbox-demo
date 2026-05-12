using Sandbox.GameEvents;
using Sandbox.Attributes;

namespace Sandbox.Components;

public sealed class LossBonusComponent : Component,
	IGameEventHandler<TeamIncomeGameEvent>,
	IGameEventHandler<ResetScoresEvent>,
	IGameEventHandler<TeamsSwappedEvent>,
	IGameEventHandler<TeamScoreIncrementedEvent>
{
	[Property]
	public int MaxRounds { get; set; } = 4;

	[Property]
	public int ValuePerRound { get; set; } = 500;

	[Sync( SyncFlags.FromHost )]
	public NetDictionary<Team, int> CurrentLossBonus { get; private set; } = new();

	[Sync( SyncFlags.FromHost )]
	public Team LastWinningTeam { get; private set; }

	void IGameEventHandler<TeamIncomeGameEvent>.OnGameEvent( TeamIncomeGameEvent eventArgs )
	{
		if ( eventArgs.Team == LastWinningTeam )
		{
			return;
		}

		var rounds = CurrentLossBonus.GetValueOrDefault( eventArgs.Team );

		eventArgs.Value += rounds * ValuePerRound;

		CurrentLossBonus[eventArgs.Team] = Math.Min( MaxRounds, CurrentLossBonus.GetValueOrDefault( eventArgs.Team ) + 1 );
	}

	void IGameEventHandler<ResetScoresEvent>.OnGameEvent( ResetScoresEvent eventArgs )
	{
		CurrentLossBonus.Clear();
		LastWinningTeam = Team.Unassigned;
	}

	void IGameEventHandler<TeamsSwappedEvent>.OnGameEvent( TeamsSwappedEvent eventArgs )
	{
		CurrentLossBonus.Clear();
		LastWinningTeam = Team.Unassigned;
	}

	void IGameEventHandler<TeamScoreIncrementedEvent>.OnGameEvent( TeamScoreIncrementedEvent eventArgs )
	{
		LastWinningTeam = eventArgs.Team;
		CurrentLossBonus[eventArgs.Team] = Math.Max( 0, CurrentLossBonus.GetValueOrDefault( eventArgs.Team ) - 1 );
	}
}
