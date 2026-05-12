namespace Sandbox.SceneEvents;

public interface ICameraSetup : ISceneEvent<ICameraSetup>
{
	// Effects before viewmodel
	public void PreSetup( CameraComponent cc ) { }

	// Place viewmodel
	public void Setup( CameraComponent cc ) { }

	// Effects including viewmodel
	public void PostSetup( CameraComponent cc ) { }
}