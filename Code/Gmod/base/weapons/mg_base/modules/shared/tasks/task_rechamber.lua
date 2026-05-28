AddCSLuaFile()

local task = {}
task.Name = "Rechamber"
task.Priority = 2
task.bCanAim = true
task.bCanBipod = true

function task:CanBeSet(weapon)
    return !weapon:HasFlag("Rechambered")
        && weapon:Clip1() > 0
        && weapon:CanRechamber()
end

function task:OnSet(weapon)
    weapon:PlayViewModelAnimation("Rechamber")
    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Rechamber"))
end 

function task:Think(weapon)
    if CurTime() > weapon:GetNextPrimaryFire() - (weapon:GetAnimLength("Rechamber") * 0.5) then
        weapon:SetRoundsUntilRechamber(0)
        weapon:AddFlag("Rechambered")
    end

    return CurTime() > weapon:GetNextPrimaryFire()
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "Rechambered")
    weapon:CustomNetworkVar("Int", "RoundsUntilRechamber")
end

function task:Initialize(weapon)
    weapon:AddFlag("Rechambered")
    weapon:SetRoundsUntilRechamber(0)
end

SWEP:RegisterTask(task)