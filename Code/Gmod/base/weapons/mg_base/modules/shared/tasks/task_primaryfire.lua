AddCSLuaFile()

local task = {}
task.Name = "PrimaryFire"
task.Priority = 3
task.bCanAim = true
task.bCanBipod = true

function task:CanBeSet(weapon)
    if !weapon:GetAnimation("Rechamber") && !weapon:HasFlag("Rechambered") && !weapon:IsEmpty() then
        weapon:AddFlag("Rechambered")
    end

    return self:CanContinueFire(weapon)
end

function task:GetBurstRounds(weapon)
    return weapon.Primary.BurstRounds || 1
end

function task:GetBurstDelay(weapon)
    return weapon.Primary.BurstDelay || weapon:GetPrimaryDelay()
end

function task:ShouldAutoFire(weapon)
    return weapon.Primary.Automatic || self:GetBurstRounds(weapon) > 1
end

function task:ShouldContinueToFire(weapon)
    return (self:GetBurstRounds(weapon) > 1 && weapon:GetBurstRounds() > 0)
        || (weapon.Primary.Automatic && weapon:GetOwner():KeyDown(IN_ATTACK))
        || (weapon.UseLauncherLogic)
end

function task:HasReachedMaxBurstRounds(weapon)
    return weapon:GetBurstRounds() >= self:GetBurstRounds(weapon) || weapon:IsEmpty()
end

function task:CanContinueFire(weapon)
    return !weapon:IsEmpty()
    && CurTime() > weapon:GetNextPrimaryFire()
    && weapon:HasFlag("Rechambered")
    && (!weapon.UseLauncherLogic || weapon:GetAimDelta() > 0.95)
end

function task:IsBottomless(weapon)
    return weapon:GetMaxClip1() < 0
end

function task:OnSet(weapon)
    local delay = weapon:GetPrimaryDelay()
    local clip1 = weapon:Clip1()
    local ammo1 = weapon:Ammo1()

    if self:ShouldAutoFire(weapon) then
		while math.max(weapon:GetNextPrimaryFire(), CurTime()) <= CurTime() + FrameTime() do
			weapon:SetNextPrimaryFire(math.max(weapon:GetNextPrimaryFire(), CurTime()) + delay)
			
            if self:IsBottomless(weapon) then
                weapon:GetOwner():SetAmmo(weapon:Ammo1() - 1, weapon:GetPrimaryAmmoType())
            else
                weapon:SetClip1(weapon:Clip1() - 1)
            end

            if weapon:IsEmpty() then
                break
            end

            if self:GetBurstRounds(weapon) > 1 && (self:IsBottomless(weapon) && ammo1 - weapon:Ammo1() >= self:GetBurstRounds(weapon) || clip1 - weapon:Clip1() >= self:GetBurstRounds(weapon)) then
                break
            end
        end
	else
		if self:IsBottomless(weapon) then
            weapon:GetOwner():SetAmmo(weapon:Ammo1() - 1, weapon:GetPrimaryAmmoType())
        else
            weapon:SetClip1(weapon:Clip1() - 1)
        end

		weapon:SetNextPrimaryFire(CurTime() + delay)
    end

    if !weapon.Primary.Automatic then
        weapon:RemoveFlag("AutoFire")
    end

    local bulletsFired = self:IsBottomless(weapon) && ammo1 - weapon:Ammo1() || clip1 - weapon:Clip1()
    local seqIndex = "Fire"

    if weapon:GetAnimation("Fire_Last") && weapon:IsEmpty() then
        seqIndex = "Fire_Last"
    end

    weapon:PlayViewModelAnimation(seqIndex)
    weapon:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, weapon.HoldTypes[weapon:GetCurrentHoldType()].Attack)

    weapon:SetSprayRounds(weapon:GetSprayRounds() + bulletsFired)
    weapon:SetRoundsUntilRechamber(weapon:GetRoundsUntilRechamber() + bulletsFired)

    local rur = weapon.RoundsUntilRechamber || 1
    if (weapon:GetAnimation("Rechamber") && rur >= 0 && weapon:GetRoundsUntilRechamber() >= rur) || (!self:IsBottomless(weapon) && weapon:Clip1() <= 0) then
        weapon:RemoveFlag("Rechambered")
    end

    if self:GetBurstRounds(weapon) > 1 then
        weapon:SetBurstRounds(weapon:GetBurstRounds() + bulletsFired)

        if self:HasReachedMaxBurstRounds(weapon) then
            weapon:SetNextPrimaryFire(CurTime() + self:GetBurstDelay(weapon))
            weapon:SetBurstRounds(0)
        end
    else
        weapon:SetBurstRounds(0)
    end
    
    weapon:SetLastShootTime(CurTime())
    weapon:SetNextSecondaryFire(CurTime() + 0.2)

    weapon:HandleReverb()
    weapon:EmitSound((weapon:GetAimDelta() > 0.5 && weapon.Primary.AdsSound != nil) && weapon.Primary.AdsSound || weapon.Primary.Sound)
    
    if weapon.Primary.TrailingSound then
        weapon:EmitSound(weapon.Primary.TrailingSound)
    end
    
    for b = 1, bulletsFired do
        weapon.lastHitEntity = NULL

        if weapon.Projectile then
            weapon:Projectiles()
        else
            weapon:Bullets()
        end
    end

    local punch = weapon:CalculateRecoil()
    weapon:GetOwner():ViewPunch(punch)

    if weapon.Recoil.Punch then
        if IsFirstTimePredicted() || game.SinglePlayer() then
            punch:Mul(weapon.Recoil.Punch)

            local ang = weapon:GetOwner():EyeAngles()
            ang:Add(punch)
            ang.r = 0

            weapon:GetOwner():SetEyeAngles(ang)
        end
    end

    local coneMult = weapon:HasFlag("TacStance") && (weapon.Cone.TacStanceMultiplier || 1) || weapon.Cone.AdsMultiplier
    weapon:SetCone(math.min(weapon:GetCone() + weapon.Cone.Increase * Lerp(weapon:GetAimDelta(), 10, 10 * coneMult), weapon:GetConeMax()))

    if CLIENT && IsFirstTimePredicted() then
        weapon:ShakeCamera()
        weapon:ShakeViewModel()
    elseif SERVER && game.SinglePlayer() then 
        weapon:CallOnClient("ShakeCamera") 
        weapon:CallOnClient("ShakeViewModel")
    end
end

function task:OnInterrupted(weapon, name)
    if name != task.Name then
        weapon:SetSprayRounds(0)
        weapon:SetBurstRounds(0)
    end
end

function task:Think(weapon)
    if self:ShouldContinueToFire(weapon) && self:CanContinueFire(weapon) then
        weapon:TrySetTask("PrimaryFire")
    end

    if CurTime() > weapon:GetNextPrimaryFire() then
        weapon:SetSprayRounds(0)
        weapon:SetBurstRounds(0)
        return true
    end

    return false
end

SWEP:RegisterTask(task)