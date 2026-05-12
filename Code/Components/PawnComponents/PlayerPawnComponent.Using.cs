using Sandbox.UI.Panels;
using Sandbox.UI;
using Sandbox.GameEvents;
using Sandbox.Valids;
using Sandbox.Components.SingletonComponents;
using Sandbox.GameResources;

namespace Sandbox.Components.PawnComponents;

/// <summary>
/// Grab actions that the player can perform.
/// </summary>
public enum GrabAction
{
	None = 0,
	SweepDown,
	SweepRight,
	SweepLeft,
	PushButton
}

partial class PlayerPawnComponent
{
	/// <summary>
	/// Is the player holding use?
	/// </summary>
	[Sync] public bool IsUsing { get; set; }

	/// <summary>
	/// How far can we use stuff?
	/// </summary>
	[Property, Group( "Interaction" )] public float UseDistance { get; set; } = 72f;

	/// <summary>
	/// Which object did the player last press use on?
	/// </summary>
	public GameObject LastUsedObject { get; private set; }

	public IUseValid Hovered { get; private set; }

	private IEnumerable<IUseValid> GetUsables()
	{
		var hits = Scene.Trace.Ray( AimRay, UseDistance )
			.Size( 5f )
			.IgnoreGameObjectHierarchy( GameObject )
			.HitTriggers()
			.RunAll() ?? Array.Empty<SceneTraceResult>();

		var usables = hits
			.Select( x => x.GameObject.GetComponentInParent<IUseValid>() );

		return usables;
	}

	private void UpdateUse()
	{
		IsUsing = Input.Down( "Use" );

		var usables = GetUsables();
		Hovered = usables.FirstOrDefault();

		if ( Input.Pressed( "Use" ) )
		{
			using ( Rpc.FilterInclude( Connection.Host ) )
			{
				TryUse( AimRay );
			}
		}
	}

	[Rpc.Owner]
	private void TryUse( Ray ray )
	{
		var hits = GetUsables();
		var usable = hits.FirstOrDefault( x => x is not null );

		if ( usable.IsValid() && usable.CanUse( this ) is { } useResult )
		{
			if ( useResult.CanUse )
			{
				UpdateLastUsedObject( usable as Component );
				Scene.Dispatch( new PlayerUseEvent( usable ) );

				usable.OnUse( this );
			}
			else
			{
				if ( !string.IsNullOrEmpty( useResult.Reason ) )
				{
					using ( Rpc.FilterInclude( Network.Owner ) )
					{
						GameModeSingletonComponent.Instance.ShowToast( useResult.Reason, ToastType.Generic, 3 );
					}
				}
			}

		}
		else if ( Team == Team.Terrorist && GetZone<BombSiteComponent>() is not null )
		{
			Inventory.SwitchToSlot( EquipmentSlot.Special );
			return;
		}
	}

	[Rpc.Broadcast( NetFlags.HostOnly )]
	private void UpdateLastUsedObject( Component component )
	{
		if ( !component.IsValid() )
		{
			return;
		}

		LastUsedObject = component.GameObject;
	}
}

