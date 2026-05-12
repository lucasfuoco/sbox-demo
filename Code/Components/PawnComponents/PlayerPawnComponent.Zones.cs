namespace Sandbox.Components.PawnComponents;

partial class PlayerPawnComponent
{
	private readonly List<ZoneComponent> _zones = new();

	/// <summary>
	/// Which <see cref="ZoneComponent"/>s is the player currently standing in.
	/// </summary>
	public IEnumerable<ZoneComponent> Zones => _zones;

	/// <summary>
	/// Update which <see cref="ZoneComponent"/>s the player is standing in.
	/// </summary>
	private void UpdateZones()
	{
		_zones.Clear();
		_zones.AddRange( ZoneComponent.GetAt( WorldPosition ) );
	}

	public T GetZone<T>() where T : Component
	{
		return Zones.Select( x => x.GetComponent<T>() ).FirstOrDefault( x => x.IsValid() );
	}
}
