using Sandbox.Valids;
using Sandbox.Valids.MinimapElementValids;

namespace Sandbox.Components;

/// <summary>
/// A buy zone where we can buy weapons in certain gamemodes.
/// </summary>
internal class BuyZoneComponent : Component, IMinimapIconValid, IMinimapVolumeValid
{
	[Property]
	public Team Team { get; set; }

	public Color Color => Team.GetColor().WithAlpha( 0.1f );
	public Color LineColor => Team.GetColor().WithAlpha( 0.5f );

	public Vector3 Size => GetComponent<BoxCollider>().Scale;

	string IMinimapIconValid.IconPath => Team.GetIconPath();
	Angles IMinimapVolumeValid.Angles => GameObject.WorldRotation.Angles();

	int IMinimapIconValid.IconOrder => 15;

	Vector3 IMinimapElementValid.WorldPosition => WorldPosition;

	bool IMinimapElementValid.IsVisible( PawnComponent viewer ) => true;
}
