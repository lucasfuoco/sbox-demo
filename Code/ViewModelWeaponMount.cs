using Sandbox.Attributes;

namespace Sandbox;

/// <summary>
/// Preset weapon mount points on the viewmodel arms skeleton.
/// </summary>
public enum ViewModelWeaponMount
{
	[Title( "Bone merge" )]
	BoneMerge,

	[Title( "Hand (right)" )]
	HandRight,

	[Title( "Hands (right tag)" )]
	HandsRight,

	[Title( "Hands (left)" )]
	HandsLeft,

	[Title( "Hip" )]
	Hip,

	[Title( "Carry" )]
	Carry,

	[Title( "Knife" )]
	Knife,

	[Title( "Custom bone" )]
	Custom
}

public static class ViewModelWeaponMountExtensions
{
	public static IEnumerable<string> GetMountBoneCandidates( this ViewModelWeaponMount mount, string customBone = null )
	{
		switch ( mount )
		{
			case ViewModelWeaponMount.HandRight:
				yield return "hand_r";
				break;

			case ViewModelWeaponMount.HandsRight:
				yield return "tag_weapon_right";
				break;

			case ViewModelWeaponMount.HandsLeft:
				yield return "tag_weapon_left";
				break;

			case ViewModelWeaponMount.Hip:
				yield return "tag_stowed_thigh";
				break;

			case ViewModelWeaponMount.Carry:
				yield return "tag_carry_attach";
				break;

			case ViewModelWeaponMount.Knife:
				yield return "tag_knife_attach2";
				break;

			case ViewModelWeaponMount.Custom:
				if ( !string.IsNullOrWhiteSpace( customBone ) )
					yield return customBone;
				break;
		}
	}

	public static string ToMountBone( this ViewModelWeaponMount mount, string customBone = null )
	{
		foreach ( var bone in mount.GetMountBoneCandidates( customBone ) )
			return bone;

		return null;
	}
}
