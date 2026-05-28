AddCSLuaFile()

local task = {}
task.Name = "Firemode"
task.Priority = 2
task.bCanAim = true
task.bCanBipod = true

function task:CanBeSet(weapon)
    local index = weapon:GetFiremode()
    return weapon.Firemodes != nil
        && #weapon.Firemodes > 1
        && (weapon.Firemodes[index + 1] || index != 1)
        && !weapon:HasFlag("UsingUnderbarrel")
end

function task:OnSet(weapon)
    local index = weapon:GetFiremode()

    if (weapon.Firemodes[index + 1]) then
        index = index + 1
    else
        index = 1
    end

    if (index != weapon:GetFiremode() && weapon.Firemodes[weapon:GetFiremode()].OffSet) then 
        weapon.Firemodes[weapon:GetFiremode()].OffSet(weapon)
    end

    local seqIndex = weapon:ApplyFiremode(index)
    weapon:PlayViewModelAnimation(seqIndex) 
    weapon:SetNextPrimaryFire(CurTime() + (weapon:GetAnimation(seqIndex).Length || 0.5))
end 

function task:Think(weapon)
    return CurTime() > weapon:GetNextPrimaryFire()
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Int", "Firemode")
end

SWEP:RegisterTask(task)