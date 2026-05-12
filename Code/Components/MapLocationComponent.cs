using Sandbox;

namespace Sandbox.Components;

public sealed class MapLocationComponent : Component
{
	[RequireComponent]
	public ZoneComponent Zone { get; private set; }
}
