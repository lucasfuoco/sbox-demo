ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Short-stroke"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_rof.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    weapon.Primary.RPM = weapon.Primary.RPM + 150
    weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 1.25
    weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 1.25
end