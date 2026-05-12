using Sandbox.Components.SingletonComponents;
using Sandbox.Valids;
namespace Sandbox.UI.Panels;

public partial class MarkerSystemPanel : Panel
{
	public Dictionary<IMarkerObjectValid, MarkerPanel> ActiveMarkers { get; set; } = new();

	void Refresh()
	{
		var deleteList = new List<IMarkerObjectValid>();
		deleteList.AddRange( ActiveMarkers.Keys );

		foreach ( var markerObject in Scene.GetAllComponents<IMarkerObjectValid>() )
		{
			if ( UpdateMarker( markerObject ) )
			{
				deleteList.Remove( markerObject );
			}
		}

		foreach ( var marker in deleteList )
		{
			ActiveMarkers[marker].Delete();
			ActiveMarkers.Remove( marker );
		}
	}

	public MarkerPanel CreateMarker( IMarkerObjectValid marker )
	{
		var inst = new MarkerPanel()
		{
			Object = marker,
		};
		AddChild( inst );
		return inst;
	}

	public bool UpdateMarker( IMarkerObjectValid marker )
	{
		if ( !marker.GameObject.IsValid() )
			return false;

		if ( !marker.ShouldShow() )
			return false;

		var camera = Scene.Camera;
		if ( !camera.IsValid() )
			return false;

		if ( marker.MarkerMaxDistance != 0f && camera.WorldPosition.Distance( marker.MarkerPosition ) > marker.MarkerMaxDistance )
			return false;

		if ( !ActiveMarkers.TryGetValue( marker, out var instance ) )
		{
			instance = CreateMarker( marker );
			if ( instance.IsValid() )
			{
				ActiveMarkers[marker] = instance;
			}
		}

		instance.Reposition();

		return true;
	}

	public override void Tick()
	{
		Refresh();
	}
}
