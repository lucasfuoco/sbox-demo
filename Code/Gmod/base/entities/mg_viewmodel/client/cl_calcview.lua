require("mw_math")
require("mw_utils")

local lerp = Lerp
local clamp = math.Clamp
local safeLerp = mw_math.SafeLerp
local realFrameTime = RealFrameTime
local approach = mw_math.Approach
local approachAngle = mw_math.ApproachAngle

ENT.m_AimDelta = 0
ENT.m_AimModeDelta = 0
ENT.m_AdsFovMult = 1
ENT.m_CameraAttachment = nil

local function getSightCompensate(w)
    return w:GetSight() && 0.5*w.Zoom.FovMultiplier || 1
end

function ENT:CalcView(origin, angles)
    if !self:GetRenderOrigin() || !self.m_CameraAttachment then return end

    local camera = self.m_CameraAttachment
    local cameraPos, cameraAng = camera:GetTranslation(), camera:GetAngles()
    
    angles:RotateAroundAxis(angles:Forward(), cameraAng.r)
    angles:RotateAroundAxis(angles:Up(), -cameraAng.y)
    angles:RotateAroundAxis(angles:Right(), cameraAng.p)

    mw_math.VectorAddAndMul(origin, angles:Forward(), -cameraPos.x)
    mw_math.VectorAddAndMul(origin, angles:Up(), -cameraPos.z)
    mw_math.VectorAddAndMul(origin, angles:Right(), cameraPos.y)
end

ENT.m_LastZVel = 0
ENT.m_LandTarget = 0
ENT.m_Movement = {
    x = mw_math.CreateSpring(150, 0.9),
    y = mw_math.CreateSpring(150, 0.9),
    z = mw_math.CreateSpring(150, 0.9),
}

local function movementInertia(vm, pos, ang)
    if !IsValid(vm:GetPlayerOwner()) then return end
    
    local w = vm:GetWeaponOwner()
    local p = vm:GetPlayerOwner()
    local vel = p:GetVelocity()

    -- vertical movement
    if !p:IsOnGround() then
        vm.m_LastZVel = clamp(vel.z * 0.003, -1, 1) * 2
        vm.m_LandTarget = 0
    else
        if vm.m_LastZVel != 0 then
            vm.m_LandTarget = -vm.m_LastZVel * 5
            vm.m_LastZVel = 0
        end

        vm.m_LandTarget = safeLerp(20 * FrameTime(), vm.m_LandTarget, 0)
    end

    vm.m_Movement.z:SetTarget(vm.m_LastZVel + vm.m_LandTarget)
    vm.m_Movement.z:Decay()

    -- horizontal movement
    vel:Div(p:GetWalkSpeed())

    local dotY = 0
    local dotX = 0
    if !w:HasFlag("Sprinting") then
        local movementAngles = Angle(0, p:EyeAngles().y, 0)
        dotY = clamp(-movementAngles:Forward():Dot(vel), -1.25, 1.25)

        dotX = clamp(-movementAngles:Right():Dot(vel), -1.25, 1.25)
    end

    vm.m_Movement.x:SetTarget(dotX)
    vm.m_Movement.y:SetTarget(dotY)
    vm.m_Movement.x:Decay()
    vm.m_Movement.y:Decay()

    local aimingMult = safeLerp(vm.m_AimDelta, 1, 0.1)
    local x = vm.m_Movement.x:GetValue() * aimingMult
    local y = vm.m_Movement.y:GetValue() * aimingMult
    local z = vm.m_Movement.z:GetValue() * aimingMult

    aimingMult = safeLerp(vm.m_AimDelta, 1, 0.2 * getSightCompensate(w))
    local p = vm.m_Movement.z:GetValue() * aimingMult
    local ya = vm.m_Movement.x:GetValue() * aimingMult
    local r = vm.m_Movement.y:GetValue() * aimingMult

    pos:SetUnpacked(pos.x + x, pos.y + y, pos.z - z)
    ang:SetUnpacked(ang.p + p, ang.y + ya, ang.r)
end

local slowWalkLerp = 0

ENT.m_SwayAngle = nil
ENT.m_Sway = {
    p = mw_math.CreateSpring(150, 0.75),
    ya = mw_math.CreateSpring(120, 1),
    r = mw_math.CreateSpring(60, 0.85),
    x = mw_math.CreateSpring(145, 1),
    y = mw_math.CreateSpring(100, 1),
    z = mw_math.CreateSpring(150, 0.75)
}

local function sway(vm, pos, ang, originalAng)
    local w = vm:GetOwner()
    if !vm.m_SwayAngle then
        vm.m_SwayAngle = Angle(originalAng)
    end

    local diffY = math.AngleDifference(vm.m_SwayAngle.y, originalAng.y)
    local diffP = math.AngleDifference(vm.m_SwayAngle.p, originalAng.p)
    diffY = clamp(diffY / realFrameTime() * 0.01, -3, 3)
    diffP = clamp(diffP / realFrameTime() * 0.01, -3, 3)

    -- character turning animation
    slowWalkLerp = math.abs(diffY * 0.5)
    vm.m_SlowWalkMin = safeLerp(5 * realFrameTime(), vm.m_SlowWalkMin, slowWalkLerp)

    vm.m_Sway.z:SetTarget(diffP * 0.75)
    vm.m_Sway.x:SetTarget(diffY)
    vm.m_Sway.y:SetTarget(diffY)
    vm.m_Sway.x:Decay()
    vm.m_Sway.y:Decay()
    vm.m_Sway.z:Decay()

    vm.m_Sway.p:SetTarget(diffP * 0.75)
    vm.m_Sway.ya:SetTarget(diffY)
    vm.m_Sway.r:SetTarget(diffY)
    vm.m_Sway.p:Decay()
    vm.m_Sway.ya:Decay()
    vm.m_Sway.r:Decay()

    vm.m_SwayAngle:Set(originalAng)
    
    local aimingMult = safeLerp(vm.m_AimDelta, 1, -0.1 * getSightCompensate(w))
    local p = vm.m_Sway.p:GetValue() * aimingMult
    local ya = vm.m_Sway.ya:GetValue() * aimingMult
    local r = vm.m_Sway.r:GetValue() * aimingMult
    
    aimingMult = safeLerp(vm.m_AimDelta, 0, -0.1)
    local x = vm.m_Sway.x:GetValue() * aimingMult * 0.5
    local y = vm.m_Sway.y:GetValue() * aimingMult * 0.5
    local z = vm.m_Sway.z:GetValue() * aimingMult * 0.5

    pos:SetUnpacked(pos.x + x, pos.y + y, pos.z + z)
    ang:SetUnpacked(ang.p - p, ang.y + ya, ang.r - r)
end

local defaultSprintAngle = Angle(0, 0, 0)
local defaultSprintPos = Vector(0, 0, 0)
local defaultVManipAngle = Angle(0, 2, -10)
local defaultVManipPos = Vector(1.5, 3, -1.5)
local defaultCrouchAngle = Angle(0, 0, -5)
local defaultCrouchPos = Vector(-1, -0.5, -1)
local defaultBipodAngle = Angle()
local defaultBipodPos = Vector(-1.5, 0, -1.5)

local offsetsPos = Vector()
local offsetsAng = Angle()
local sprintAng = Angle()
local sprintPos = Vector()
local alternateAimPos = Vector()
local alternateAimAng = Angle()
local aimPos = Vector()
local aimAng = Angle()
local vManipAng = Angle()
local vManipPos = Vector()
local bipodAng = Angle()
local bipodPos = Vector()
local crouchAng = Angle()
local crouchPos = Vector()

ENT.m_OffsetPos = mw_math.CreateVectorSpring(150, 1.5)
ENT.m_OffsetAng = {
    p = mw_math.CreateSpring(150, 0.75),
    ya = mw_math.CreateSpring(120, 1),
    r = mw_math.CreateSpring(100, 1.5)
}

local function offsets(vm, pos, ang)
    local w = vm:GetOwner()
    local p = w:GetOwner()

    offsetsPos:SetUnpacked(0, 0, 0)
    offsetsAng:SetUnpacked(0, 0, 0)

    -- aim offsets
    aimPos:Set(w.ViewModelOffsets.Aim.Pos)
    aimAng:Set(w.ViewModelOffsets.Aim.Angles)

    if w:GetSight() then
        aimPos:Add(w:GetSight().AimPos || mw_math.ZeroVector)
        aimAng:Add(w:GetSight().AimAng || mw_math.ZeroAngle)
    end

    aimPos:Mul(mw_math.btn(w:HasFlag("Aiming") && w:GetAimMode() == 0))
    aimAng:Mul(mw_math.btn(w:HasFlag("Aiming") && w:GetAimMode() == 0))
    
    offsetsPos:Add(aimPos)
    offsetsAng:Add(aimAng)

    -- canted aim offsets
    alternateAimPos:Set(w.ViewModelOffsets.Aim.Pos)
    alternateAimAng:Set(w.ViewModelOffsets.Aim.Angles)

    if w:GetHybrid() then
        alternateAimPos:Add(w:GetSight().HybridAimPos || w.HybridAimPos || mw_math.ZeroVector)
        alternateAimAng:Add(w:GetSight().HybridAimAng || w.HybridAimAngles || mw_math.ZeroAngle)
    else
        local tacpos, tacang = Vector(-2, 0, 0), Angle(-0.3, 0.05, -45)

        if w:GetLaser() and w.LaserAimAngles and w.LaserAimPos then
            tacpos = w.LaserAimPos
            tacang = w.LaserAimAngles
        elseif w.ViewModelOffsets.TacStance then
            tacpos = w.ViewModelOffsets.TacStance.Pos
            tacang = w.ViewModelOffsets.TacStance.Angles
        end

        alternateAimPos:Set(tacpos)
        alternateAimAng:Set(tacang)

        local reloadDelta = 1
        if w:HasFlag("Reloading") then
            reloadDelta = lerp(mw_math.btn(CurTime() >= lerp(0.5, w:GetNextSecondaryFire(), w:GetNextPrimaryFire())), 0.5, 1)
        end

        alternateAimAng:Mul(reloadDelta)
        alternateAimPos:Mul(reloadDelta)
    end

    alternateAimPos:Mul(mw_math.btn(!(w.DisableCantedReload && w:HasFlag("Reloading")) && w:HasFlag("Aiming") && (w:GetAimMode() > 0 or w:HasFlag("TacStance"))))
    alternateAimAng:Mul(mw_math.btn(!(w.DisableCantedReload && w:HasFlag("Reloading")) && w:HasFlag("Aiming") && (w:GetAimMode() > 0 or w:HasFlag("TacStance"))))

    offsetsPos:Add(alternateAimPos)
    offsetsAng:Add(alternateAimAng)

    -- sprinting offset
    sprintAng:Set(defaultSprintAngle)
    sprintPos:Set(defaultSprintPos)

    if w.ViewModelOffsets.Sprint then
        sprintAng:Set(w.ViewModelOffsets.Sprint.Angles || sprintAng) 
        sprintPos:Set(w.ViewModelOffsets.Sprint.Pos || sprintPos) 
    end

    sprintPos:Mul(mw_math.btn(w:HasFlag("Sprinting") && vm.m_LastSequenceIndex != "Super_Sprint_In"))
    sprintAng:Mul(mw_math.btn(w:HasFlag("Sprinting") && vm.m_LastSequenceIndex != "Super_Sprint_In"))

    offsetsAng:Add(sprintAng)
    offsetsPos:Add(sprintPos)

    -- idle offset
    local eyePitch = lerp(mw_math.btn(w:HasFlag("Aiming")), p:EyeAngles().p / 90, 0)

    offsetsAng:Add(w.ViewModelOffsets.Idle.Angles * mw_math.btn(!w:HasFlag("Aiming")))
    offsetsAng.r = offsetsAng.r + (eyePitch * 5)

    offsetsPos:Add(w.ViewModelOffsets.Idle.Pos * mw_math.btn(!w:HasFlag("Aiming")))
    offsetsPos.y = offsetsPos.y + eyePitch
    offsetsPos.z = offsetsPos.z + (math.min(eyePitch, 0.5) * 5 * mw_math.btn(w:HasFlag("BipodDeployed")))

    -- Vmanip offset
    vManipAng:Set(defaultVManipAngle)
    vManipPos:Set(defaultVManipPos)

    if w.ViewModelOffsets.VManip then
        vManipAng:Set(w.ViewModelOffsets.VManip.Angles || vManipAng)
        vManipPos:Set(w.ViewModelOffsets.VManip.Pos || vManipPos)
    end

    vManipPos:Mul(mw_math.btn(VManip != nil && !w:HasFlag("Aiming") && VManip:IsActive()))
    vManipAng:Mul(mw_math.btn(VManip != nil && !w:HasFlag("Aiming") && VManip:IsActive()))

    offsetsAng:Add(vManipAng)
    offsetsPos:Add(vManipPos)

    -- bipod offset
    bipodAng:Set(defaultBipodAngle)
    bipodPos:Set(defaultBipodPos)

    if w.ViewModelOffsets.Bipod then
        bipodAng:Set(w.ViewModelOffsets.Bipod.Angles || bipodAng)
        bipodPos:Set(w.ViewModelOffsets.Bipod.Pos || bipodPos)
    end

    bipodPos:Mul(mw_math.btn(w:HasFlag("BipodDeployed") && !w:HasFlag("Aiming")))
    bipodAng:Mul(mw_math.btn(w:HasFlag("BipodDeployed") && !w:HasFlag("Aiming")))

    offsetsAng:Add(bipodAng)
    offsetsPos:Add(bipodPos)

    -- crouching offset
    crouchAng:Set(defaultCrouchAngle)
    crouchPos:Set(defaultCrouchPos)

    if w.ViewModelOffsets.Crouch then
        crouchAng:Set(w.ViewModelOffsets.Crouch.Angles || crouchAng)
        crouchPos:Set(w.ViewModelOffsets.Crouch.Pos || crouchPos)
    end

    local crouchDelta = mw_math.btn(p:IsFlagSet(4) && !w:HasFlag("BipodDeployed") && !w:HasFlag("Aiming"))
    crouchPos:Mul(crouchDelta)
    crouchAng.p = crouchAng.p * crouchDelta
    crouchAng.y = crouchAng.y * crouchDelta
    crouchAng.r = lerp(mw_math.btn(p:IsFlagSet(4) && !w:HasFlag("BipodDeployed")), 0, lerp(mw_math.btn(w:HasFlag("Aiming")), crouchAng.r, crouchAng.r * 0.5))
        
    offsetsAng:Add(crouchAng)
    offsetsPos:Add(crouchPos)

    -- final result
    vm.m_OffsetPos:SetTarget(offsetsPos)
    vm.m_OffsetAng.p:SetTarget(offsetsAng.p)
    vm.m_OffsetAng.ya:SetTarget(offsetsAng.y)
    vm.m_OffsetAng.r:SetTarget(offsetsAng.r)
    mw_math.DecaySprings(vm.m_OffsetAng.p, vm.m_OffsetAng.ya, vm.m_OffsetAng.r, vm.m_OffsetPos)

    local x, y, z = vm.m_OffsetPos:GetValue().x, vm.m_OffsetPos:GetValue().y, vm.m_OffsetPos:GetValue().z
    local pi, ya, r = vm.m_OffsetAng.p:GetValue(), vm.m_OffsetAng.ya:GetValue(), vm.m_OffsetAng.r:GetValue()

    pos:SetUnpacked(pos.x + x, pos.y + y, pos.z + z)
    ang:SetUnpacked(ang.p - pi, ang.y + ya, ang.r + r)
end

ENT.m_RecoilPos = mw_math.CreateVectorSpring(40, 1)
ENT.m_RecoilAng = mw_math.CreateAngleSpring(80, 1)
ENT.m_RecoilPosTarget = Vector()
ENT.m_RecoilAngleTarget = Angle()
ENT.m_RecoilResetSpeed = 100
ENT.m_RecoilShakeLerp = 0
ENT.m_RecoilRollLerp = 0
ENT.m_RecoilRoll = 0

function ENT:SetRecoilTargets(pos, ang)
    self.m_RecoilAngleTarget:Set(ang)
    self.m_RecoilPosTarget:Set(pos)
    self.m_RecoilResetSpeed = -1
end

local function recoil(vm, pos, ang)
    local w = vm:GetOwner()

    vm.m_RecoilShakeLerp = safeLerp(10 * realFrameTime(), vm.m_RecoilShakeLerp, w.Camera.Shake)
    vm.m_RecoilRoll = safeLerp(10 * realFrameTime(), vm.m_RecoilRoll, 0)
    vm.m_RecoilRollLerp = safeLerp(10 * realFrameTime(), vm.m_RecoilRollLerp, vm.m_RecoilRoll)

    vm.m_RecoilAng.sc = lerp(vm.m_AimDelta, 80, 240) * w:GetVMRecoil("SnapMultiplier")
    vm.m_RecoilAng.wc = lerp(vm.m_AimDelta, 1.25, 0.85) / w:GetVMRecoil("LoosenessMultiplier")
    vm.m_RecoilPos.sc = lerp(vm.m_AimDelta, 80, 120) * w:GetVMRecoil("SnapMultiplier")
    vm.m_RecoilPos.wc = lerp(vm.m_AimDelta, 1, 1.2) / w:GetVMRecoil("LoosenessMultiplier")

    vm.m_RecoilResetSpeed = safeLerp(10 * realFrameTime(), vm.m_RecoilResetSpeed, 1)
    local resetSpeed = clamp(vm.m_RecoilResetSpeed, 0, 1) * 100

    vm.m_RecoilPosTarget.x = approach(vm.m_RecoilPosTarget.x, 0, resetSpeed * realFrameTime())
    vm.m_RecoilPosTarget.y = approach(vm.m_RecoilPosTarget.y, 0, resetSpeed * realFrameTime())
    vm.m_RecoilPosTarget.z = approach(vm.m_RecoilPosTarget.z, 0, resetSpeed * realFrameTime())
	
	vm.m_RecoilPos:SetTarget(vm.m_RecoilPosTarget)
	vm.m_RecoilPos:Decay()
    
    vm.m_RecoilAngleTarget.pitch = approachAngle(vm.m_RecoilAngleTarget.pitch, 0, resetSpeed * realFrameTime())
    vm.m_RecoilAngleTarget.yaw = approachAngle(vm.m_RecoilAngleTarget.yaw, 0, resetSpeed * realFrameTime())
    vm.m_RecoilAngleTarget.roll = approachAngle(vm.m_RecoilAngleTarget.roll, 0, resetSpeed * realFrameTime())

    vm.m_RecoilAng:SetTarget(vm.m_RecoilAngleTarget * 10)
    vm.m_RecoilAng:Decay()
	
    local p = vm.m_RecoilAng:GetValue().p * lerp(vm.m_AimDelta, 1, 0.065)
    local ya = vm.m_RecoilAng:GetValue().y * lerp(vm.m_AimDelta, 1, 0.08)
    local r = vm.m_RecoilAng:GetValue().r * lerp(vm.m_AimDelta, 1, 0.1)

    ang.p = ang.p - p
    ang.y = ang.y - ya
    ang.r = ang.r + r + lerp(vm.m_AimDelta, 0, vm.m_RecoilRollLerp)

    local x = vm.m_RecoilPos:GetValue().x * lerp(vm.m_AimDelta, 1, 0.35)
    local y = vm.m_RecoilPos:GetValue().y * lerp(vm.m_AimDelta, 1, 0.35)
    local z = vm.m_RecoilPos:GetValue().z * lerp(vm.m_AimDelta, 1, 0.35) 

    pos.x = pos.x - x
    pos.y = pos.y - y - lerp(vm.m_AimDelta, 0, vm.m_RecoilShakeLerp * 1.5)
    pos.z = pos.z + z
end

ENT.m_BreathingAng = {
    p = mw_math.CreateSpring(100, 1),
    ya = mw_math.CreateSpring(100, 1)
}

local function breathingSway(vm, pos, ang)
    local w = vm:GetOwner()
    local swayAngle = w.Camera.LerpBreathing * 0.25

    vm.m_BreathingAng.p:SetTarget(swayAngle.p)
    vm.m_BreathingAng.ya:SetTarget(swayAngle.ya)
    vm.m_BreathingAng.p:Decay()
    vm.m_BreathingAng.ya:Decay()

    local x = vm.m_BreathingAng.ya:GetValue()
    local y = vm.m_BreathingAng.p:GetValue()

    pos.x = pos.x + x * 0.5
    pos.z = pos.z + y * 0.5
    
    ang.p = ang.p - y * getSightCompensate(w)
    ang.ya = ang.ya + x * getSightCompensate(w)
end

function ENT:CalcViewModelView(pos, ang)
    if game.SinglePlayer() && gui.IsGameUIVisible() then return end
    
    local w = self:GetOwner()
    local cPos, cAng = Vector(), Angle()
    local lpos, lang = hook.Run("CalcViewModelView", w, self, pos, ang, Vector(pos), Angle(ang))
    pos:Set(lpos)
    ang:Set(lang)

    local aimModeDelta = w:HasFlag("TacStance") && w:GetTacStanceDelta() || w:GetAimModeDelta()
    self.m_AimDelta = safeLerp(18 * realFrameTime(), self.m_AimDelta, w:GetAimDelta())
    self.m_AimModeDelta = safeLerp(18 * realFrameTime(), self.m_AimModeDelta, aimModeDelta)

    ang:Add(w.Camera.LerpBreathing)

    -- do all the stuff
    movementInertia(self, cPos, cAng)
    sway(self, cPos, cAng, ang)
    recoil(self, cPos, cAng)
    breathingSway(self, cPos, cAng)

    cPos:Mul(mw_math.btn(1 / realFrameTime() >= 14))
    cAng:Mul(mw_math.btn(1 / realFrameTime() >= 14))
    
    pos:Add(ang:Right() * cPos.x)
    pos:Add(ang:Forward() * cPos.y)
    pos:Add(ang:Up() * cPos.z)

    ang:RotateAroundAxis(ang:Right(), cAng.p)
    ang:RotateAroundAxis(ang:Up(), cAng.y)
    ang:RotateAroundAxis(ang:Forward(), cAng.r)

    --we calculate offsets at the end so movements are aligned to original axis
    --regardless of offset
    cPos:SetUnpacked(0, 0, 0)
    cAng:SetUnpacked(0, 0, 0)
    offsets(self, cPos, cAng)

    ang:RotateAroundAxis(ang:Right(), cAng.p)
    ang:RotateAroundAxis(ang:Up(), cAng.y)
    ang:RotateAroundAxis(ang:Forward(), cAng.r)
    
    pos:Add(ang:Right() * cPos.x)
    pos:Add(ang:Forward() * cPos.y)
    pos:Add(ang:Up() * cPos.z)

    -- viewmodel Offset setting
    local aimingMult = safeLerp(self.m_AimDelta, 1, 0)
    local xVar = GetConVar("mgbase_fx_vmposx"):GetFloat() * aimingMult
    local yVar = GetConVar("mgbase_fx_vmposy"):GetFloat() * aimingMult
    local zVar = GetConVar("mgbase_fx_vmposz"):GetFloat() * aimingMult
    pos:Add(ang:Right() * xVar)
    pos:Add(ang:Up() * yVar)
    pos:Add(ang:Forward() * zVar)

    -- viewmodel fov setting
    local originalFov = weapons.GetStored("mg_base").ViewModelFOV
    local hipFovMul = GetConVar("mgbase_fx_vmfov"):GetFloat()
    self.m_AdsFovMult = GetConVar("mgbase_fx_vmfov_ads"):GetFloat()
    if w:GetSight() && w:GetSight().Optic then
        self.m_AdsFovMult = math.max(self.m_AdsFovMult, lerp(self.m_AimModeDelta, 1, self.m_AdsFovMult))
    end

    w.ViewModelFOV = safeLerp(self.m_AimDelta, originalFov, originalFov * lerp(self.m_AimModeDelta, w.Zoom.ViewModelFovMultiplier, 0.9))
    w.ViewModelFOV = w.ViewModelFOV * lerp(self.m_AimDelta, hipFovMul, self.m_AdsFovMult)

    local viewEntity = GetViewEntity()
    if viewEntity:IsPlayer() then
        w.ViewModelFOV = w.ViewModelFOV - (w.Camera.Fov - viewEntity:GetFOV())
    end
end