using Sandbox.Components;
using Sandbox.Components.PawnComponents;

namespace Sandbox.GameEvents;

public record EquipmentDeployedEvent( EquipmentComponent Equipment ) : IGameEvent;
public record EquipmentHolsteredEvent( EquipmentComponent Equipment ) : IGameEvent;
public record EquipmentDestroyedEvent( EquipmentComponent Equipment ) : IGameEvent;
public record EquipmentTagChanged( EquipmentComponent Equipment, string Tag, bool Value ) : IGameEvent;
public record EquipmentDroppedEvent( DroppedEquipmentComponent Dropped, PlayerPawnComponent Player ) : IGameEvent;
public record EquipmentPickedUpEvent( PlayerPawnComponent Player, DroppedEquipmentComponent Dropped, EquipmentComponent Equipment ) : IGameEvent;