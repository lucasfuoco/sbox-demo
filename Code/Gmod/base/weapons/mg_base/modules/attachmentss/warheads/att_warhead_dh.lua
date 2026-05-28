ATTACHMENT.Base = "att_ammo"
ATTACHMENT.Name = "Impact Casings"
ATTACHMENT.Category = "WARHEADS"
ATTACHMENT.Icon = Material("vgui/perkicons/warhead_icon")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Explosive.BlastRadius = weapon.Explosive.BlastRadius * 0.7
    weapon.Explosive.ImpactBlastRatio = weapon.Explosive.ImpactBlastRatio * 0.8
end
