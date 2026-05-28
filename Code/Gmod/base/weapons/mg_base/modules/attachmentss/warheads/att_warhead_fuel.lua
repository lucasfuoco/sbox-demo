ATTACHMENT.Base = "att_ammo"
ATTACHMENT.Name = "High Fuel Warheads"
ATTACHMENT.Category = "WARHEADS"
ATTACHMENT.Icon = Material("vgui/perkicons/warhead_icon")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
ATTACHMENT.Bodygroups ={
    ["warhead"] = 2
}
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Explosive.BlastRadius = weapon.Explosive.BlastRadius * 0.85
    weapon.Projectile.Fuel = weapon.Projectile.Fuel * 1.5
    weapon.Projectile.Speed = weapon.Projectile.Speed * 1.2
    weapon.Projectile.Stability = weapon.Projectile.Stability * 2
end
