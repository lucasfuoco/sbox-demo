AddCSLuaFile()

local task = {}
task.Name = "AimMode"
task.Priority = 2
task.bCanAim = true
task.bCanBipod = true

function task:CanSwitch(weapon)
    if weapon:GetHybrid() && weapon:GetHybrid().OnAnimation then
        return true
    end

    return weapon:HasFlag("Aiming")
end

function task:CanBeSet(weapon)
	return self:CanSwitch(weapon)
        && weapon:CanChangeAimMode()
		&& weapon:GetHybrid()
        && !weapon:HasFlag("UsingUnderbarrel")
end

function task:OnSet(weapon)
    weapon:SetAimMode(weapon:GetAimMode() == 1 && 0 || 1)
    weapon:SetNextSecondaryFire(CurTime())
    
    if weapon:GetAimMode() == 0 then
        if weapon:GetHybrid().OnAnimation then
            weapon:PlayViewModelAnimation(weapon:GetHybrid().OnAnimation)
            weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength(weapon:GetHybrid().OnAnimation))
        else
            weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Ads_Out"))
        end
    else
        if weapon:GetHybrid().OffAnimation then
            weapon:PlayViewModelAnimation(weapon:GetHybrid().OffAnimation)
            weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength(weapon:GetHybrid().OffAnimation))
        else
            weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Ads_Out"))
        end
    end
end

function task:Think(weapon)
    local delta = (CurTime() - weapon:GetNextSecondaryFire()) / (weapon:GetNextPrimaryFire() - weapon:GetNextSecondaryFire())

    if (weapon:GetAimMode() > 0) then
        weapon:SetAimModeDelta(delta)
    else
        weapon:SetAimModeDelta(1 - delta)
    end

    return CurTime() > weapon:GetNextPrimaryFire()
end

function task:OnInterrupted(weapon)
    weapon:SetAimModeDelta(weapon:GetAimMode())
end

SWEP:RegisterTask(task)