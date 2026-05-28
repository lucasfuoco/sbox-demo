ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Crowd Control"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_cc.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Explosive.BlastRadius = weapon.Explosive.BlastRadius * 1.25
end