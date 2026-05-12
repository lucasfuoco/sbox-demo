ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "Mk1 Extended"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_pi_mike9_barlong.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike9/icon_attachment_pi_mike9_barlong.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.15
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.15
    weapon.Cone.Hip = weapon.Cone.Hip * 0.9
    if weapon.Cone.TacStance then
        weapon.Cone.TacStance = weapon.Cone.TacStance * 0.9
    end
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.85
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.85
end