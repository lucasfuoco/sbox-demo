namespace Sandbox.Components.SingletonComponents;

/// <summary>
/// An ActionGraph helper so we can access the gamemode in an ActionGraph.
/// </summary>
partial class ActionGraphHelpers
{
	[ActionGraphNode( "gamemode" )]
	public static GameModeSingletonComponent GetGameMode => GameModeSingletonComponent.Instance;
}

