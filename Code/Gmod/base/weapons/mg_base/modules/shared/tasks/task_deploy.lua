AddCSLuaFile()

local task = {}
task.Name = "Deploy"
task.Flag = "Drawing"
task.Priority = 998
task.bCanAim = true

function task:CanBeSet(weapon)
    return true --always
end

function task:OnSet(weapon)
    local seqIndex = "Draw"
    
    if (weapon:HasFlag("PlayFirstDraw")) then
        seqIndex = "Equip"
    end
    
    if (weapon:GetOwner():GetInfoNum("mgbase_underbarrelswitch", 1) <= 0) then
        weapon:RemoveFlag("UsingUnderbarrel")
    end

    self.bCanAim = !weapon:HasFlag("PlayFirstDraw")

    weapon:PlayViewModelAnimation(seqIndex)
    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength(seqIndex))
    weapon:SetBurstRounds(0)
    weapon:SetSprayRounds(0)
    
    if (weapon:GetFlashlightAttachment() != nil) then
        local bFlashlightOn = weapon:GetOwner():FlashlightIsOn()

        if (SERVER) then
            weapon:GetOwner():Flashlight(false)
        end

        if (bFlashlightOn) then
            weapon:AddFlag("FlashlightOn") 
        else
            weapon:RemoveFlag("FlashlightOn")
        end
    end
    
    weapon:RemoveFlag("Aiming") --for toggle aim
    weapon:PlayerGesture(GESTURE_SLOT_CUSTOM, weapon.HoldTypes[weapon:GetCurrentHoldType()].Draw)
    
    --meme marine
    weapon:SetShouldHoldType(true)
end

function task:Think(weapon)
    if (CurTime() > weapon:GetNextPrimaryFire()) then
        weapon:RemoveFlag("Drawing")
        weapon:RemoveFlag("PlayFirstDraw")
        return true
    end

    return false
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "PlayFirstDraw")
    weapon:CustomNetworkVar("Flag", "Drawing")
end

function task:Initialize(weapon)
    if (weapon:GetAnimation("Equip") != nil && GetConVar("mgbase_sv_firstdraws"):GetInt() > 0) then
        weapon:AddFlag("PlayFirstDraw")
    end
end

SWEP:RegisterTask(task)