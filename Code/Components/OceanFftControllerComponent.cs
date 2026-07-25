using Sandbox.GameObjectSystems;
using Sandbox.Ocean;

namespace Sandbox.Components;

/// <summary>
/// Inspector controls on the Ocean object for the GodotOceanWaves FFT system.
/// </summary>
[Title( "Ocean FFT Controller" ), Category( "Water" ), Icon( "waves" )]
public sealed class OceanFftControllerComponent : Component, Component.ExecuteInEditor
{
	[Property, Title( "Enable FFT Waves" )]
	public bool EnableFftWaves
	{
		get => OceanFftManager.Current?.EnableOceanFft ?? true;
		set
		{
			if ( OceanFftManager.Current is not null )
				OceanFftManager.Current.EnableOceanFft = value;
		}
	}

	[Property, Title( "Enable Sea Spray" )]
	public bool EnableSeaSpray
	{
		get => OceanFftManager.Current?.EnableSeaSpray ?? true;
		set
		{
			if ( OceanFftManager.Current is not null )
				OceanFftManager.Current.EnableSeaSpray = value;
		}
	}

	[Property, Title( "FFT Active (runtime)" ), ReadOnly]
	public bool FftActive => OceanFftManager.Current?.IsOceanFftActive ?? false;

	[Property, Title( "Profile" ), ReadOnly]
	public OceanFftDefinition Profile => OceanFftManager.Current?.ResolveProfile();
}
