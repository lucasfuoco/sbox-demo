namespace Sandbox.Valids.MinimapElementValids;

// Icons
public interface IMinimapIconValid : IMinimapElementValid
{
	public string IconPath { get; }
	public int IconOrder => 22;
}