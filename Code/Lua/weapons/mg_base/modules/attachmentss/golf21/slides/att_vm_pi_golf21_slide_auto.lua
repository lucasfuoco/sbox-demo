ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "Singuard Arms Featherweight"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_pi_golf21_slide_auto.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/golf21/icon_attachment_pi_golf21_slide_auto.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Primary.RPM = 923
    weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 0.85
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 0.85
    weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 2
    weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 2
    weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 2
    weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 2

    weapon.Firemodes[1] = {
        Name = "Full Auto",
        OnSet = function(weapon)
            weapon.Primary.Automatic = true
            return "Firemode_Semi"
        end
    }
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon.Cone.Increase = weapon.Cone.Increase * 0.6
end