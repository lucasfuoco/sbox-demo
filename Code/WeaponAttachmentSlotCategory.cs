using Sandbox.Attributes;

namespace Sandbox;

/// <summary>
/// Weapon attachment slot categories. Serialized id is lowercase (perk, mag, …) for viewmodel slot_{id}_* meshes.
/// </summary>
public enum WeaponAttachmentSlotCategory
{
	[Title( "Perk" )]
	Perk,

	[Title( "Stock" )]
	Stock,

	[Title( "Magazine" )]
	Mag,

	[Title( "Grip" )]
	Grip,

	[Title( "Muzzle" )]
	Muzzle,

	[Title( "Sight" )]
	Sight,

	[Title( "Barrel" )]
	Barrel,

	[Title( "Laser" )]
	Laser
}

public static class WeaponAttachmentSlotCategoryExtensions
{
	public static string ToCategoryId( this WeaponAttachmentSlotCategory category ) =>
		category.ToString().ToLowerInvariant();

	public static bool TryParseCategoryId( string categoryId, out WeaponAttachmentSlotCategory category )
	{
		category = default;

		if ( string.IsNullOrWhiteSpace( categoryId ) )
			return false;

		foreach ( WeaponAttachmentSlotCategory value in Enum.GetValues<WeaponAttachmentSlotCategory>() )
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
