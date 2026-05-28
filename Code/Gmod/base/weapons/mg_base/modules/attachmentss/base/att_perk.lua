ATTACHMENT.Base = "att_base"
ATTACHMENT.Name = "Default"
ATTACHMENT.Category = "Perks"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    if (weapon.Bullet != nil) then
        weapon.Bullet.Ricochet = false
    end
    
    weapon.Zoom.MovementMultiplier = 1
    weapon.Zoom.BreathingMultiplier = 1
end