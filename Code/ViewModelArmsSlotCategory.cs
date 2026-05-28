using Sandbox.Attributes;

namespace Sandbox;

/// <summary>
/// Viewmodel arms slot categories. Serialized id is lowercase for slot_{id}_* meshes.
/// </summary>
public enum ViewModelArmsSlotCategory
{
	[Title( "Arms" )]
	Arms,

	[Title( "Glove" )]
	Glove
}

public static class ViewModelArmsSlotCategoryExtensions
{
	public static string ToCategoryId( this ViewModelArmsSlotCategory category ) =>
		category.ToString().ToLowerInvariant();

	public static bool TryParseCategoryId( string categoryId, out ViewModelArmsSlotCategory category )
	{
		category = default;

		if ( string.IsNullOrWhiteSpace( categoryId ) )
			return false;

		foreach ( ViewModelArmsSlotCategory value in Enum.GetValues<ViewModelArmsSlotCategory>() )
		{
			if ( value.ToCategoryId().Equals( categoryId, StringComparison.OrdinalIgnoreCase ) )
			{
				category = value;
				return true;
			}
		}

		return false;
	}
}
