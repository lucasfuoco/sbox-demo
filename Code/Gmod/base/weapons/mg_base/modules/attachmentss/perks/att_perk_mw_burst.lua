ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Burst"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_hipaim.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Firemodes[1].Name = "3Rnd Burst"
    weapon.Firemodes[1].OnSet = function(weapon)
        weapon.Primary.Automatic = false
        weapon.Primary.BurstRounds = 3
        weapon.Primary.BurstDelay = 0.2
        return "Firemode_Semi"
    end
end