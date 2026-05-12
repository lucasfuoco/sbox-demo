namespace Sandbox.Valids.MinimapElementValids;

// Labels
public interface IMinimapLabelValid : IMinimapElementValid
{
	public string Label { get; }
	public Color LabelColor { get; }
}