using Sandbox;

namespace Sandbox.GameEvents;

public record TeamChangedEvent( Team Before, Team After ) : IGameEvent;