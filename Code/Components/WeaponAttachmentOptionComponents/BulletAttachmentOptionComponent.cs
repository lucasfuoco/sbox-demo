using Sandbox;
using Sandbox.Attributes;

namespace Sandbox.Components.WeaponAttachmentOptionComponents;

/// <summary>
/// Attachment option specialization for bullet-related attachment options.
/// </summary>
[Title( "Bullet Attachment Option" ), Group( "Weapon Components" )]
public class BulletAttachmentOptionComponent : WeaponAttachmentOptionComponent
{
	[Property, Group( "Bullets" ), Title( "Bullet Count" )]
	public int BulletCount { get; set; } = 1;

	[Property, Group( "Bullets" ), Title( "Mag Index" )]
	public int MagIndex { get; set; } = 0;

	[Property, Group( "Bullets" ), Title( "Bullet Renderer" )]
	public SkinnedModelRenderer BulletRenderer { get; set; }
}
