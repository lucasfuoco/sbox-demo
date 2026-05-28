AddCSLuaFile()

function SWEP:CanAim()
    if (self:GetCurrentTask() > 0 && !self.Tasks[self:GetCurrentTask()].bCanAim) then
        return false
    end

    return !self:HasFlag("UsingUnderbarrel")
end

function SWEP:AimLogic()
    local bAimFlag = self:HasFlag("Aiming")

    if (self:CanAim()) then
        if (self:GetOwner():GetInfoNum("mgbase_toggleaim", 0) >= 1) then
            if (self:GetOwner():KeyPressed(IN_ATTACK2)) then
                self:ToggleFlag("Aiming")
            end
        else
            if (self:GetOwner():KeyDown(IN_ATTACK2) || self.UseLauncherLogic && self:GetOwner():KeyDown(IN_ATTACK)) then
                self:AddFlag("Aiming")
                if self.UseLauncherLogic && self:GetAimDelta() == 1 && self:GetOwner():KeyDown(IN_ATTACK) then 
                    self:TrySetTask("PrimaryFire")
                end
            else
                self:RemoveFlag("Aiming")
            end
        end
    else
        self:RemoveFlag("Aiming")
    end

    if self:HasFlag("Aiming") then
        if (!bAimFlag && self:GetCurrentTask() == 0) then
            self:PlayViewModelAnimation("Ads_In")
        end

        local speed = 1 / self:GetAnimLength("Ads_In");
		self:SetAimDelta(math.min(self:GetAimDelta() + speed * FrameTime(), 1))
    else
        if (bAimFlag && self:GetCurrentTask() == 0) then
            self:PlayViewModelAnimation("Ads_Out")
        end

        local speed = 1 / self:GetAnimLength("Ads_Out");
        self:SetAimDelta(math.max(self:GetAimDelta() - speed * FrameTime(), 0))
    end

    --breathe
    self:BreathingModule()
    self:TrackingModule()
end

function SWEP:BreathingModule()
    local mul = 1

    if self:HasFlag("Aiming") && self:GetSight() != nil && self:GetSight().Optic != nil && self:GetAimModeDelta() <= self.m_hybridSwitchThreshold then
        if (self:GetOwner():KeyDown(IN_SPEED) && !self:GetHasRunOutOfBreath()) then
            mul = 0

            self:SetBreathingDelta(math.max(self:GetBreathingDelta() - FrameTime() * 0.3, 0))

            if (self:GetBreathingDelta() <= 0) then
                self:SetHasRunOutOfBreath(true)
            end
        end
    else
        self:SetBreathingDelta(math.min(self:GetBreathingDelta() + FrameTime() * 0.2, 1))
    end

    if (self:GetHasRunOutOfBreath()) then
        mul = mul + (5 * (1 - self:GetBreathingDelta()))

        self:SetBreathingDelta(math.min(self:GetBreathingDelta() + FrameTime() * 0.2, 1))

        if (self:GetBreathingDelta() >= 1) then
            self:SetHasRunOutOfBreath(false)
        end
    end

    local pitch = math.sin(CurTime() * 3) * math.cos(CurTime() * 1.5)
    local yaw = math.cos(CurTime() * 1.5) * math.sin(CurTime() * 0.75)

    local ang = Angle(pitch * 1, yaw * 1, 0)
    ang:Mul(self:GetAimDelta() * mul)

    self:SetBreathingAngle(ang)
end

function SWEP:CalcAngleDifference(AngA, AngB) 
    local difference = 0

    difference = difference + math.abs(math.AngleDifference(AngA.p, AngB.p))
    difference = difference + math.abs(math.AngleDifference(AngA.r, AngB.r))
    difference = difference + math.abs(math.AngleDifference(AngA.y, AngB.y))

    return difference
end

function SWEP:TrackingModule() 

    if !self.TrackingInfo then return end
    if CLIENT then return end

    if self:GetTrackedEntity() != NULL && !self:GetTrackedEntity():IsValid() then 
        self:StopTrackingEntity()
        self:StopPingingEntity()
    end

    if self:GetPingedEntity() != NULL && !self:GetPingedEntity():IsValid() then 
        self:StopTrackingEntity()
        self:StopPingingEntity()
    end

    local angleForgiveness = 3.5

    local dir
    if self:GetPingedEntity():IsValid() then
        dir = self:GetPingedEntity():WorldSpaceCenter() - self:GetOwner():GetShootPos()
        dir = dir:Angle() 
    end


    if self:GetAimDelta() <= 0.8 then 
        if self:GetTrackedEntity():IsValid() || self:GetPingedEntity():IsValid() then
            self:StopPingingEntity()
            self:StopTrackingEntity() 
        end
    else

        local tr = self:GetOwner():GetEyeTrace()

        if self:GetPingedEntity():IsValid() && self:CalcAngleDifference(self:GetOwner():EyeAngles(), dir) < angleForgiveness then 
            if !self:GetTrackedEntity():IsValid() then
                if CurTime() >= self.PingData.TrackTime then 
                    self:StartTrackingEntity(self:GetPingedEntity())
                else 
                    for k, v in pairs(self.PingData.Pings) do 
                        if !v.WasActivated && CurTime() >= v.Time then 
                            self:EmitSound(self.TrackingInfo.PingSound)
                            v.WasActivated = true
                        end
                    end 
                end

            end
        elseif self:CanTrackEntity(tr.Entity) then 
            if !self.PingData then 
                self:StartPingingEntity(tr.Entity)
            end
        elseif tr.HitWorld || !self:CanTrackEntity(tr.Entity) then 

            if self:GetPingedEntity():IsValid() then
                local dir = self:GetPingedEntity():WorldSpaceAABB() - self:GetOwner():WorldSpaceAABB()
                dir = dir:Angle()
                if self:CalcAngleDifference(self:GetOwner():EyeAngles(), dir) > angleForgiveness then 
                    self:StopPingingEntity()
                    self:StopTrackingEntity()
                end
            end

            if self.TrackingInfo.TrackWorldPositions && !self:GetPingedEntity() then
                self.TrackedPosition = tr.HitPos
                self:SetTrackedEntity(NULL) 
            end
        else 
            self:StopTrackingEntity()
        end 

    end
end

function SWEP:StartTrackingEntity(ent) 
    if !self:CanTrackEntity(ent) then return end
    self:SetTrackedEntity(ent)
    self:StopPingingEntity()
    self.TrackedEntity = ent
    self.TrackingSound = self:StartLoopingSound(self.TrackingInfo.Sound) --self.TrackingInfo.Sound
end

function SWEP:StopTrackingEntity() 
    self:SetTrackedEntity(NULL)
    self.TrackedEntity = NULL
    self:GetOwner():SendLua("LocalPlayer():GetActiveWeapon():SetTrackedEntity(nil)")
    if self.TrackingSound then
        self:StopLoopingSound(self.TrackingSound) 
    end
end

function SWEP:StartPingingEntity(ent) 
    if !self:CanTrackEntity(ent) then return end
    self:SetPingedEntity(ent)
    self.PingData = {
        TrackTime = CurTime() + self.TrackingInfo.PingTime * (self.TrackingInfo.PingCount + 1) - self.TrackingInfo.PingTime,
        Pings = {}
    }

    for i = 1, self.TrackingInfo.PingCount, 1 do 
        self.PingData.Pings[i] = {
            Time = (CurTime() + self.TrackingInfo.PingTime * i) - self.TrackingInfo.PingTime,
            WasActivated = false,
        }
    end
end

function SWEP:StopPingingEntity() 
    self:SetPingedEntity(nil)
    self:GetOwner():SendLua("LocalPlayer():GetActiveWeapon():SetPingedEntity(nil)")
    self.PingData = nil
end

function SWEP:GetPingedEntity() 
    return self:GetNWEntity("f_PingedEntity", nil)
end

function SWEP:SetPingedEntity(ent) 
    self:SetNWEntity("f_PingedEntity", ent)
end

function SWEP:GetTrackedEntity() 
    return self:GetNWEntity("f_TrackedEntity", nil)
end

function SWEP:SetTrackedEntity(ent) 
    self:SetNWEntity("f_TrackedEntity", ent)
end

function SWEP:CanTrackEntity(ent) 
    return ent:IsNPC() 
    || ent:IsNextBot() 
    || ent:IsVehicle() 
    || ent:IsPlayer()
    || ent.IS_DRONE --drones rewrite
    || ent.LVS --LVS
end

function SWEP:AdjustMouseSensitivity()
    local mul = GetConVar("mgbase_sensitivity_ads"):GetFloat()
    
    if self:GetTacStanceDelta() > 0.9 then
        mul = GetConVar("mgbase_sensitivity_tacstance"):GetFloat()
    elseif self:GetAimModeDelta() < 0.9 then
        mul = mul * self.Zoom.FovMultiplier
    end

	return Lerp(self:GetAimDelta(), 1, mul)
end