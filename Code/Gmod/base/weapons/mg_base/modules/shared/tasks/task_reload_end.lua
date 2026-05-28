AddCSLuaFile()

local task = {}
task.Name = "ReloadEnd"
task.Priority = 4
task.bCanAim = true
task.bCanBipod = true

function task:CanBeSet(weapon)
    return weapon:HasFlag("Reloading") 
        && weapon:GetAnimation("Reload_End")
end

function task:OnSet(weapon)
    local seqIndex = weapon:ChooseReloadEndAnim()
    local curAnim = weapon:GetAnimation(seqIndex)
    weapon:PlayViewModelAnimation(seqIndex)
    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength(seqIndex))
end

function task:Think(weapon)
    if CurTime() > weapon:GetNextPrimaryFire() then
        if !weapon:HasFlag("Rechambered") then
            weapon:AddFlag("Rechambered")
            weapon:SetRoundsUntilRechamber(0)
        end

        return true
    end

    return false
end

SWEP:RegisterTask(task)