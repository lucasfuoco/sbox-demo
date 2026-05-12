using Sandbox.Components.PawnComponents;
using Sandbox.Components;

namespace Sandbox.GameEvents;

public record BombPlantedEvent( PlayerPawnComponent Planter, GameObject Bomb, BombSiteComponent BombSite ) : IGameEvent;
public record BombDefuseStartEvent( PlayerPawnComponent Defuser, GameObject Bomb, BombSiteComponent BombSite ) : IGameEvent;
public record BombDefusedEvent( PlayerPawnComponent Defuser, GameObject Bomb, BombSiteComponent BombSite ) : IGameEvent;
public record BombDetonatedEvent( GameObject Bomb, BombSiteComponent BombSite ) : IGameEvent;
public record BombDroppedEvent : IGameEvent;
public record BombPickedUpEvent : IGameEvent;

[Title( "Bomb Planted Event" )]
public class BombPlantedEventComponent : GameEventComponent<BombPlantedEvent> { }

[Title( "Bomb Defused Event" )]
public class BombDefusedEventHandler : GameEventComponent<BombDefusedEvent> { }

[Title( "Bomb Detonated Event" )]
public class BombDetonatedEventComponent : GameEventComponent<BombDetonatedEvent> { }

/// <summary>
/// Called on the host when a new player joins, before NetworkSpawn is called.
/// </summary>
public record PlayerConnectedEvent( ClientComponent Client ) : IGameEvent;

/// <summary>
/// Called on the host when a new player joins, after NetworkSpawn is called.
/// </summary>
public record PlayerJoinedEvent( ClientComponent Player ) : IGameEvent;

/// <summary>
/// Called on the host when a client leaves
/// </summary>
public record PlayerDisconnectedEvent( ClientComponent Player ) : IGameEvent;

/// <summary>
/// Called on the host when a player (re)spawns.
/// </summary>
public record PlayerSpawnedEvent( PlayerPawnComponent Player ) : IGameEvent;

/// <summary>
/// Called on the host when a player is assigned to a team.
/// </summary>
public record TeamAssignedEvent( ClientComponent Player, Team Team ) : IGameEvent;

/// <summary>
/// Called on the host when all scores should be reset.
/// </summary>
public record ResetScoresEvent : IGameEvent;

/// <summary>
/// Called on the host when both teams swap.
/// </summary>
public record TeamsSwappedEvent : IGameEvent;