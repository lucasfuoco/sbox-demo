namespace Sandbox.Valids.MinimapElementValids.MinimapIconValids.CustomMinimapIconValids;

public interface IDirectionalMinimapIconValid : ICustomMinimapIconValid
{
	public bool EnableDirectional { get; }
	public Angles Direction { get; }
}