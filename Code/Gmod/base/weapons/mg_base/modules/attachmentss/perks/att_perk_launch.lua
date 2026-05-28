ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Hard Launch"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_launch.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Projectile.Speed = weapon.Projectile.Speed * 1.5
end