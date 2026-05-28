ATTACHMENT.Base = "att_underbarrel_gl"
ATTACHMENT.Name = "GP-25"
ATTACHMENT.Model = Model("models/viper/mw/attachments/ubgl/attachment_vm_ub_gpapa25.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/underbarrels/icon_attachment_ub_gpapa25.vmt")

ATTACHMENT.AttachmentBodygroups = {
    ["handguard"] = 1
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    --this tells code to translate normal anims (left) to the underbarrel ones (right)
    --if no animation is found then the underbarrel is toggled
    weapon.Secondary.TranslateAnimations = {
        ["Holster"] = "Underbarrel_Holster",
        ["Draw"] = "Underbarrel_Draw",
        ["Melee"] = "Underbarrel_Melee",
        ["Melee_Hit"] = "Underbarrel_Melee_Hit",
        ["Inspect"] = "Underbarrel_Inspect",
        ["Inspect_Empty"] = "Underbarrel_Inspect",
        ["Underbarrel_Fire"] = "Underbarrel_Fire"
    }

    weapon.Secondary.Projectile = {
        Class = "mg_gpapa25_grenade",
        Speed = 1500
    }


end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter("grip_gl_offset")
end

