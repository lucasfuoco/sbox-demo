using Sandbox.GameEvents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public sealed class RoundBasedTeamScoringComponent : Component,
	IGameEventHandler<ResetScoresEvent>
{
	[Sync( SyncFlags.FromHost )] public NetList<Team> RoundWinHistory { get; private set; } = new();

	public void AddRoundResult( Team team )
	{
		RoundWinHistory.Add( team );
	}

	void IGameEventHandler<ResetScoresEvent>.OnGameEvent( ResetScoresEvent eventArgs )
	{
		RoundWinHistory.Clear();
	}
}

/// <summary>
/// Increment a team's score when entering this state.
/// </summary>
public sealed class IncrementTeamScore : Component,
	IGameEventHandler<EnterStateEvent>
{
	[Property, Sync( SyncFlags.FromHost )]
	public Team Team { get; set; }

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		if ( Team is Team.Unassigned )
		{
			return;
		}

		var teamScoring = GameModeSingletonComponent.Instance.Get<TeamScoringComponent>();
		var roundBasedTeamScoring = GameModeSingletonComponent.Instance.Get<RoundBasedTeamScoringComponent>();

		teamScoring?.IncrementScore( Team );
		roundBasedTeamScoring?.AddRoundResult( Team );
	}
}
