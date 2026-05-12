using Sandbox.Components;

namespace Sandbox.GameObjectSystems;

public partial class PlayAreaSystemGameObjectSystem : GameObjectSystem
{
	public PlayAreaSystemGameObjectSystem( Scene scene ) : base( scene )
	{
		//
	}

	public List<PlayerAreaComponent> All { get; set; } = new();
	public int Count { get; set; } = 0;
}
