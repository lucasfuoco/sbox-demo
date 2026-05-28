AddCSLuaFile()
require("mw_utils")

--name, int
SWEP.NetworkedFlags = {}

--flag networking. using string literals as it's easier to add flags for custom functionality
--and lua takes care of them for us anyways
local function networkFlag(weapon, name)
    weapon.NetworkedFlags[name] = weapon.NetworkedFlags[name] || (2 ^ (table.Count(weapon.NetworkedFlags) % 31))
end

function SWEP:CustomNetworkVar(typ, name)
    if (typ == "Flag") then
        networkFlag(self, name)
        return
    end

    self:NetworkVar(typ, name)
end

--i've decided to not check if a flag name exists. if you're looking for a flag
--that doesn't exist i'd prefer if you checked your code when it errors
function SWEP:HasFlag(name)
    local flagValue = self.NetworkedFlags[name]
    if !flagValue then return end
    return bit.band(self:GetWeaponFlags(), flagValue) == flagValue
end

function SWEP:AddFlag(name)
    local flagValue = self.NetworkedFlags[name]
    self:SetWeaponFlags(bit.bor(self:GetWeaponFlags(), flagValue))
end

function SWEP:RemoveFlag(name)
    local flagValue = self.NetworkedFlags[name]
    self:SetWeaponFlags(bit.band(self:GetWeaponFlags(), bit.bnot(flagValue)))
end

function SWEP:ToggleFlag(name)
    if (self:HasFlag(name)) then
        self:RemoveFlag(name)
    else
        self:AddFlag(name)
    end
end

--TODO: reconsider a lot of these vars, some probably dont need to be
function SWEP:SetupDataTables()
    self:CustomNetworkVar("Float", "AimDelta")
    self:CustomNetworkVar("Float", "Cone")
    self:CustomNetworkVar("Float", "AimModeDelta")
    self:CustomNetworkVar("Float", "TacStanceDelta")
    self:CustomNetworkVar("Float", "BreathingDelta")
    self:CustomNetworkVar("Float", "TriggerDelta")
    

    self:CustomNetworkVar("Flag", "OnLadder")
    self:CustomNetworkVar("Flag", "FlashlightOn")
    self:CustomNetworkVar("Flag", "BipodDeployed")
    self:CustomNetworkVar("Flag", "Aiming")
    self:CustomNetworkVar("Flag", "HoldingTrigger")
    self:CustomNetworkVar("Flag", "AutoFire")
    
    self:CustomNetworkVar("Bool", "HasRunOutOfBreath")

    self:CustomNetworkVar("Entity", "ViewModel")
 
    self:CustomNetworkVar("Int", "SprayRounds")
    self:CustomNetworkVar("Int", "BurstRounds")
    self:CustomNetworkVar("Int", "PenetrationCount")
    self:CustomNetworkVar("Int", "AimMode")
    self:CustomNetworkVar("Flag", "TacStance")

    self:CustomNetworkVar("Angle", "BreathingAngle")

    --tasks
    self:CustomNetworkVar("Int", "CurrentTask")

    --tasks should use this to share same states ("reloading", "holstering", etc)
    --so outside code can just check for flags instead of looking inside tasks
    self:CustomNetworkVar("Int", "WeaponFlags")

    --let tasks also set their own dts
    for _, task in pairs(self.Tasks) do
        if (task.SetupDataTables != nil) then
            task:SetupDataTables(self)
        end
    end

    --input
    self:CustomNetworkVar("Int", "Buttons")
    self:CustomNetworkVar("Float", "ButtonPressTime")
end