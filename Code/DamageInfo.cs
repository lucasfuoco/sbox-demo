using Sandbox.GameEvents;

namespace Sandbox;

/// <summary>
/// Event dispatched when a <see cref="HealthComponent"/> takes damage.
/// </summary>
/// <param name="Attacker">Who was the attacker?</param>
/// <param name="Damage">How much damage?</param>
/// <param name="Inflictor">What caused this damage? Can be a weapon, grenade, etc.</param>
/// <param name="Position">The point of the damage. Normally where you were hit.</param>
/// <param name="Force">The force of the damage.</param>
/// <param name="Hitbox">What hitbox did we hit?</param>
/// <param name="Flags">Extra data that we can pass around. Like if it's a blind-shot, mid-air shot, through smoke shot, etc.</param>
/// <param name="ArmorDamage">How much armor damage?</param>
/// <param name="RemoveHelmet">Did this damage remove the victim's helmet?</param>
public record DamageInfo( Component Attacker, float Damage, Component Inflictor = null,
	Vector3 Position = default, Vector3 Force = default,
	HitboxTags Hitbox = default, DamageFlags Flags = DamageFlags.None,
	float ArmorDamage = 0f, bool RemoveHelmet = false )
{
	/// <summary>
	/// Who took damage?
	/// </summary>
	public Component Victim { get; init; }

	/// <inheritdoc cref="DamageFlags.Armor"/>
	public bool HasArmor => Flags.HasFlag( DamageFlags.Armor );

	/// <inheritdoc cref="DamageFlags.Helmet"/>
	public bool HasHelmet => Flags.HasFlag( DamageFlags.Helmet );

	/// <inheritdoc cref="DamageFlags.Helmet"/>
	public bool WasMelee => Flags.HasFlag( DamageFlags.Melee );

	/// <inheritdoc cref="DamageFlags.Explosion"/>
	public bool WasExplosion => Flags.HasFlag( DamageFlags.Explosion );

	/// <inheritdoc cref="DamageFlags.FallDamage"/>
	public bool WasFallDamage => Flags.HasFlag( DamageFlags.FallDamage );

	/// <summary>
	/// How long since this damage info event happened?
	/// </summary>
	public RealTimeSince TimeSinceEvent { get; init; } = 0;

	public override string ToString()
	{
		return $"\"{Attacker}\" - \"{Victim}\" with \"{Inflictor}\" ({Damage} damage)";
	}
}