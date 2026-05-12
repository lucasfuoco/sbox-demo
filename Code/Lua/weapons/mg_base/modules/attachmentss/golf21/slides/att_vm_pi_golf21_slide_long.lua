ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "Singuard Arms Advantage"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_pi_golf21_slide_long.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/golf21/icon_attachment_pi_golf21_slide_long.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Firemodes[1].Name = "3rnd Burst"
    weapon.Firemodes[1].OnSet = function(weapon)
        weapon.Primary.RPM = 923
        weapon.Primary.BurstRounds = 3
        weapon.Primary.BurstDelay = 0.2
        return "Firemode_Semi"
    end
    
    weapon.Bullet.HeadshotMultiplier = weapon.Bullet.HeadshotMultiplier * 0.65
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.1
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.1
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.3

    weapon.Cone.Hip = weapon.Cone.Hip * 1.1
    if weapon.Cone.TacStance then
        weapon.Cone.TacStance = weapon.Cone.TacStance * 1.1
    end
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.9
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.9
end 