using Sandbox.Components.PawnComponents;
using Sandbox.UI.Panels;
using Sandbox.Valids;
using Sandbox.Valids.MinimapElementValids;
using Sandbox.Valids.MinimapElementValids.MinimapIconValids;
using Sandbox.Valids.MinimapElementValids.MinimapIconValids.CustomMinimapIconValids;
using Sandbox.UI;
namespace Sandbox.Components;

/// <summary>
/// A component that handles the state of the player's marker on the minimap and the HUD.
/// </summary>
public partial class PlayerMarkerComponent : Component, IMarkerObjectValid, IDirectionalMinimapIconValid
{
	/// <summary>
	/// The player.
	/// </summary>
	[RequireComponent] PlayerPawnComponent Player { get; set; }

	/// <summary>
	/// An accessor to see if the player is alive or not.
	/// </summary>
	private bool IsAlive => Player.HealthComponent.State == LifeState.Alive;

	/// <summary>
	/// Defines a custom marker panel type to instantiate. Might remove this later.
	/// </summary>
	Type IMarkerObjectValid.MarkerPanelTypeOverride => typeof( PlayerMarkerPanel );

	private Vector3 DistOffset
	{
		get
		{
			if ( !Scene.Camera.IsValid() ) return 0f;

			var dist = Scene.Camera.WorldPosition.DistanceSquared( WorldPosition );
			dist *= 0.00000225f;
			return Vector3.Up * dist;
		}
	}

	/// <summary>
	/// Where is the marker?
	/// </summary>
	Vector3 IMarkerObjectValid.MarkerPosition => WorldPosition + Vector3.Up * 70f + DistOffset;

	/// <summary>
	/// What type of icon are we using on the minimap?
	/// </summary>
	string IMinimapIconValid.IconPath
	{
		get
		{
			if ( IsEnemy ) return IsMissing ? "ui/minimaps/enemy_missing.png" : "ui/minimaps/enemy_icon.png";
			if ( !IsAlive ) return "ui/minimaps/icon-map_skull.png";
			return "ui/minimaps/player_icon.png";
		}
	}


	/// <summary>
	/// Is this a directional icon?
	/// </summary>
	bool IDirectionalMinimapIconValid.EnableDirectional => IsAlive;

	/// <summary>
	/// What direction should we be facing? Surely this could be a float?
	/// </summary>
	Angles IDirectionalMinimapIconValid.Direction => !IsAlive ? Angles.Zero : Player.EyeAngles;

	/// <summary>
	/// Defines a custom css style for this minimap icon.
	/// </summary>
	string ICustomMinimapIconValid.CustomStyle
	{
		get
		{
			if ( IsEnemy ) return "background-image-tint: rgba(255, 0, 0, 1 );";
			return $"background-image-tint: {Player.Client.PlayerColor.Hex}";
		}
	}

	/// <summary>
	/// The minimap element's position in the world.
	/// </summary>
	Vector3 IMinimapElementValid.WorldPosition => IsEnemy && IsMissing ? Player.Spottable.LastSeenPosition : WorldPosition;

	/// <summary>
	/// Is this player an enemy of the viewer?
	/// </summary>
	bool IsEnemy => ClientComponent.Viewer.Team != Player.Team;

	/// <summary>
	/// Did we spot this player recently?
	/// </summary>
	bool IsMissing => Player.Spottable.WasSpotted;

	/// <summary>
	/// Should we render this element at all?
	/// </summary>
	/// <param name="viewer"></param>
	/// <returns></returns>
	bool IMinimapElementValid.IsVisible( PawnComponent viewer )
	{
		if ( Player.HealthComponent.State != LifeState.Alive )
			return false;

		if ( IsAlive )
		{
			// Are we possessing this player?
			if ( Player.IsPossessed )
				return false;

			// seen by enemy team
			if ( Player.Spottable.IsSpotted || Player.Spottable.WasSpotted )
				return true;
		}

		if ( Player.Team == Team.Unassigned )
			return false;

		return viewer.Team == Player.Team;
	}
}
