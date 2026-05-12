using Sandbox.GameObjectSystems;

namespace Sandbox.Components;

public partial class PlayerAreaComponent : Component
{
	[Property] public ZoneComponent Zone { get; set; }


	protected override void OnEnabled()
	{
		var system = Scene.GetSystem<PlayAreaSystemGameObjectSystem>();
		system.All.Add( this );
		system.Count = system.All.Count;
	}
}