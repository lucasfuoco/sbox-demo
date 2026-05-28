AddCSLuaFile()

local task = {}
task.Name = "UnderbarrelOut"
task.Priority = 5

function task:CanBeSet(weapon)
    return weapon:GetAnimation("Underbarrel_Off")
        && weapon:HasFlag("UsingUnderbarrel")
end

function task:OnSet(weapon)
    weapon:PlayViewModelAnimation("Underbarrel_Off")
    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Underbarrel_Off"))
    weapon:RemoveFlag("UsingUnderbarrel")
end

function task:Think(weapon)
    return CurTime() > weapon:GetNextPrimaryFire()
end

SWEP:RegisterTask(task) 