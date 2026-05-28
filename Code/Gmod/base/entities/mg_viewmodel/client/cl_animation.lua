require("mw_math")

local reloadDeltaLerp = 1

ENT.m_AimDeltaLerp = 0
ENT.m_LocomotionDeltaLerp = 0
ENT.m_CustomizationRateLerp = 0
ENT.m_SlowWalkMin = 0
ENT.m_bMoveStopped = true
ENT.m_bMoveStarted = false
ENT.m_bOnGround = true
ENT.m_LeftHandGripPoseParameter = nil
ENT.m_LeftHandGripTarget =  0
ENT.m_LeftHandGripLerp = 0
ENT.m_RightHandGripPoseParameter = nil
ENT.m_RightHandGripTarget = 0
ENT.m_RightHandGripLerp = 0
ENT.m_MiscGripPoseParameter = nil
ENT.m_MiscGripTarget =  0
ENT.m_MiscGripLerp = 0
ENT.m_LastSprayRounds = 0
ENT.m_InspectSpeed = 1
ENT.m_UpdateDelta = 0

local function playIdleAnimation(vm, seqIndex)
    local w = vm:GetOwner()
    if w:HasFlag("Aiming") && !string.find(string.lower(seqIndex), "idle") then return end

    if w:HasFlag("UsingUnderbarrel") then
        if (w.Secondary.TranslateAnimations[seqIndex] != nil) then
            seqIndex = w.Secondary.TranslateAnimations[seqIndex]
        else
            return
        end
    end

    if w:GetCurrentTask() == 0 then
        vm:PlayAnimation(seqIndex, true)
    end
end

local function locomotion(vm)
    local w = vm:GetOwner()
    local p = w:GetOwner()
    if !IsValid(p) || !p:IsPlayer() then return end
    
    local fovAimMult = math.Clamp(w.Zoom.FovMultiplier, 0.5, 1)
    local aimDelta = Lerp(vm.m_AimDeltaLerp, 1, 0.03 * fovAimMult * (w.Zoom.MovementMultiplier || 1))
    local lerpSpeed = w:HasFlag("Reloading") && -1 || 1
    reloadDeltaLerp = math.Clamp(reloadDeltaLerp + lerpSpeed*FrameTime(), 0, 1)

    local vel = p:GetVelocity()
    vel = Vector(vel.x, vel.y, 0)
    local len = math.max(vel:Length(), 0.01)

    if !p:IsOnGround() || (p.GetSliding && p:GetSliding()) then
        vm.m_LocomotionDeltaLerp = mw_math.SafeLerp(6 * RealFrameTime(), vm.m_LocomotionDeltaLerp, 0)
    else
        vm.m_LocomotionDeltaLerp = mw_math.SafeLerp(4 * RealFrameTime(), vm.m_LocomotionDeltaLerp, len / p:GetWalkSpeed())
    end

    --jogging and walking
    local slowWalkPoint = p:GetSlowWalkSpeed() / p:GetWalkSpeed()
    local slowWalkDelta = 1 - math.abs(slowWalkPoint - vm.m_LocomotionDeltaLerp) / slowWalkPoint
    slowWalkDelta = math.max(slowWalkDelta, vm.m_SlowWalkMin)
    local jogDelta = vm.m_LocomotionDeltaLerp - slowWalkDelta

    --when we stop jogging
    if jogDelta <= 0.5 && !vm.m_bMoveStopped then
        if p:IsOnGround() then
            playIdleAnimation(vm, "Jog_Out")
        end

        vm.m_bMoveStopped = true
    elseif jogDelta > 0.5 then
        vm.m_bMoveStopped = false
    end

    --when we start moving
    if vm.m_LocomotionDeltaLerp > 0.1 && !vm.m_bMoveStarted then
        if p:IsOnGround() then
            playIdleAnimation(vm, "Land")
        end

        vm.m_bMoveStarted = true
    elseif vm.m_LocomotionDeltaLerp <= 0.1 then
        vm.m_bMoveStarted = false
    end
	
	vm:SetPoseParameter("jog_loop", math.min(jogDelta * aimDelta, aimDelta))
    vm:SetPoseParameter("walk_loop", math.min(slowWalkDelta * aimDelta, aimDelta))

    --freefall loop
    local z = math.min(p:GetVelocity().z, 0)
    local delta = math.min(math.min(z + 500, 0) / -1100, 1)
    vm:SetPoseParameter("freefall_loop", delta * Lerp(vm.m_AimDeltaLerp, 1, 0.1))

    --jumping and landing
    if vm.m_bOnGround != p:IsOnGround() then
        if !p:IsOnGround() then
            playIdleAnimation(vm, "Jump")
        else
            playIdleAnimation(vm, "Land")
        end

        vm.m_bOnGround = p:IsOnGround()
    end

    --sprint
    local sprintPoint = p:GetRunSpeed() / p:GetWalkSpeed()
    local sprintDelta = (vm.m_LocomotionDeltaLerp - 1) / (sprintPoint - 1)
    vm:SetPoseParameter("sprint_loop", math.min(sprintDelta, aimDelta) * aimDelta * reloadDeltaLerp)
    vm:SetPoseParameter("super_sprint_loop", math.min(sprintDelta, aimDelta) * aimDelta * reloadDeltaLerp)

    --the offset when moving in general
    local offsetDelta = mw_math.CosineInterp(vm.m_LocomotionDeltaLerp * math.Clamp(1 - sprintDelta, 0, 1), 0, 1)
    offsetDelta = offsetDelta * (1 - math.Clamp(vm.m_AimDeltaLerp * 2, 0, 1))
    vm:SetPoseParameter("jog_offset", offsetDelta)

    --after fire reshoulder
    if vm.m_LastSprayRounds != w:GetSprayRounds() && !w:HasFlag("BipodDeployed") then
        if w:GetSprayRounds() == 0 && vm.m_LastSprayRounds >= 5 then
            if !string.find(string.lower(vm.m_LastSequenceIndex), "fire") then
                local anim = math.random(1, 2) == 1 && "Land" || "Jog_Out"

                if w.Animations.SprayEnd then
                    anim = "SprayEnd"
                end

                playIdleAnimation(vm, anim)
                vm.m_LastSprayRounds = w:GetSprayRounds()
            end
        else
            vm.m_LastSprayRounds = w:GetSprayRounds()
        end
    end
end

local function inspection(vm)
    local w = vm:GetOwner()

    local randomness = math.sin(CurTime() * 2) * 0.05 + math.sin(CurTime() * 3) * 0.05
    local inspectDelta = w.FreezeInspectDelta || 0.15

    if w:Clip1() <= 0 && w.EmptyFreezeInspectDelta then
        inspectDelta = w.EmptyFreezeInspectDelta
    end

    local bStop = w:HasFlag("StoppedInspectAnimation") || (w:HasFlag("Customizing") && vm:GetCycle() > inspectDelta)
    vm.m_InspectSpeed = mw_math.SafeLerp(5 * RealFrameTime(), vm.m_InspectSpeed, Lerp(mw_math.btn(bStop), 1, randomness))

    if string.find(string.lower(vm.m_LastSequenceIndex), "inspect") then
        vm:SetPlaybackRate(vm.m_InspectSpeed)
    end
end

local function grips(vm)
    local w = vm:GetOwner()

    if w.GripPoseParameters then
        for i, pp in pairs(w.GripPoseParameters) do
            vm:SetPoseParameter(pp, 0)
        end

        vm.m_LeftHandGripLerp = math.Approach(vm.m_LeftHandGripLerp, vm.m_LeftHandGripTarget, 10 * RealFrameTime())

        if vm.m_LeftHandGripPoseParameter then
            vm:SetPoseParameter(vm.m_LeftHandGripPoseParameter, vm.m_LeftHandGripLerp)
        end
    end

    if w.GripPoseParameters2 then
        for i, pp in pairs(w.GripPoseParameters2) do
            vm:SetPoseParameter(pp, 0)
        end

        vm.m_RightHandGripLerp = math.Approach(vm.m_RightHandGripLerp, vm.m_RightHandGripTarget, 10 * RealFrameTime())

        if vm.m_RightHandGripPoseParameter then
            vm:SetPoseParameter(vm.m_RightHandGripPoseParameter, vm.m_RightHandGripLerp)
        end
    end

    if w.GripPoseParameters3 then
        for i, pp in pairs(w.GripPoseParameters3) do
            vm:SetPoseParameter(pp, 0)
        end

        vm.m_MiscGripLerp = math.Approach(vm.m_MiscGripLerp, vm.m_MiscGripTarget, 10 * RealFrameTime())

        if vm.m_MiscGripPoseParameter then
            vm:SetPoseParameter(vm.m_MiscGripPoseParameter, vm.m_MiscGripLerp)
        end
    end
end

function ENT:SetPoseParameters()
    local w = self:GetOwner()

    self:SetPoseParameter("aim_offset", self.m_AimDeltaLerp)
    self:SetPoseParameter("hybrid_offset", w:GetAimMode())
    self:SetPoseParameter("firemode_offset", w:GetFiremode() - 1)
    self:SetPoseParameter("empty_offset",  mw_math.btn(w:Clip1() <= 0 || !w:HasFlag("Rechambered")))
    self:SetPoseParameter("bipod", mw_math.btn(w:HasFlag("BipodDeployed")))

    w:SetPoseParameters(self)
end

function ENT:Think()
    local w = self:GetOwner()
    if !IsValid(w) then return end
    
    self:ReconcileServerAnims()

    if !w:IsCarriedByLocalPlayer() || !IsValid(w:GetOwner()) || w != w:GetOwner():GetActiveWeapon() then
        return
    end

    if self.m_UpdateDelta <= 0.2 then
        self:UpdateAnimation(self.m_LastSequenceIndex)
        self.m_UpdateDelta = self.m_UpdateDelta + FrameTime()
        --WAKE UP GODDAMN IT
    end
    
    if self.m_LastSequenceIndex != "INIT" then
        self.m_AimDeltaLerp = mw_math.SafeLerp(30 * RealFrameTime(), self.m_AimDeltaLerp, w:GetAimDelta())
        
        self:SetPoseParameters()
        
        --we play idle a bit earlier if ads in
        local targetCycle = self.m_LastSequenceIndex == "Ads_In" && 0.5 || 0.98

        if (self:GetCycle() >= targetCycle) then
            playIdleAnimation(self, w:GetIdleAnimation())
        end 

        --states
        locomotion(self)
        inspection(self)
        grips(self)
    end
end

function ENT:ReconcileServerAnims()
    if !self.m_AnimFromServer then return end

    local tick = self.m_AnimFromServer.Tick
    local animId = self.m_AnimFromServer.AnimID
    local rate = self.m_AnimFromServer.Rate
    local timeDifference = self.m_AnimFromServer.TimeDifference
    self.m_AnimFromServer = nil

    local seqIndex = self:GetSequenceIndexByID(animId)

    if tick < self.m_Tick || (tick == self.m_Tick && self.m_LastSequenceIndex == seqIndex) then
        return
    end

    local sequences = self:GetOwner().Animations[seqIndex].Sequences
                
    local seqId = self:LookupSequence(sequences[1])
    local length = self:SequenceDuration(seqId)
        
    local cycle = timeDifference / length
    cycle = cycle * rate

    self:PlaySequence(sequences[math.random(1, #sequences)], rate, cycle)

    self.m_LastSequenceIndex = seqIndex
    self.m_Tick = tick
end

function ENT:VManipPostPlayAnim(name)
    playIdleAnimation(self, "Jog_Out")
end

function ENT:VManipHoldQuit()
    playIdleAnimation(self, "Land")
end

function ENT:VManipRemove()
    playIdleAnimation(self, "Jog_Out")
end