namespace Sandbox.Components;

/// <summary>
/// One selectable arms option. Pair with <see cref="ViewModelArmsSlotComponent"/>.
/// <see cref="OptionId"/> must match a mesh child: slot_{category}_{optionId}.
/// </summary>
[Title( "Arms Option" ), Group( "Viewmodel" )]
public sealed class ViewModelArmsOptionComponent : Component, Component.ExecuteInEditor
{
	[Property] public string OptionId { get; set; }

	public ViewModelArmsOptionDefinition ToDefinition() =>
		new() { Id = OptionId };

	protected override void OnValidate()
	{
		if ( !Game.IsEditor || !string.IsNullOrWhiteSpace( OptionId ) )
			return;

		if ( GameObject.Name.StartsWith( "option_", StringComparison.OrdinalIgnoreCase ) )
		{
			OptionId = GameObject.Name["option_".Length..];
			return;
		}

		if ( GameObject.Name.StartsWith( "slot_", StringComparison.OrdinalIgnoreCase ) )
		{
			var parts = GameObject.Name.Split( '_' );
			if ( parts.Length >= 3 )
				OptionId = parts[^1];
		}
	}
}
