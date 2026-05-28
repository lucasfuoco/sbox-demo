ATTACHMENT.Base = "att_grip"
ATTACHMENT.Name = "Default Underbarrel"
ATTACHMENT.Category = "Underbarrels"
ATTACHMENT.CategoryAliases = {"Grips"}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)

    local task = {}
    task.Name = "UnderbarrelPrimaryFire"
    task.Priority = 2
    
    function task:CanBeSet(wpn)
        return true
    end

    function task:ShouldContinueToFire(wpn)
        return wpn.Secondary.Automatic && wpn:GetOwner():KeyDown(IN_ATTACK)
    end

    function task:CanAttack(wpn)
        return wpn:Clip2() > 0
    end

    function task:OnSet(wpn)
        if (!self:CanAttack(wpn)) then
            return
        end

        local delay = 60 / wpn.Secondary.RPM
        local clip2 = wpn:Clip2()
    
        if (wpn.Secondary.Automatic) then
            while (math.max(wpn:GetNextPrimaryFire(), CurTime()) <= CurTime() + FrameTime()) do
                wpn:SetNextPrimaryFire(math.max(wpn:GetNextPrimaryFire(), CurTime()) + delay)
                wpn:SetClip2(wpn:Clip2() - 1)
    
                if (wpn:Clip2() <= 0) then
                    break
                end
            end
    
            if (clip2 - wpn:Clip2() == 0) then
                return
            end
        else
            wpn:SetClip2(wpn:Clip2() - 1)
            wpn:SetNextPrimaryFire(CurTime() + delay)
        end

        local bulletsFired = clip2 - weapon:Clip2()

        wpn:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, wpn.HoldTypes[wpn:GetCurrentHoldType()].Attack)
    
        --still needs translation, even if already specified as underbarrel anims
        local seqIndex = "Underbarrel_Fire"
    
        if (wpn:Clip2() <= 0 && wpn:GetAnimation("Underbarrel_Fire_Last") != nil) then
            seqIndex = "Underbarrel_Fire_Last"
        end

        wpn:PlayViewModelAnimation(seqIndex)
        wpn:AddFlag("UsingUnderbarrel") --in case we named the fire anims the same

        wpn:SetLastShootTime(CurTime())
        wpn:SetNextSecondaryFire(CurTime() + 0.2)

        wpn:HandleReverb(wpn.Secondary.Reverb)
        wpn:EmitSound(wpn.Secondary.Sound)
        
        --cone
        wpn:SetCone(math.min(wpn:GetCone() + wpn.Secondary.Cone.Increase, wpn:GetConeMax()))

        --bullets
        for b = 1, bulletsFired do
            wpn.lastHitEntity = NULL
    
            if (wpn.Secondary.Projectile == nil) then
                wpn:Bullets(wpn.Secondary.Bullet)
            else
                wpn:Projectiles(wpn.Secondary.Projectile)
            end
        end

        --recoil
        local punch = wpn:CalculateRecoil()
        wpn:GetOwner():ViewPunch(punch)

        if (wpn.Secondary.Recoil.Punch != nil) then
            if (IsFirstTimePredicted() || game.SinglePlayer()) then
                punch:Mul(wpn.Secondary.Recoil.Punch)
    
                local ang = wpn:GetOwner():EyeAngles()
                ang:Add(punch)
                ang.r = 0
    
                wpn:GetOwner():SetEyeAngles(ang)
            end
        end
        
        --shake
        if (CLIENT && IsFirstTimePredicted()) then
            wpn:ShakeCamera()
        elseif (SERVER && game.SinglePlayer()) then 
            wpn:CallOnClient("ShakeCamera") 
        end
    end

    function task:Think(wpn)
        if (self:ShouldContinueToFire(wpn)) then
            self:OnSet(wpn)
        end
    
        return CurTime() > wpn:GetNextPrimaryFire()
    end

    weapon:RegisterTask(task)
end