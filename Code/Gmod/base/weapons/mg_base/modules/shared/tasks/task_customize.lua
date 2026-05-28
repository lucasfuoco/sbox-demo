AddCSLuaFile()

local task = {}
task.Name = "Customize"
task.Priority = 255
task.Flag = "Customizing"

function task:CanBeSet(weapon)
    return weapon.Customization != nil
        && GetConVar("mgbase_sv_customization"):GetBool()
        && weapon:CanCustomize()
end

function task:OnSet(weapon)
    weapon:RemoveFlag("StoppedInspectAnimation")
    weapon:RemoveFlag("UsingUnderbarrel")

    local inspIndex = (weapon:Clip1() <= 0 && weapon:GetAnimation("Inspect_Empty") != nil) && "Inspect_Empty" || "Inspect"
    weapon:PlayViewModelAnimation(inspIndex)

    if (game.SinglePlayer()) then
        weapon:CallOnClient("CustomizationMenu")
    else
        if (CLIENT && IsFirstTimePredicted()) then
            weapon:CustomizationMenu()
        end
    end
end 

function task:Think(weapon)
    return !weapon:HasFlag("Customizing")
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "Customizing")
end

SWEP:RegisterTask(task)