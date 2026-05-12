using Sandbox.Components.PawnComponents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public enum RespawnState
{
	Not,
	Requested,
	Delayed,
	Immediate
}

public partial class ClientComponent
{
	/// <summary>
	/// The prefab to spawn when we want to make a player pawn for the player.
	/// </summary>
	[Property] public GameObject PlayerPawnPrefab { get; set; }

	public TimeSince TimeSinceRespawnStateChanged { get; private set; }
	public DamageInfo LastDamageInfo { get; private set; }

	/// <summary>
	/// Are we ready to respawn?
	/// </summary>
	[Sync( SyncFlags.FromHost ), Change( nameof( OnRespawnStateChanged ))] public RespawnState RespawnState { get; set; }

	public bool IsRespawning => RespawnState is RespawnState.Delayed;

	private void Spawn( SpawnPointInfo spawnPoint )
	{
		var prefab = PlayerPawnPrefab.Clone( spawnPoint.Transform );
		var pawn = prefab.GetComponent<PlayerPawnComponent>();

		pawn.Client = this;

		pawn.SetSpawnPoint( spawnPoint );

		prefab.NetworkSpawn( Network.Owner );

		PlayerPawn = pawn;
		if ( IsBot )
			Pawn = pawn;
				
		RespawnState = RespawnState.Not;
		pawn.OnRespawn();
	}

	public void Respawn( bool forceNew )
	{
		var spawnPoint = GameModeSingletonComponent.Instance.Get<ISpawnAssigner>() is { } spawnAssigner
			? spawnAssigner.GetSpawnPoint( this )
			: GameUtils.GetRandomSpawnPoint( Team );

		Log.Info( $"Spawning player.. ( {GameObject.Name} ({DisplayName}, {Team}), {spawnPoint.Position}, [{string.Join( ", ", spawnPoint.Tags )}] )" );

		if ( forceNew || !PlayerPawn.IsValid() || PlayerPawn.HealthComponent.State == LifeState.Dead )
		{
			PlayerPawn?.GameObject?.Destroy();
			PlayerPawn = null;

			Spawn( spawnPoint );
		}
		else
		{
			PlayerPawn.SetSpawnPoint( spawnPoint );
			PlayerPawn.OnRespawn();
		}
	}

	public void OnKill( DamageInfo damageInfo )
	{
		LastDamageInfo = damageInfo;
	}

	protected void OnRespawnStateChanged( RespawnState oldValue, RespawnState newValue )
	{
		TimeSinceRespawnStateChanged = 0f;
	}

	public PlayerPawnComponent GetLastKiller()
	{
		return GameUtils.GetPlayerFromComponent( LastDamageInfo?.Attacker );
	}
}
