ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "50 Round Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_ar_mcharlie_xmags.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/icon_attachment_ar_mcharlie_xmags.vmt")

ATTACHMENT.BulletList = {
    [1] = {"j_bullet_01"},
    [2] = {"j_bullet_02"},
    [3] = {"j_bullet_03"},
    [4] = {"j_bullet_04"}
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 50
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.96
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.96
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 0.9
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.9
end 