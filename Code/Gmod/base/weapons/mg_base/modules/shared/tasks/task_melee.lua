AddCSLuaFile()
require("mw_input")

local task = {}
task.Name = "Melee"
task.Priority = 254
task.Flag = "Meleeing"

function task:CanBeSet(weapon)
    return weapon:GetAnimation("Melee") != nil
        && weapon:GetAnimation("Melee_Hit")
        && weapon:CanMelee()
end

function task:OnSet(weapon)
    weapon:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, weapon.HoldTypes[weapon:GetCurrentHoldType()].Melee)
    
    local meleeAnimation = weapon:GetAnimation("Melee")
    local meleeHitAnimation = weapon:GetAnimation("Melee_Hit")

    local size = meleeAnimation.Size
    local range = meleeAnimation.Range      
    local bHit = false

    weapon:GetOwner():FireBullets({
        Src = weapon:GetOwner():EyePos(),
        Dir = weapon:GetOwner():EyeAngles():Forward(),
        Distance = range,
        HullSize = size,
        Tracer = 0,
        Callback = function(attacker, btr, dmgInfo)
            dmgInfo:SetDamage(meleeHitAnimation.Damage)
            dmgInfo:SetInflictor(weapon)
            dmgInfo:SetAttacker(weapon:GetOwner())
            dmgInfo:SetDamagePosition(btr.HitPos)
            dmgInfo:SetDamageForce(weapon:GetOwner():EyeAngles():Forward() * (meleeHitAnimation.Damage * 100))
            dmgInfo:SetDamageType(DMG_CLUB + DMG_ALWAYSGIB)
            
            bHit = true
        end
    })

    if (bHit) then
        weapon:SetNextSecondaryFire(CurTime() + weapon:GetAnimLength("Melee_Hit", meleeHitAnimation.Length))
        weapon:PlayViewModelAnimation("Melee_Hit")
    else
        weapon:SetNextSecondaryFire(CurTime() + weapon:GetAnimLength("Melee", meleeAnimation.Length))
        weapon:PlayViewModelAnimation("Melee")
    end 

    weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength("Melee", meleeAnimation.Length))
end

function task:Think(weapon)
    weapon:SetCone(weapon:GetConeMax())

    if (CurTime() > weapon:GetNextSecondaryFire() && mw_input.IsBindPressed(weapon:GetOwner(), "melee")) then
        self:OnSet(weapon)
    end

    return CurTime() > weapon:GetNextPrimaryFire()
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "Meleeing")
end

SWEP:RegisterTask(task)