using System.Text.Json.Serialization;
using Sandbox.Attributes;
using Sandbox.Components.PawnComponents;
using Sandbox.Components;
using Sandbox.GameResources;

namespace Sandbox;

public class MountPoint
{
	[KeyProperty] public EquipmentSlot Slot { get; set; }
	[KeyProperty] public List<GameObject> GameObjects { get; set; } = new();

	/// <summary>
	/// What's currently mounted?
	/// </summary>
	[JsonIgnore]
	public Dictionary<EquipmentComponent, GameObject> Mounted { get; set; } = new();

	public bool Mount( EquipmentComponent equipment, PlayerPawnComponent player )
	{
		Unmount( equipment, player );

		if ( Mounted.Count < GameObjects.Count )
		{
			var mountSpot = GameObjects.ElementAt( Mounted.Count );
			var inst = equipment.MountedPrefab?.Clone( new CloneConfig()
			{
				Transform = new Transform(),
				Parent = mountSpot,
				StartEnabled = true
			} );

			if ( inst.IsValid() )
			{
				inst.BreakFromPrefab();
				Mounted.Add( equipment, inst );
			}
		}

		return true;
	} 

	public bool Unmount( EquipmentComponent equipment, PlayerPawnComponent player )
	{
		if ( Mounted.TryGetValue( equipment, out var inst ) )
		{
			Log.Info( $"Found mount point for {equipment}" );
			Mounted.Remove( equipment );
			inst.Destroy();

			return true;
		}
		return false;
	}
}