ATTACHMENT.Base = "att_optic_2x"
ATTACHMENT.Name = "Solozero K498 2.0x Integral"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_lm_slima_acog.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/optics/icon_attachment_lm_slima_acog.vmt")
ATTACHMENT.Bodygroups ={
    ["tag_sight"] = 2,
    ["tag_rail"] = 1,
    ["sight"] = 2
}
ATTACHMENT.AttachmentBodygroups ={
    ["tag_sight"] = 2,
    ["tag_rail"] = 1,
    ["sight"] = 2
}
ATTACHMENT.Optic = {
    LensHideMaterial = Material("viper/MW/attachments/weapon_vm_lm_slima_sightmagnifier_lens.vmt"),
    HideModel = Model("models/viper/mw/attachments/attachment_vm_lm_slima_acog_hide.mdl"),
    LensBodygroup = "lens",
    FOV = 7, 
    ParallaxSize = 600, --a value of zero means 1:1 size with the end of the optic
    Thermal = false
}
ATTACHMENT.Reticle = {
    Material = Material("viper/shared/reticles/bravo4_ret.vmt"),
    Size = 1200,
    Color = Color(255, 255, 255, 255),
    Attachment = "reticle"
}