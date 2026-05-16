using System.Linq;
using Sandbox.GameEvents;
using Sandbox.Attributes;
using Sandbox.Components.PawnComponents;

namespace Sandbox.Components;

public sealed class HumanOutfitterComponent : Component,
	IGameEventHandler<TeamChangedEvent>
{
	public struct TeamModelEntry 
	{
		[KeyProperty] public List<Model> Models { get; set; }
	}

	[Property] public PlayerPawnComponent PlayerPawn { get; set; }
	[Property] public SkinnedModelRenderer Renderer { get; set; }
	[Property, InlineEditor] public Dictionary<Team, TeamModelEntry> TeamBaseModels { get; set; } = new();

	void IGameEventHandler<TeamChangedEvent>.OnGameEvent( TeamChangedEvent eventArgs )
	{
		UpdateFromTeam( eventArgs.After );
	}

	/// <summary>
	/// Called to wear an outfit based off a team.
	/// </summary>
	/// <param name="team"></param>
	[Rpc.Broadcast( NetFlags.HostOnly )]
	public void UpdateFromTeam( Team team )
	{
		if ( Renderer is null )
			return;

		if ( !TryResolveModels( team, out var models ) )
		{
			Log.Warning( $"{this}: TeamBaseModels has no entries for team {team} (or any fallback). Assign models in the prefab." );
			return;
		}

		var usable = models.Where( static m => m is not null ).ToList();
		if ( usable.Count == 0 )
		{
			Log.Warning( $"{this}: Team models list for team {team} has no valid (non-null) models." );
			return;
		}

		Renderer.Model = Game.Random.FromList( usable );
		PlayerPawn?.Body?.Refresh();
	}

	bool TryResolveModels( Team team, out List<Model> models )
	{
		if ( TeamBaseModels is null )
		{
			models = null;
			return false;
		}

		if ( TeamBaseModels.TryGetValue( team, out var entry ) && HasModels( entry ) )
		{
			models = entry.Models;
			return true;
		}

		foreach ( var fallback in new[] { Team.Terrorist, Team.CounterTerrorist } )
		{
			if ( TeamBaseModels.TryGetValue( fallback, out entry ) && HasModels( entry ) )
			{
				models = entry.Models;
				return true;
			}
		}

		foreach ( var kv in TeamBaseModels )
		{
			if ( HasModels( kv.Value ) )
			{
				models = kv.Value.Models;
				return true;
			}
		}

		models = null;
		return false;
	}

	static bool HasModels( TeamModelEntry entry ) =>
		entry.Models is { Count: > 0 };
}
