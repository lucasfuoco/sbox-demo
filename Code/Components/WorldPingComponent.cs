using Sandbox.Valids;
using Sandbox.Valids.MinimapElementValids;
using Sandbox.Valids.MinimapElementValids.MinimapIconValids;
using Sandbox.Valids.MinimapElementValids.MinimapIconValids.CustomMinimapIconValids;
namespace Sandbox.Components;

/// <summary>
/// This is spawned clientside when a ping happens.
/// </summary>
public partial class WorldPingComponent : Component, IMarkerObjectValid, ICustomMinimapIconValid
{
	/// <summary>
	/// Who's the owner?
	/// </summary>
	public ClientComponent Owner { get; set; }

	private Vector3 MarkerPosition
	{
		get
		{
			if ( Receiver.IsValid() )
				return Receiver.Position;

			return WorldPosition + Vector3.Up * 32f;
		}
	}

	private string MarkerIcon
	{
		get
		{
			if ( Receiver.IsValid() && !string.IsNullOrEmpty( Receiver.Icon ) )
				return Receiver.Icon;

			return "ui/minimaps/player_icon.png";
		}
	}

	private string DisplayText
	{
		get
		{
			if ( Receiver.IsValid() && Receiver.Text != null )
				return Receiver.Text;

			return Owner?.Network.Owner?.DisplayName ?? "";
		}
	}

	private Color MarkerColor
	{
		get
		{
			if ( Receiver.IsValid() && Receiver.Color.HasValue )
			{
				return Receiver.Color.Value;
			}

			return Color.White;
		}
	}

	// IMarkerObject
	string IMarkerObjectValid.MarkerIcon => MarkerIcon;
	string IMarkerObjectValid.DisplayText => DisplayText;
	Vector3 IMarkerObjectValid.MarkerPosition => MarkerPosition;
	string IMarkerObjectValid.MarkerStyles => $"background-tint:{MarkerColor};";
	int IMarkerObjectValid.IconSize => Receiver.IsValid() ? 16 : 32;

	// IMinimapIcon
	string IMinimapIconValid.IconPath => MarkerIcon;
	Vector3 IMinimapElementValid.WorldPosition => MarkerPosition;

	// ICustomMinimapIcon
	string ICustomMinimapIconValid.CustomStyle => $"background-tint:{MarkerColor}";

	/// <summary>
	/// 
	/// </summary>
	public IPingReceiver Receiver { get; private set; }

	/// <summary>
	/// Are we pinging a world object that might move?
	/// </summary>
	public Component Target
	{
		set
		{
			if ( !value.IsValid() )
				return;
			
			var receiver = (value as IPingReceiver) ?? value.GameObject.Root.GetComponent<IPingReceiver>();
			if ( receiver.IsValid() )
			{
				Receiver = receiver;
			}
		}
	}

	// IMinimapElement
	bool IMinimapElementValid.IsVisible( PawnComponent viewer ) => true;

	/// <summary>
	/// Triggers the ping to tear off in X seconds.
	/// </summary>
	/// <param name="lifetime"></param>
	public void Trigger( float lifetime = 15f )
	{
		var destroy = Components.Create<DestroyAfterComponent>();
		destroy.Time = lifetime;

		Receiver?.OnPing();
	}

	protected override void OnUpdate()
	{
		if ( !Receiver.IsValid() )
			return;

		if ( !Receiver.ShouldShow() )
		{
			GameObject.Destroy();
		}
	}
}
