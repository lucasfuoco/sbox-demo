using Sandbox.GameEvents;
using Sandbox.Components.PawnComponents;
using Sandbox.Components.SingletonComponents;
using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Makes respawned players invulnerable for a given duration, or until they move / shoot.
/// </summary>
public sealed class SpawnProtectionComponent : Component,
	IGameEventHandler<PlayerSpawnedEvent>
{
	private readonly Dictionary<PlayerPawnComponent, TimeSince> _spawnProtectedSince = new();

	[Property, Sync( SyncFlags.FromHost )]
	public float MaxDurationSeconds { get; set; } = 10f;

	void IGameEventHandler<PlayerSpawnedEvent>.OnGameEvent( PlayerSpawnedEvent eventArgs )
	{
		Enable( eventArgs.Player );
	}

	public void DisableAll()
	{
		foreach ( var (player, _) in _spawnProtectedSince.ToArray() )
		{
			Disable( player );
		}
	}

	protected override void OnDisabled()
	{
		DisableAll();
	}

	protected override void OnFixedUpdate()
	{
		if ( !Networking.IsHost || _spawnProtectedSince.Count == 0 )
		{
			return;
		}

		foreach ( var (player, since) in _spawnProtectedSince.ToArray() )
		{
			if ( !player.IsValid || since > MaxDurationSeconds || player.TimeSinceLastInput < since + 0.1f )
			{
				Disable( player );
			}
		}
	}

	public void Enable( PlayerPawnComponent player )
	{
		_spawnProtectedSince[player] = 0f;

		if ( player.HealthComponent.IsValid() )
			player.HealthComponent.IsGodMode = true;

		if ( !player.Client.IsBot )
		{
			using ( Rpc.FilterInclude( player.Client.Connection ) )
			{
				GameModeSingletonComponent.Instance.ShowToast( "Spawn Protected", duration: MaxDurationSeconds );
			}
		}

		Scene.Dispatch( new SpawnProtectionStartGameEvent( player ) );
	}

	public void Disable( PlayerPawnComponent player )
	{
		if ( !player.IsValid() )
			return;

		if ( !player.Client.IsValid() )
			return;

		if ( !player.Network.Active || !player.Client.Network.Active )
			return;

		_spawnProtectedSince.Remove( player );

		if ( player.HealthComponent.IsValid() )
			player.HealthComponent.IsGodMode = false;

		using ( Rpc.FilterInclude( player.Client.Connection ) )
		{
			GameModeSingletonComponent.Instance.HideToast();
		}

		Scene.Dispatch( new SpawnProtectionEndGameEvent( player ) );
	}
}
