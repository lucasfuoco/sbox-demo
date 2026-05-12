namespace Sandbox.Valids.MinimapElementValids;

// Volumes
public interface IMinimapVolumeValid : IMinimapElementValid
{
	public Color Color { get; }
	public Color LineColor { get; }
	public Vector3 Size { get; }
	public Angles Angles { get; }
}