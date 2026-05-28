AddCSLuaFile()

local task = {}
task.Name = "Raise"
task.Priority = 9

function task:CanBeSet(weapon)
    return weapon:HasFlag("Lowered")
end

function task:OnSet(weapon)
    weapon:PlayViewModelAnimation("Sprint_Out")
    weapon:EmitSound("ViewModel.Medium")
end 

function task:Think(weapon)
    return true
end

SWEP:RegisterTask(task)