namespace Sandbox;

/// <summary>
/// Viewmodel sleeve rig family (MW western / eastern milsim).
/// </summary>
public enum ViewModelArmsFaction
{
	Western,
	Eastern
}

public static class ViewModelArmsFactionExtensions
{
	/// <summary>
	/// CT uses western rigs; T uses eastern (matches third-person team models).
	/// </summary>
	public static ViewModelArmsFaction GetViewModelArmsFaction( this Team team ) =>
		team switch
		{
			Team.CounterTerrorist => ViewModelArmsFaction.Western,
			Team.Terrorist => ViewModelArmsFaction.Eastern,
			_ => ViewModelArmsFaction.Eastern
		};
}
