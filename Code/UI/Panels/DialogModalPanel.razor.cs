using Sandbox.UI.Panels;

namespace Sandbox.UI.Panels;

public partial class DialogModalPanel
{
	public static void Show( string text, string submitText = "OK", string cancelText = "Cancel", Action submitAction = null, Action cancelAction = null )
	{
		// Look for a HUD
		var screenPanel = Game.ActiveScene.GetAllComponents<DialogRootPanel>().FirstOrDefault();
		if ( !screenPanel.IsValid() )
			return;

		// Create a modal
		var pnl = screenPanel.
			Panel.AddChild<DialogModalPanel>();

		pnl.Text = text;


		//
		pnl.CancelText = cancelText;
		pnl.OnCancel = cancelAction;

		//
		pnl.OnSubmit = submitAction;
		pnl.SubmitText = submitText;
	}
}
