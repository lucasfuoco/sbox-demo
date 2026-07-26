namespace Sandbox.Video;

/// <summary>
/// Re-applies persisted video quality budgets once when a scene starts playing.
/// </summary>
public sealed class GraphicsQualityBootstrapSystem : GameObjectSystem
{
	bool _applied;

	public GraphicsQualityBootstrapSystem( Scene scene ) : base( scene )
	{
		Listen( Stage.StartUpdate, 0, OnStartUpdate, "GraphicsQualityBootstrap" );
	}

	void OnStartUpdate()
	{
		if ( _applied || Application.IsDedicatedServer )
			return;

		_applied = true;
		GameSettingsSystem.ApplyVideo();
	}
}
