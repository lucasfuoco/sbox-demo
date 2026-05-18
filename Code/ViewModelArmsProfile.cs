namespace Sandbox;

/// <summary>
/// Maps to a prefab child slot_{category}_{id} under the viewmodel arms.
/// </summary>
public class ViewModelArmsOptionDefinition
{
	[Property] public string Id { get; set; }
}

public class ViewModelArmsSlotDefinition
{
	[Property] public string Category { get; set; }
	[Property] public string DefaultOption { get; set; }
	[Property] public List<ViewModelArmsOptionDefinition> Options { get; set; } = new();

	public ViewModelArmsOptionDefinition FindOption( string optionId )
	{
		return Options.FirstOrDefault( o => o.Id.Equals( optionId, StringComparison.OrdinalIgnoreCase ) );
	}
}

/// <summary>
/// Sleeve and glove slot options. Prefab children: slot_sleeve_gorka_1, slot_glove_mechanix_black, etc.
/// </summary>
public class ViewModelArmsProfile
{
	[Property] public List<ViewModelArmsSlotDefinition> Slots { get; set; } = new();

	public ViewModelArmsSlotDefinition GetSlot( string category )
	{
		return Slots.FirstOrDefault( s => s.Category.Equals( category, StringComparison.OrdinalIgnoreCase ) );
	}

	public string GetDefaultOption( string category )
	{
		return GetSlot( category )?.DefaultOption ?? "none";
	}
}
