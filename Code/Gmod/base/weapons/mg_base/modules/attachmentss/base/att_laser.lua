require("mw_math")
require("mw_utils")

ATTACHMENT.Base = "att_base"
ATTACHMENT.Name = "Default"
ATTACHMENT.Category = "Lasers"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:RemoveFlashlightStuffFromModel(flashModel)
    if (IsValid(flashModel)) then 
        if (IsValid(flashModel.mw_flashlightProjTexture)) then
            flashModel.mw_flashlightProjTexture:Remove()
        end

        if (IsValid(flashModel.mw_flashlightParticle)) then
            flashModel.mw_flashlightParticle:StopEmissionAndDestroyImmediately()
        end
    end
end

function ATTACHMENT:DoLaserRender(weapon, laserModel)
    if (self.Laser == nil) then
        return
    end

    if (CurTime() < LocalPlayer():GetNWFloat("MW19_EMPEffect", CurTime())) then
        return
    end

    local att = mw_utils.GetFastAttachment(laserModel, self.Laser.Attachment)

    local tr = util.TraceLine({
        start = att.Pos + att.Ang:Forward() * -10,
        endpos = att.Pos + att.Ang:Forward() * 1000,
        filter = {weapon, weapon:GetOwner()},
        mask = MASK_SHOT
    })

    if (laserModel.mw_laserTrailPos == nil) then
        laserModel.mw_laserTrailPos = tr.HitPos
    end

    local distSq = tr.HitPos:DistToSqr(att.Pos)
    local beamDelta = math.Clamp(distSq / ((self.Laser.BeamSize * 5) * (self.Laser.BeamSize * 5)), 0, 1)

    local color = self.Laser.Color

    if (GetConVar("mgbase_fx_laser_weaponcolor", 0):GetBool()) then
        if (IsValid(weapon:GetOwner()) && weapon:GetOwner():IsPlayer()) then
            local c = weapon:GetOwner():GetWeaponColor()
            color = Color(c.x * 255, c.y * 255, c.z * 255, 255)
        end
    end
    
    local pos = tr.HitPos * 1

    if (weapon:GetSight() == nil || weapon:GetSight().ReticleHybrid == nil) then
        mw_math.SafeLerpVector((weapon:GetAimDelta() * 0.8) * weapon:GetAimModeDelta(), pos, EyePos() + EyeAngles():Forward() * 300)
    end

    render.SetMaterial(self.Laser.BeamMaterial)
    render.DrawBeam(att.Pos, pos, self.Laser.BeamWidth * math.random(0.5, 1), 0, 1, color)

    local normal = tr.HitNormal * 1
    mw_math.SafeLerpVector(weapon:GetAimDelta(), normal, (EyePos() - pos):GetNormalized())

    local sens = Lerp(weapon:GetAimDelta(), 50, 150)
    mw_math.SafeLerpVector(math.min(sens * FrameTime(), 1), laserModel.mw_laserTrailPos, pos)

    local bCanDrawDistance = tr.HitPos:DistToSqr(att.Pos) > (10 * 10)

    if (!bCanDrawDistance) then
        return
    end

    render.SetMaterial(self.Laser.DotMaterial)
    render.DrawQuadEasy(pos, normal, self.Laser.DotSize, self.Laser.DotSize, color, math.random(179, 180))
    render.DrawBeam(laserModel.mw_laserTrailPos, pos, self.Laser.DotSize * 0.8, 0, 0.5, color)
end

function ATTACHMENT:DrawFlashlight(weapon, model)
    if (self.Flashlight == nil) then
        return
    end

    if (CurTime() < LocalPlayer():GetNWFloat("MW19_EMPEffect", CurTime())) then
        return
    end
    
    if (!weapon:HasFlag("FlashlightOn") || weapon:GetOwner():FlashlightIsOn() || weapon:HasFlag("Holstering")) then
        self:RemoveFlashlightStuffFromModel(model)
        return
    end
    
    local att = mw_utils.GetFastAttachment(model, self.Flashlight.Attachment)

    if (!IsValid(model.mw_flashlightParticle)) then
        model.mw_flashlightParticle = CreateParticleSystem(model, "flashlight_mw19", PATTACH_POINT_FOLLOW, mw_utils.LookupAttachmentCached(model, self.Flashlight.Attachment))
        model.mw_flashlightParticle:StartEmission()
        model.mw_flashlightParticle:SetShouldDraw(false)
        model.mw_flashlightParticle:SetIsViewModelEffect(model == self.m_Model)
    end

    local particle = model.mw_flashlightParticle
    particle:SetControlPoint(1, att.Pos)
    particle:SetControlPointOrientation(1, att.Ang:Forward(), att.Ang:Right(), att.Ang:Up())
    particle:Render()

    if (!IsValid(model.mw_flashlightProjTexture)) then
        model.mw_flashlightProjTexture = ProjectedTexture()
        model.mw_flashlightProjTexture:SetFOV(50)
        model.mw_flashlightProjTexture:SetTexture(self.Flashlight.FlashlightMaterial:GetTexture("$basetexture"))
    end

    local proj = model.mw_flashlightProjTexture
    proj:SetPos(att.Pos + att.Ang:Forward() * -3)
    proj:SetAngles(att.Ang)
    proj:Update()
end

local bDrewViewModel = false

function ATTACHMENT:Render(weapon, model, flags)   
    flags = flags or STUDIO_RENDER
    BaseClass.Render(self, weapon, flags)

    local isDepthPass = ( bit.band( flags, STUDIO_SSAODEPTHTEXTURE ) != 0 || bit.band( flags, STUDIO_SHADOWDEPTHTEXTURE ) != 0 )
    if isDepthPass then return end
    
    self:DoLaserRender(weapon, model)
    
    if (model == self.m_Model) then
        self:DrawFlashlight(weapon, model)
        bDrewViewModel = true
    end

    if (model == self.m_TpModel) then
        if (!bDrewViewModel) then
            self:RemoveFlashlightStuffFromModel(self.m_Model)
        end
        bDrewViewModel = false
    end
end

function ATTACHMENT:OnRemove(weapon)
    if (CLIENT) then
        self:RemoveFlashlightStuffFromModel(self.m_Model)
        self:RemoveFlashlightStuffFromModel(self.m_TpModel)
    end

    BaseClass.OnRemove(self, weapon)
end