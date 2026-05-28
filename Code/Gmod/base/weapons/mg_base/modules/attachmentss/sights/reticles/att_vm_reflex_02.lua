ATTACHMENT.Base = "att_sight_1x"
ATTACHMENT.Name = "LP Collimator"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_reflex_02.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/reticles/dyn_icon_attachment_vm_reflex_02.vmt")
ATTACHMENT.Reticle = {
    Material = Material("viper/mw/reticles/reticle_reflex_default2.vmt"),
    Size = 950,
    Color = Color(255, 255, 255, 255),
    Attachment = "reticle"
}
ATTACHMENT.Bodygroups ={
    ["tag_sight"] = 1,
    ["tag_rail"] = 1,
    ["sight"] = 1
}
ATTACHMENT.AttachmentBodygroups ={
    ["tag_sight"] = 1,
    ["tag_rail"] = 1,
    ["sight"] = 1
}