AddCSLuaFile()

local task = {}
task.Name = "Lower"
task.Flag = "Lowered"
task.Priority = 8

function task:CanBeSet(weapon)
    return weapon:CanChangeSafety()
end

function task:OnSet(weapon)
    weapon:PlayViewModelAnimation("Sprint_In")
    weapon:EmitSound("ViewModel.Medium")
end 

function task:Think(weapon)
    --[[if (weapon:GetAimDelta() > 0) then
        weapon:PlayViewModelAnimation("Ads_In")
        return true
    end]]

    return false --lets wait for literally anything else to set task
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "Lowered")
end

SWEP:RegisterTask(task)