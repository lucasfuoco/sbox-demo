AddCSLuaFile()

local task = {}
task.Name = "Inspect"
task.Flag = "Inspecting"
task.Priority = 1

function task:CanBeSet(weapon)
    return true
end

function task:OnSet(weapon)
    local inspIndex = (weapon:Clip1() <= 0 && weapon:GetAnimation("Inspect_Empty") != nil) && "Inspect_Empty" || "Inspect"
    weapon:PlayViewModelAnimation(inspIndex)
    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength(inspIndex))
    weapon:RemoveFlag("StoppedInspectAnimation")
end

function task:OnInterrupted(weapon)
    weapon:RemoveFlag("StoppedInspectAnimation")
end

function task:Think(weapon)
    if (weapon:HasFlag("StoppedInspectAnimation")) then
        weapon:SetNextPrimaryFire(weapon:GetNextPrimaryFire() + FrameTime())
    end

    return CurTime() > weapon:GetNextPrimaryFire()
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "Inspecting")
    weapon:CustomNetworkVar("Flag", "StoppedInspectAnimation")
end

SWEP:RegisterTask(task)