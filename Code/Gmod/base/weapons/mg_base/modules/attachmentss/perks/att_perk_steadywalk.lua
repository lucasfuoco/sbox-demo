ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Balanced Stance"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_adsmove.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Zoom.MovementMultiplier = (weapon.Zoom.MovementMultiplier || 1) * 0.5
end