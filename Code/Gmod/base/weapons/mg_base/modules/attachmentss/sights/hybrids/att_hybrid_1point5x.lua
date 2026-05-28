ATTACHMENT.Base = "att_hybrid"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.99
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.99
    weapon.Zoom.ViewModelFovMultiplier = weapon.Zoom.ViewModelFovMultiplier * 0.65
    weapon.Zoom.FovMultiplier = 0.7
end