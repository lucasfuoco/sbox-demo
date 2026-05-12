namespace Sandbox;

/// <summary>
/// A respawnable object.
/// </summary>
public interface IRespawnable
{
	public void OnRespawn() { }
	public void OnKill( DamageInfo damageInfo ) { }
}