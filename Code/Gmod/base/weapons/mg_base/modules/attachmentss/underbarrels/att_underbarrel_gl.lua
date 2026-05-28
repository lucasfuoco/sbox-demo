ATTACHMENT.Base = "att_underbarrel"
ATTACHMENT.Name = "Grenade Launcher"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Secondary.Automatic = false
    weapon.Secondary.Ammo = "SMG1_Grenade"
    weapon.Secondary.ClipSize = 1
    weapon.Secondary.RPM = 100
    weapon.Secondary.Sound = Sound("MW.M203")

    weapon.Secondary.Projectile = {
        Class = "mg_40mm",
        Speed = 1500
    }

    weapon.Secondary.Cone = {
        Hip = 0,
        Increase = 0,
        Max = 0
    }

    weapon.Secondary.Crosshair = Material("hud_reticle_grenade_launcher") --128x128

    weapon.Secondary.Reverb = { 
        RoomScale = 50000,
        Sounds = {
            Outside = {
                Layer = Sound("Atmo_M203.Outside"),
                Reflection = Sound("Reflection_ARSUP.Outside")
            },
    
            Inside = { 
                Layer = Sound("Atmo_Mike203.Inside"),
                Reflection = Sound("Reflection_ARSUP.Inside")
            }
        }
    }

    weapon.Secondary.Recoil = {
        Shake = 3,
        Vertical = {4, 5},
        Horizontal = {0, 0},
        Seed = 203
    }

    --THIS IS HERE JUST AS AN EXAMPLE
    --this tells code to translate normal anims (left) to the underbarrel ones (right)
    --if no animation is found then the underbarrel is toggled
    --[[

    weapon.Secondary.TranslateAnimations = {
        ["Holster"] = "Underbarrel_Holster",
        ["Draw"] = "Underbarrel_Draw",
        ["Melee"] = "Underbarrel_Melee",
        ["Melee_Hit"] = "Underbarrel_Melee_Hit",
        ["Inspect"] = "Underbarrel_Inspect",
        ["Inspect_Empty"] = "Underbarrel_Inspect",
        ["Underbarrel_Fire"] = "Underbarrel_Fire"
    }

    ]]
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)

    local task = {}
    task.Name = "UnderbarrelReload"
    task.Priority = 4
    task.Flag = "Reloading"

    function task:CanBeSet(wpn)
        if (wpn:Ammo2() <= 0) then
            return false
        end
    
        if (wpn:Clip2() >= wpn:GetMaxClip2()) then
            return false
        end
    
        if (CurTime() < wpn:GetNextSecondaryFire()) then
            return false
        end
    
        return true
    end
    
    function task:OnSet(wpn)
        wpn:RemoveFlag("MagInserted")
        
        local seqIndex = "Underbarrel_Reload"
        local length = wpn:GetAnimLength(seqIndex)
        local magLength = wpn:GetAnimLength(seqIndex, wpn:GetAnimation(seqIndex).MagLength)
    
        wpn:SetNextPrimaryFire(CurTime() + length)
        wpn:SetNextSecondaryFire(CurTime() + magLength)
        wpn:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, wpn.HoldTypes[wpn:GetCurrentHoldType()].Reload)
        wpn:PlayViewModelAnimation(seqIndex)
        wpn:AddFlag("UsingUnderbarrel")
    end
    
    function task:Think(wpn) 
        if (CurTime() > wpn:GetNextSecondaryFire() && !wpn:HasFlag("MagInserted")) then
            local maxClip = wpn:GetMaxClip2()
            local ammoNeeded = math.min(maxClip - wpn:Clip2(), wpn:Ammo2())
            wpn:SetClip2(wpn:Clip2() + ammoNeeded)
            wpn:GetOwner():SetAmmo(wpn:Ammo2() - ammoNeeded, wpn:GetSecondaryAmmoType())
            wpn:AddFlag("MagInserted")
        end

        return CurTime() > wpn:GetNextPrimaryFire()
    end
    
    weapon:RegisterTask(task)
end