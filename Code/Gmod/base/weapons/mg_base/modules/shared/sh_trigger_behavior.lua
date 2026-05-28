AddCSLuaFile()

function SWEP:LauncherTriggerLogic()
    if (CLIENT && game.SinglePlayer()) then
        return
    end
    
    if self.Trigger then
        if (self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.ReleasedSound != nil) then
                self:EmitSound(self.Trigger.ReleasedSound)
            end
        end

        self:RemoveFlag("HoldingTrigger")

        if (CurTime() > self:GetNextPrimaryFire() && self:HasFlag("Rechambered")) then
            self:SetTriggerDelta(0)
        end
        
        return
    end

    local bDown = self:GetOwner():KeyDown(IN_ATTACK)

    if (bDown && CurTime() >= self:GetNextPrimaryFire()) then
        if (!self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.PressedSound != nil) then
                self:EmitSound(self.Trigger.PressedSound)
            end
            
            --self:PlayViewModelAnimation(self.Trigger.PressedAnimation || "Land")
        end
        
        self:AddFlag("HoldingTrigger")
        self:RemoveFlag("Lowered")
    elseif (!bDown && self:CanReleaseTrigger()) then
        if (self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.ReleasedSound != nil) then
                self:EmitSound(self.Trigger.ReleasedSound)
            end

            if (self.Trigger.ReleasedAnimation != nil && self:CanPlayTriggerOut()) then
                self:PlayViewModelAnimation(self.Trigger.ReleasedAnimation)
            end
        end

        self:RemoveFlag("HoldingTrigger")
    end

    if (self:HasFlag("HoldingTrigger")) then
        if (self:GetTriggerDelta() == INVALID_TRIGGER_VALUE) then
            return
        end

        self:SetTriggerDelta(math.min(self:GetTriggerDelta() + (FrameTime() / self.Trigger.Time), 1))
        if self:GetTriggerDelta() >= 1 && (!self.Trigger.ClickType || self.Trigger.ClickType <= 1) then
            self:PrimaryAttack()

            --if (!self.Primary.Automatic && (self:GetBurstRounds() >= self.Primary.BurstRounds || self:Clip1() <= 0)) then
                --self:SetTriggerDelta(INVALID_TRIGGER_VALUE)
            --end
        end 
    else
        self:SetTriggerDelta(0)
        self:SetBurstRounds(0)
        if self.Trigger.ClickType && self.Trigger.ClickType > 0 then
            self:PrimaryAttack()
        end
    end
end

function SWEP:TriggerOn()
    if self:HasFlag("HoldingTrigger") || self:GetCurrentTask() > 0 || CurTime() < self:GetNextPrimaryFire() then return end
    self:AddFlag("HoldingTrigger")

    if self.Trigger then
        if self.Trigger.PressedSound then
            self:EmitSound(self.Trigger.PressedSound)
        end

        if self:IsEmpty() then
            self:PlayViewModelAnimation(self.Trigger.EmptyAnimation && self.Trigger.EmptyAnimation || "Land")
        elseif self.Trigger.PressedAnimation then
            self:PlayViewModelAnimation(self.Trigger.PressedAnimation)
        end
    end
end

function SWEP:TriggerOff()
    if !self:HasFlag("HoldingTrigger") then return end
    self:RemoveFlag("HoldingTrigger")
    
    if self.Trigger then
        if self.Trigger.ReleasedSound then
            self:EmitSound(self.Trigger.ReleasedSound)
        end

        if self.Trigger.ReleasedAnimation then
            self:PlayViewModelAnimation(self.Trigger.ReleasedAnimation)
        end

        if self:GetTriggerDelta() >= 1 && (self.Trigger.ClickType && self.Trigger.ClickType > 0) then
            self:TrySetTask("PrimaryFire")
        end
    end

    self:SetTriggerDelta(0)
end

function SWEP:TriggerLogic()
    if self:HasFlag("AutoFire") then
        self:TriggerOn()
    end

    local currentTask = self.Tasks[self:GetCurrentTask()]
    if self:HasFlag("HoldingTrigger") && currentTask && currentTask.Name != "PrimaryFire" then
        self:TriggerOff()
    end

    if !self:HasFlag("HoldingTrigger") || !self:HasFlag("AutoFire") then return end

    if self.Trigger then
        self:SetTriggerDelta(math.min(self:GetTriggerDelta() + (FrameTime() / self.Trigger.Time), 1))

        if self:GetTriggerDelta() >= 1 && (!self.Trigger.ClickType || self.Trigger.ClickType < 2) then
            self:TrySetTask("PrimaryFire")
        end
    else
        self:SetTriggerDelta(1)
        self:TrySetTask("PrimaryFire")
    end
end