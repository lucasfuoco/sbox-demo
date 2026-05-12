using Sandbox.UI;
using Sandbox.GameEvents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Shows a countdown based on the duration of the current state.
/// </summary>
public sealed class ShowCountDownComponent : Component,
	IGameEventHandler<EnterStateEvent>,
	IGameEventHandler<LeaveStateEvent>
{
	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		GameModeSingletonComponent.Instance.ShowStateCountDownTimer();
	}

	void IGameEventHandler<LeaveStateEvent>.OnGameEvent( LeaveStateEvent eventArgs )
	{
		GameModeSingletonComponent.Instance.HideTimer();
	}
}

/// <summary>
/// Shows status text for the duration of the current state.
/// </summary>
public sealed class ShowStatusTextComponent : Component,
	IGameEventHandler<EnterStateEvent>,
	IGameEventHandler<LeaveStateEvent>
{
	/// <summary>
	/// If true, show this status text for all teams.
	/// </summary>
	[Property]
	public bool BothTeams { get; set; } = true;

	/// <summary>
	/// Which team to show the status text for.
	/// </summary>
	[Property, HideIf( nameof(BothTeams), true )]
	public Team Team { get; set; }

	/// <summary>
	/// Text to show for the duration of this state.
	/// </summary>
	[Property]
	public string StatusText { get; set; } = "Hello, World!";

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		if ( !string.IsNullOrEmpty( StatusText ) )
		{
			if ( BothTeams )
			{
				GameModeSingletonComponent.Instance.ShowStatusText( StatusText );
			}
			else
			{
				GameModeSingletonComponent.Instance.ShowStatusText( Team, StatusText );
			}
		}
	}

	void IGameEventHandler<LeaveStateEvent>.OnGameEvent( LeaveStateEvent eventArgs )
	{
		if ( !string.IsNullOrEmpty( StatusText ) )
		{
			if ( BothTeams )
			{
				GameModeSingletonComponent.Instance.HideStatusText();
			}
			else
			{
				GameModeSingletonComponent.Instance.HideStatusText( Team );
			}
		}
	}
}

/// <summary>
/// Shows a toast in the middle of the screen for the duration of this state.
/// </summary>
public sealed class ShowToastComponent : Component,
	IGameEventHandler<EnterStateEvent>,
	IGameEventHandler<LeaveStateEvent>
{
	[Property] public string Message { get; set; }
	[Property] public ToastType Type { get; set; }

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		if ( !string.IsNullOrEmpty( Message ) )
		{
			GameModeSingletonComponent.Instance.ShowToast( Message, Type, eventArgs.State.DefaultDuration );
		}
	}

	void IGameEventHandler<LeaveStateEvent>.OnGameEvent( LeaveStateEvent eventArgs )
	{
		if ( !string.IsNullOrEmpty( Message ) )
		{
			GameModeSingletonComponent.Instance.HideToast();
		}
	}
}

/// <summary>
/// Display a special icon in the game status display.
/// </summary>
public sealed class ShowStatusIconComponent : Component
{
	/// <summary>
	/// Path to the icon image to show.
	/// </summary>
	[Property]
	public string IconPath { get; set; } = "/ui/items/c4.png";
}
