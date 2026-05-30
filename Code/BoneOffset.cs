using Sandbox.Attributes;

namespace Sandbox;

/// <summary>
/// How a bone offset is combined with the animated bone transform.
/// </summary>
public enum BoneOffsetMode
{
	[Title( "Add to animation" )]
	Additive,

	[Title( "Replace animation" )]
	Replace
}

/// <summary>
/// Local offset for a single skeleton bone.
/// Position uses bone-local axes from the target bone: X = right, Y = forward, Z = up.
/// Values are combined with the animated bone transform ref captured before apply.
/// </summary>
public class BoneOffsetEntry
{
	[Property]
	public GameObject TargetBone { get; set; }

	[Property]
	public Vector3 PositionOffset { get; set; }

	[Property]
	public Angles AngleOffset { get; set; }

	[Property]
	public BoneOffsetMode Mode { get; set; } = BoneOffsetMode.Additive;
}
