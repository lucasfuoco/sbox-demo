ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "FMJ"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_fmj.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    if (weapon.Bullet.Penetration != nil) then
        weapon.Bullet.Penetration.MaxCount = weapon.Bullet.Penetration.MaxCount + 1
        weapon.Bullet.Penetration.Thickness = weapon.Bullet.Penetration.Thickness * 1.5
    end
end