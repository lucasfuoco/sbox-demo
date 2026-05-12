using Sandbox;

namespace Sandbox.Valids;

/// <summary>
/// A component that has a team on it.
/// </summary>
public interface ITeamValid : IValid
{
	public Team Team { get; set; }
}