
namespace Sandbox.Components;

/// <summary>
/// Defines sleeve and glove slot options. Pair with <see cref="ViewModelArmsLoadoutComponent"/>.
/// </summary>
[Title( "Arms Profile" ), Group( "Viewmodel" )]
public abstract class ViewModelArmsProfileComponent : Component, Component.ExecuteInEditor
{
	public ViewModelArmsProfile Profile { get; private set; }

	protected override void OnAwake()
	{
		Profile = CreateProfile();
	}

	protected abstract ViewModelArmsProfile CreateProfile();

	protected static ViewModelArmsSlotDefinition Slot( string category, string defaultOption, params ViewModelArmsOptionDefinition[] options )
	{
		return new ViewModelArmsSlotDefinition
		{
			Category = category,
			DefaultOption = defaultOption,
			Options = options.ToList()
		};
	}

	protected static ViewModelArmsOptionDefinition Opt( string id )
	{
		return new ViewModelArmsOptionDefinition { Id = id };
	}
}
