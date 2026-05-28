ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Diazepam"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_adsidle.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Zoom.IdleSway = weapon.Zoom.IdleSway * 0.5
end