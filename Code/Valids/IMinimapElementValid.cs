using Sandbox.Components;

namespace Sandbox.Valids;

public interface IMinimapElementValid : IValid
{
	public Vector3 WorldPosition { get; }
	public bool IsVisible( PawnComponent viewer );
}
