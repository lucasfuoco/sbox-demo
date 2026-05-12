using Sandbox.Valids;
using Sandbox.Valids.MinimapElementValids;
using Sandbox.GameResources;

namespace Sandbox.Components;

partial class DroppedEquipmentComponent : IMinimapIconValid
{
	[RequireComponent] public SpottableComponent Spottable { get; private set; }

	string IMinimapIconValid.IconPath => "ui/minimaps/icon-map_bomb.png";
	Vector3 IMinimapElementValid.WorldPosition => WorldPosition;

	bool IMinimapElementValid.IsVisible( PawnComponent viewer )
	{
		if ( Resource.Slot != EquipmentSlot.Special )
			return false;

		// only showing C4 right now
		if ( Spottable is not null )
		{
			if ( Spottable.IsSpotted || Spottable.WasSpotted )
				return true;
		}

		return viewer.Team == Team.Terrorist;
	}
}
