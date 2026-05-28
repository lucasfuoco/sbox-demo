ATTACHMENT.Base = "att_ammo"
ATTACHMENT.Name = "Mobile Air-Strike"
ATTACHMENT.Category = "WARHEADS"
ATTACHMENT.Icon = Material("vgui/perkicons/warhead_icon")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Projectile.Class = "mg_javelin_airstrike_warhead"
end
