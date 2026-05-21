namespace Sandbox;

/// <summary>
/// Timed side effect fired during a viewmodel animation state (replaces Lua event callbacks).
/// </summary>
public enum WeaponViewModelAnimationAction
{
	None,
	PlaySound,
	MuzzleFlash,
	ShellEject,
}
