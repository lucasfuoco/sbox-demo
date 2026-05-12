namespace Sandbox.UI.TextEntries;

internal class ChatBoxTextEntry : TextEntry
{
	public Action OnTabPressed { get; set; }

	public override void OnButtonTyped(ButtonEvent e)
	{
		e.StopPropagation = true;

		var button = e.Button;

		if (button == "tab")
		{
			Log.Info("Tab");
			OnTabPressed?.Invoke();
		}

		base.OnButtonTyped(e);
	}
}
