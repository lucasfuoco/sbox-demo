ATTACHMENT.Base = "att_ammo"
ATTACHMENT.Name = "High Explosive Warheads"
ATTACHMENT.Category = "WARHEADS"
ATTACHMENT.Icon = Material("vgui/perkicons/warhead_icon")
ATTACHMENT.Bodygroups ={
    ["warhead"] = 3
}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Explosive.BlastRadius = weapon.Explosive.BlastRadius * 1.2
    weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] / 1.2
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] / 1.2
end
