AddCSLuaFile()

local task = {}
task.Name = "Holster"
task.Flag = "Holstering"
task.Priority = 999 --priority over deploy, this should be highest

function task:CanBeSet(weapon)
    return true --always
end

function task:OnSet(weapon)
    weapon:PlayViewModelAnimation("Holster")
    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Holster"))
    weapon:RemoveFlag("CanSwitch")
end

function task:Think(weapon)
    if (CurTime() > weapon:GetNextPrimaryFire() && IsValid(weapon:GetNextWeapon())) then
        weapon:AddFlag("CanSwitch") --for holster

        if (CLIENT && IsFirstTimePredicted()) then 
            input.SelectWeapon(weapon:GetNextWeapon()) 
        elseif (SERVER && game.SinglePlayer()) then
            --weapon:GetOwner():SelectWeapon(weapon:GetNextWeapon():GetClass())
            weapon:GetOwner():SendLua("input.SelectWeapon(Entity("..weapon:GetNextWeapon():EntIndex().."))")
        end
    end

    --always return false, holster should be last thing we do
    return false
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "CanSwitch")
    weapon:CustomNetworkVar("Flag", "Holstering")
    weapon:CustomNetworkVar("Entity", "NextWeapon")
end

SWEP:RegisterTask(task)