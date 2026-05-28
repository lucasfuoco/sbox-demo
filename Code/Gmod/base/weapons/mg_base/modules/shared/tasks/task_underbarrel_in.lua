AddCSLuaFile()

local task = {}
task.Name = "UnderbarrelIn"
task.Priority = 5

function task:CanBeSet(weapon)
    return weapon.Secondary != nil
        && weapon.Secondary.ClipSize != nil && weapon.Secondary.ClipSize > 0
        && weapon.Secondary.Ammo != nil
        && weapon:GetAnimation("Underbarrel_On")
        && !weapon:HasFlag("UsingUnderbarrel")
end

function task:OnSet(weapon)
    weapon:PlayViewModelAnimation("Underbarrel_On")
    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Underbarrel_On"))
end

function task:Think(weapon)
    if (CurTime() > weapon:GetNextPrimaryFire()) then
        weapon:AddFlag("UsingUnderbarrel")
        return true
    end

    return false
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "UsingUnderbarrel")
end

SWEP:RegisterTask(task) 