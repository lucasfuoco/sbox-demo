using Sandbox.Components.PawnComponents;
using Sandbox.GameResources;

namespace Sandbox.Components;

public partial class PlayerLoadoutComponent : Component
{
	[Property] public ClientComponent Client { get; set; }

	[Property] public List<EquipmentResource> Equipment { get; set; }
	[Property, Sync( SyncFlags.FromHost )] public bool HasDefuseKit { get; set; }

	/// <summary>
	/// Clears the player's loadout equipment.
	/// </summary>
	public void SetFrom( PlayerPawnComponent playerPawn )
	{
		Equipment.Clear();
		Equipment.AddRange( playerPawn.Inventory.Equipment.Select( x => x.Resource ) );
	}
}
