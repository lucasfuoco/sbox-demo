using Sandbox.Components.SingletonComponents;
using Sandbox.GameEvents;

namespace Sandbox.Components;

public abstract class RespawnerComponent : Component,
	IGameEventHandler<UpdateStateGameEvent>
{
	[Property, Sync( SyncFlags.FromHost )] public float RespawnDelaySeconds { get; set; } = 3f;
	[Property] public bool AllowSpectatorsToSpawn { get; set; } = false;

	/// <summary>
	/// How long until respawn?
	/// </summary>
	/// <returns></returns>
	public int GetRespawnTime()
	{
		return (RespawnDelaySeconds - ClientComponent.Local.TimeSinceRespawnStateChanged).Clamp( 0f, RespawnDelaySeconds ).CeilToInt();
	}

	void IGameEventHandler<UpdateStateGameEvent>.OnGameEvent( UpdateStateGameEvent eventArgs )
	{
		foreach ( var player in GameUtils.AllPlayers )
		{
			if ( player.PlayerPawn.IsValid() && player.PlayerPawn.HealthComponent.State == LifeState.Alive )
				continue;

			if ( !player.IsConnected )
				continue;

			if ( !AllowSpectatorsToSpawn && player.Team == Team.Unassigned )
			{
				continue;
			}

			switch ( player.RespawnState )
			{
				case RespawnState.Requested:
					player.RespawnState = RespawnState.Delayed;

					if ( !player.IsBot )
					{
						using ( Rpc.FilterInclude( player.Connection ) )
						{
							GameModeSingletonComponent.Instance.ShowToast( "Respawning...", duration: RespawnDelaySeconds );
						}
					}

					break;

				case RespawnState.Delayed:
					if ( player.TimeSinceRespawnStateChanged > RespawnDelaySeconds )
					{
						player.RespawnState = RespawnState.Immediate;
					}
					break;

				case RespawnState.Immediate:
					player.Respawn( true );
					break;
			}
		}
	}
}
