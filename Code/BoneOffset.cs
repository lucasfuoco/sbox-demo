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
/// Position uses MW/GMod bone axes: X = right, Y = forward, Z = up.
/// </summary>
public class BoneOffsetEntry
{
	[Property]
	public GameObject TargetBone { get; set; }

	[Property]
	public string BoneName { get; set; }

	[Property]
	public Vector3 PositionOffset { get; set; }

	[Property]
	public Angles AngleOffset { get; set; }

	[Property]
	public BoneOffsetMode Mode { get; set; } = BoneOffsetMode.Additive;

	[Property]
	public GameObject ReferenceBone { get; set; }
}
