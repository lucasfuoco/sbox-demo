using Sandbox.Components.PawnComponents;

namespace Sandbox.Valids;

public record UseResult
{
	public bool CanUse { get; set; } = false;
	public string Reason { get; set; }

	// How on god's green earth is this legal
	public static implicit operator UseResult( bool boolean ) => new UseResult() { CanUse = boolean };
	public static implicit operator UseResult( string reason ) => new UseResult() { CanUse = false, Reason = reason };
}

public interface IUseValid : IValid
{
	public UseResult CanUse( PlayerPawnComponent player );
	public void OnUse( PlayerPawnComponent player );
	public GrabAction GetGrabAction() => GrabAction.None;
}
