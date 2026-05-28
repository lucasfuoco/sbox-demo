ATTACHMENT.Base = "att_ammo"
ATTACHMENT.Name = "Smart Warheads"
ATTACHMENT.Category = "WARHEADS"
ATTACHMENT.Icon = Material("vgui/perkicons/warhead_icon")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Projectile.Speed = weapon.Projectile.Speed / 1.5
    weapon.TrackingInfo.PingTime = 0.2
    weapon.Projectile.TrackingFraction = weapon.Projectile.TrackingFraction * 1.5
end
