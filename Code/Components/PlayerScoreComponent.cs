using Sandbox.Attributes;
using Sandbox.GameEvents;

namespace Sandbox.Components;

/// <summary>
/// Plop this on something you're using <see cref="ScoreAttribute"/> for. We could codegen this attribute on components that use it to save this hassle.
/// </summary>
public interface IScore
{
	/// <summary>
	/// Looks for a bunch of score attributes from components on a <see cref="Client"/>, and returns a formatted, sorted list of values.
	/// </summary>
	/// <param name="Client"></param>
	/// <returns></returns>
	public static IEnumerable<(object Value, ScoreAttribute Attribute)> Find( ClientComponent Client )
	{
		var components = Client.GetComponentsInChildren<IScore>();
		var values = new List<(object Value, MemberDescription Member, ScoreAttribute Attribute)>();

		foreach ( var comp in components )
		{
			var type = TypeLibrary.GetType( comp.GetType() );

			foreach ( var member in type.Members )
			{
				if ( member.GetCustomAttribute<ScoreAttribute>() is not { } scoreAttribute )
					continue;

				if ( scoreAttribute.ShowTeamOnly && !Client.IsFriendly( ClientComponent.Local ) )
					continue;

				// Support ShowIf, which looks for a method with a boolean return to see if we can display a value
				var show = type.GetMethod( scoreAttribute.ShowIf )?.InvokeWithReturn<bool>( comp, null ) ?? true;
				if ( !show )
					continue;

				// Support special formatting values
				values.Add( (
					string.Format( scoreAttribute.Format, type.GetValue( comp, member.Name ) ),
					member, scoreAttribute
				) );
			}
		}

		return values.OrderBy( x => x.Member.GetCustomAttribute<OrderAttribute>()?.Value ?? 0 )
			// We don't need to expose x.Member
			.Select( x => (x.Value, x.Attribute) );
	}
}

/// <summary>
/// Handles all the player score values.
/// </summary>
public sealed class PlayerScoreComponent : Component,
	IGameEventHandler<KillEvent>,
	IGameEventHandler<BombDefusedEvent>,
	IGameEventHandler<BombDetonatedEvent>,
	IGameEventHandler<BombPlantedEvent>,
	IGameEventHandler<RoundCounterIncrementedEvent>,
	IGameEventHandler<RoundCounterResetEvent>,
	IGameEventHandler<ResetScoresEvent>,
	IScore
{
	[Property] public ClientComponent Client { get; set; }

	[Sync( SyncFlags.FromHost ), Property, ReadOnly, Score( "Kills" )]
	public int Kills { get; set; } = 0;

	[Sync( SyncFlags.FromHost ), Property, ReadOnly, Score( "Deaths" )]
	public int Deaths { get; set; } = 0;

	[Sync( SyncFlags.FromHost ), Property, ReadOnly, Score( "Points" ), Order( -1 )]
	public int Score { get; private set; } = 0;

	public void AddScore( int score, string reason = null )
	{
		Score += score;

		if ( Client.IsBot ) return;

		using ( Rpc.FilterInclude( Network.Owner ) )
		{
			SendScoreAdded( score, reason );
		}
	}

	[Rpc.Broadcast( NetFlags.HostOnly )]
	private void SendScoreAdded( int score, string reason = null )
	{
		Scene.Dispatch<OnScoreAddedEvent>( new OnScoreAddedEvent()
		{
			Score = score,
			Reason = reason
		} );
	}

	[Score( "Ratio", Format = "{0:0.00}" ), Order( 50 )]
	public float Ratio => (float)Kills / (float)Deaths.Clamp( 1, int.MaxValue );

	[Sync( SyncFlags.FromHost )]
	public NetList<int> ScoreHistory { get; private set; } = new();

	[Sync( SyncFlags.FromHost )]
	public bool WasBombPlanter { get; private set; }

	private const int KillScore = 25;
	private const int TeamKillScore = -25;
	private const int SuicideScore = -10;

	// Planting the C4 explosive
	private const int PlantScore = 25;

	// Bomb planter alive when the bomb explodes
	private const int BombExplodePlanterAliveScore = 35;

	// Bomb planter dead when the bomb explodes
	private const int BombExplodePlanterDeadScore = 10;

	// Other Ts alive when the bomb explodes
	private const int BombExplodeTeamAliveScore = 25;

	// Defusing bomb
	private const int DefuserScore = 50;

	// Other CTs alive when the bomb is defused
	private const int DefuseTeamAliveScore = 25;

	void IGameEventHandler<KillEvent>.OnGameEvent( KillEvent eventArgs )
	{
		if ( !Networking.IsHost )
			return;

		var damageInfo = eventArgs.DamageInfo;

		if ( !damageInfo.Attacker.IsValid() ) return;
		if ( !damageInfo.Victim.IsValid() ) return;

		var thisPlayer = Client?.PlayerPawn;
		if ( !thisPlayer.IsValid() ) return;

		var killerPlayer = GameUtils.GetPlayerFromComponent( damageInfo.Attacker );
		var victimPlayer = GameUtils.GetPlayerFromComponent( damageInfo.Victim );

		if ( !victimPlayer.IsValid() ) return;

		if ( !killerPlayer.IsValid() )
		{
			if ( victimPlayer == thisPlayer )
				Deaths++;

			return;
		}

		var isFriendly = killerPlayer.Team == victimPlayer.Team;
		var isSuicide = killerPlayer == victimPlayer;

		if ( killerPlayer == thisPlayer )
		{
			if ( isFriendly )
			{
				// Killed by friendly/teammate
				Kills--;
				Score += TeamKillScore;
			}
			else if ( isSuicide )
			{
				// Killed by suicide
				Kills--;
				AddScore( SuicideScore, "Suicide" );
			}
			else
			{
				// Valid kill, add score
				Kills++;
				AddScore( KillScore, "Killed a player" );
			}
		}
		else if ( victimPlayer == thisPlayer )
		{
			// Only count as death if this wasn't a team kill
			if ( !isFriendly )
			{
				Deaths++;
			}
		}
	}

	void IGameEventHandler<BombPlantedEvent>.OnGameEvent( BombPlantedEvent eventArgs )
	{
		var thisPlayer = Client?.PlayerPawn;
		var planterPlayer = eventArgs.Planter;

		if ( planterPlayer == thisPlayer )
		{
			// Planter is the current player
			AddScore( PlantScore, "Planted the bomb" );

			WasBombPlanter = true;
		}
		else
		{
			WasBombPlanter = false;
		}
	}

	void IGameEventHandler<BombDefusedEvent>.OnGameEvent( BombDefusedEvent eventArgs )
	{
		var thisPlayer = Client?.PlayerPawn;
		var defuserPlayer = eventArgs.Defuser;

		if ( defuserPlayer == thisPlayer )
		{
			// Defuser is the current player
			AddScore( DefuserScore, "Defused the bomb" );

		}
		else if ( thisPlayer is not null )
		{
			// Defuser is a teammate
			if ( defuserPlayer.Team == thisPlayer.Team && thisPlayer.HealthComponent.State == LifeState.Alive )
			{
				AddScore( DefuseTeamAliveScore, "Team defused the bomb" );
			}
		}
	}

	void IGameEventHandler<BombDetonatedEvent>.OnGameEvent( BombDetonatedEvent eventArgs )
	{
		var thisPlayer = Client?.PlayerPawn;
		var planterPlayer = GameUtils.PlayerPawns
			.FirstOrDefault( x => x.Client.GetComponent<PlayerScoreComponent>() is { WasBombPlanter: true } );

		if ( planterPlayer == thisPlayer )
		{
			if ( planterPlayer?.HealthComponent.State == LifeState.Alive )
			{
				// Planter is alive when the bomb explodes
				AddScore( BombExplodePlanterAliveScore, "Bomb exploded" );
			}
			else
			{
				// Planter is dead when the bomb explodes
				AddScore( BombExplodePlanterDeadScore, "Bomb exploded" );
			}
		}
		else if ( planterPlayer?.Team == thisPlayer?.Team && thisPlayer.HealthComponent.State == LifeState.Alive )
		{
			// Teammate is alive when the bomb explodes
			AddScore( BombExplodeTeamAliveScore, "Bomb exploded" );
		}
	}

	void IGameEventHandler<ResetScoresEvent>.OnGameEvent( ResetScoresEvent eventArgs )
	{
		Kills = 0;
		Deaths = 0;
		Score = 0;

		ScoreHistory.Clear();

		WasBombPlanter = false;
	}

	void IGameEventHandler<RoundCounterIncrementedEvent>.OnGameEvent( RoundCounterIncrementedEvent eventArgs )
	{
		ScoreHistory.Add( Score - ScoreHistory.LastOrDefault() );
	}

	void IGameEventHandler<RoundCounterResetEvent>.OnGameEvent( RoundCounterResetEvent eventArgs )
	{
		ScoreHistory.Clear();
	}
}
