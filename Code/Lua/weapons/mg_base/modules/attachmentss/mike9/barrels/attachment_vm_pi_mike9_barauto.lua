ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "Mk3 Burst Mod"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_pi_mike9_barauto.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike9/icon_attachment_pi_mike9_barauto.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Primary.RPM = 1200
    weapon.Primary.BurstRounds = 3
    weapon.Primary.BurstDelay = 0.184
    weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 2.5
    weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 2.5
    weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 2.5
    weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 2.5

    weapon.Firemodes[1] = {
        Name = "3rnd Burst",
        OnSet = function(weapon)
            return "Firemode_Semi"
        end
    }
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon.Cone.Increase = weapon.Cone.Increase * 0.5
end