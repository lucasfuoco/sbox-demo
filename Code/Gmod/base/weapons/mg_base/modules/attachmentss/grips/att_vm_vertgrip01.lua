ATTACHMENT.Base = "att_grip"
ATTACHMENT.Name = "Ranger Foregrip"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_vertgrip02_lod0.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/grips/icon_attachment_vertgrip02.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Recoil.Vertical[1] = self:ChangeRecoil(weapon.Recoil.Vertical[1], 0.95)
    weapon.Recoil.Vertical[2] = self:ChangeRecoil(weapon.Recoil.Vertical[2], 0.95)
    weapon.Zoom.IdleSway = weapon.Zoom.IdleSway * 0.9
    weapon.HoldType = "RifleWithVerticalGrip"
end