using Sandbox;
using Sandbox.Components;
using Sandbox.GameEvents;

namespace Sandbox.Components;

/// <summary>
/// Track damage for every single player so we can call it back.
/// </summary>
public partial class DamageTrackerComponent : Component, IGameEventHandler<DamageTakenGlobalEvent>,
	IGameEventHandler<BetweenRoundCleanupEvent>,
	IGameEventHandler<PlayerSpawnedEvent>
{
	[Property] public bool ClearBetweenRounds { get; set; } = true;
	[Property] public bool ClearOnRespawn { get; set; } = false;

	public Dictionary<ClientComponent, List<DamageInfo>> Registry { get; set; } = new();
	public Dictionary<ClientComponent, List<DamageInfo>> MyInflictedDamage { get; set; } = new();

	[Rpc.Broadcast( NetFlags.HostOnly )]
	protected void RpcRefresh()
	{
		Refresh();
	}

	public List<DamageInfo> GetDamageOnMe()
	{
		return GetDamageInflictedTo( ClientComponent.Local );
	}

	public List<DamageInfo> GetDamageInflictedTo( ClientComponent player )
	{
		if ( !Registry.TryGetValue( player, out var list ) )
		{
			return new List<DamageInfo>();
		}

		return list;
	}

	public List<DamageInfo> GetMyInflictedDamage( ClientComponent player )
	{
		if ( !MyInflictedDamage.TryGetValue( player, out var list ) )
		{
			return new List<DamageInfo>();
		}

		return list;
	}

	public struct GroupedDamage
	{
		public ClientComponent Attacker { get; set; }
		public int Count { get; set; }
		public float Damage { get; set; }
	}

	public List<GroupedDamage> GetGroupedDamage( ClientComponent player )
	{
		var groups = new List<GroupedDamage>();

		GetDamageInflictedTo( player )
			.GroupBy( x => x.Attacker )
			.ToList()
			.ForEach( group =>
			{
				groups.Add( new()
				{
					Attacker = group.First().Attacker is PawnComponent pawn ? pawn.Client : null,
					Count = group.Count(),
					Damage = group.Sum( x => x.Damage )
				} );
			} );


		return groups;
	}

	public List<GroupedDamage> GetGroupedInflictedDamage( ClientComponent player )
	{
		var groups = new List<GroupedDamage>();

		GetMyInflictedDamage( player )
			.GroupBy( x => x.Attacker )
			.ToList()
			.ForEach( group =>
			{
				groups.Add( new()
				{
					Attacker = group.First().Attacker is PawnComponent pawn ? pawn.Client : null,
					Count = group.Count(),
					Damage = group.Sum( x => x.Damage )
				} );
			} );


		return groups;
	}

	public void Refresh()
	{
		MyInflictedDamage.Clear();
		Registry.Clear();
	}

	void IGameEventHandler<DamageTakenGlobalEvent>.OnGameEvent( DamageTakenGlobalEvent eventArgs )
	{
		var attacker = eventArgs.DamageInfo.Attacker;
		var victim = eventArgs.DamageInfo.Victim;
		var Client = victim is PawnComponent pawn ? pawn.Client : null;

		if ( !Client.IsValid() )
			return;

		var attackerClient = attacker is PawnComponent attackerPawn ? attackerPawn.Client : null;
		if ( attackerClient == ClientComponent.Local )
		{
			if ( !MyInflictedDamage.TryGetValue( Client, out var myList ) )
			{
				MyInflictedDamage.Add( Client, new()
			{
				eventArgs.DamageInfo
			} );
			}
			else
			{
				myList.Add( eventArgs.DamageInfo );
			}
		}

		if ( !Registry.TryGetValue( Client, out var list ) )
		{
			Registry.Add( Client, new()
			{
				eventArgs.DamageInfo
			} );
		}
		else
		{
			list.Add( eventArgs.DamageInfo );
		}
	}

	/// <summary>
	/// Called between rounds.
	/// </summary>
	/// <param name="eventArgs"></param>
	void IGameEventHandler<BetweenRoundCleanupEvent>.OnGameEvent( BetweenRoundCleanupEvent eventArgs )
	{
		if ( !ClearBetweenRounds ) return;
		
		// This is called for everyone, so we don't need another RPC.

		// Get rid of old data since the rounds refreshed.
		Refresh();
	}

	void IGameEventHandler<PlayerSpawnedEvent>.OnGameEvent( PlayerSpawnedEvent eventArgs )
	{
		if ( !ClearOnRespawn ) return;

		// Only include the owner
		using ( Rpc.FilterInclude( eventArgs.Player.Network.Owner ) )
		{
			// Send the refresh
			RpcRefresh();
		}
	}
}
