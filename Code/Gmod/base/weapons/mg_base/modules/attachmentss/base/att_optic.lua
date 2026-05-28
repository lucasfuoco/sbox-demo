require("mw_utils")
ATTACHMENT.Base = "att_sight_reticle"

if (SERVER) then
    return
end

ATTACHMENT._RTTexture = GetRenderTarget("mw19_rt", 512, 512)

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
local ParallaxMaterial = Material("mw19_parallax.vmt")
local RefractMaterial = Material("mw19_scoperefract.vmt")
local RefractTintMaterial = Material("mw19_refracttint.vmt")
local FishEyeMaterial = Material("mw_fisheyelens")

local function util_NormalizeAngles(a)
    a.p =  math.NormalizeAngle(a.p)
    a.y =  math.NormalizeAngle(a.y)
    a.r =  math.NormalizeAngle(a.r)
    return a
end

function ATTACHMENT:Init(weapon)
    BaseClass.Init(self, weapon)
    
    self.hideModel = ClientsideModel(self.Optic.HideModel, weapon.RenderGroup)
    self.hideModel:SetMoveType(MOVETYPE_NONE)
    self.hideModel:SetNoDraw(true)
end

function ATTACHMENT:OnRemove(weapon)
    BaseClass.OnRemove(self, weapon)
    
    if (IsValid(self.hideModel)) then
        self.hideModel:Remove()
    end
end

--https://github.com/Lexicality/stencil-tutorial/blob/master/lua/stencil_tutorial/06_cutting_holes_in_props.lua
function ATTACHMENT:Render(weapon, model)
    local bCanRemoveBodygroup = weapon:GetAimModeDelta() < 0.5 && weapon:GetAimDelta() > 0.9 && weapon:GetTacStanceDelta() < 0.5
    
    self.m_Model:SetBodygroup(
    self.m_Model:FindBodygroupByName(self.Optic.LensBodygroup), 
    bCanRemoveBodygroup && 0 || 1
    )

    if (!bCanRemoveBodygroup) then
        self.m_Model:DrawModel()

        if (!self.m_bRemovedRT) then
            render.PushRenderTarget(self._RTTexture, 0, 0, 1024, 1024)
            render.PopRenderTarget()
            self.Optic.LensHideMaterial:SetTexture("$basetexture", self._RTTexture)
            self.m_bRemovedRT = true
        end

        return
    end

    self.m_bRemovedRT = false
    
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(MWBASE_STENCIL_REFVALUE + 2)
    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)

    --dirty and quick way to make it work with velements and bonemerged
    self.m_Model:SetupBones()
    self.m_Model:InvalidateBoneCache()
    local matrix = self.m_Model:GetBoneMatrix(0)

    self.hideModel:SetPos(matrix:GetTranslation())
    self.hideModel:SetAngles(matrix:GetAngles())

    self.hideModel:DrawModel()

    render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    self.m_Model:DrawModel()

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    if (self.Optic.Thermal) then
        self:DrawThermal(weapon)
    end

    render.SetStencilEnable(false)
    render.ClearStencil()

    ------------------------------

    self:DoReticleStencil(self.hideModel, self.Reticle, weapon)

    ------------------------------

    local att = mw_utils.GetFastAttachment(self.m_Model, self.Reticle.Attachment)
    
    render.PushRenderTarget(self._RTTexture, 0, 0, 1024, 1024)
    cam.Start2D()
        render.Clear(0, 0, 0, 0)
        --REFTINT:
        local tintSize = 400
        surface.SetMaterial(RefractTintMaterial)
        surface.SetDrawColor(0, 0, 0, 255)
        --for i = 1, 2, 1 do
        surface.DrawTexturedRect(tintSize * -0.5, tintSize * -0.5, ScrW() + tintSize, ScrH() + tintSize)
        --end
        --[[render.SetMaterial(FishEyeMaterial)
        render.UpdateScreenEffectTexture()
        render.DrawScreenQuad()]]
        
        ----
        if (!self.Optic.Thermal) then
            self:DrawParallax(weapon, att.Ang)
        end
    cam.End2D()
    render.PopRenderTarget()
    self.Optic.LensHideMaterial:SetTexture("$basetexture", self._RTTexture)
end

local thermalCC = {
    [ "$pp_colour_addr" ] = 0,
    [ "$pp_colour_addg" ] = 0,
    [ "$pp_colour_addb" ] = 0,
    [ "$pp_colour_brightness" ] = 1.54,
    [ "$pp_colour_contrast" ] = 0.1,
    [ "$pp_colour_colour" ] = 0,
    [ "$pp_colour_mulr" ] = 0,
    [ "$pp_colour_mulg" ] = 0,
    [ "$pp_colour_mulb" ] = 0
}

local ThermalNoiseMaterial = Material("mw19_thermalnoise.vmt")
local sunMaterial = Material("mg/cursorglow")

local function drawEnt(ent)
    if (ent:GetNoDraw()) then
        return
    end

    ent:DrawModel() 
end

function ATTACHMENT:DrawThermal(weapon)
    --DrawColorModify(thermalCC)

    local backgroundColor = self.Optic.ThermalBackgroundColor || Color(50, 50, 50, 240)
    local bodyColor = self.Optic.ThermalBodiesColor || Color(255, 255, 255, 150)

    cam.Start2D()
        surface.SetDrawColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)
        surface.DrawRect(0, 0, ScrW(), ScrH())

        local sun = util.GetSunInfo()

        if (sun != nil && sun.obstruction > 0) then
            local pos = EyePos() + sun.direction * 4096
            pos = pos:ToScreen()
            local alpha = 255 * sun.obstruction
            local sunSize = 1024

            surface.SetMaterial(sunMaterial)
            surface.SetDrawColor(bodyColor.r, bodyColor.g, bodyColor.b, alpha)
            surface.DrawTexturedRect(pos.x - (sunSize * 0.5), pos.y - (sunSize * 0.5), sunSize, sunSize)
        end

        surface.SetMaterial(ThermalNoiseMaterial)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(ScrW() * 0.25, ScrH() * 0.25, ScrW() * 0.5, ScrH() * 0.5)
    cam.End2D()
    
    render.SetStencilPassOperation(STENCILOPERATION_INCR)
    
    render.SetBlend(0)
        if (IsValid(weapon:GetViewModel().m_CHands)) then
            drawEnt(weapon:GetViewModel().m_CHands)
        end

        if (IsValid(weapon:GetViewModel().m_Gloves)) then
            drawEnt(weapon:GetViewModel().m_Gloves)
        end

        cam.Start3D()
            for i, e in pairs(ents.GetAll()) do
                if (e:IsNPC() || e:IsPlayer() || e:IsNextBot()) then
                    if (e:Health() <= 0) then
                        continue
                    end

                    drawEnt(e)
                end
            end
        cam.End3D()
    render.SetBlend(1)

    render.SetStencilCompareFunction(STENCIL_LESS)
    
    cam.Start2D()
        surface.SetDrawColor(bodyColor.r, bodyColor.g, bodyColor.b, bodyColor.a)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    cam.End2D()

    render.SetStencilEnable(false)
    render.ClearStencil()
end

function ATTACHMENT:DrawParallax(weapon, ang)
    ang:Sub(EyeAngles())
    local angDif = util_NormalizeAngles(ang) * 100
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(MWBASE_STENCIL_REFVALUE + 2)
    
    local pSize = self.Optic.ParallaxSize - (weapon.Camera.Shake * 200)
    surface.SetMaterial(ParallaxMaterial)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawTexturedRect(ScrW() * -0.5 - pSize * 0.5 - angDif.y, ScrH() * -0.5 - pSize * 0.5 + angDif.p, ScrW() * 2 + pSize, ScrH() * 2 + pSize)
    
    render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
    
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, ScrW(), ScrH())
    
    render.SetStencilEnable(false)
    render.ClearStencil()
end

local glintMaterial = Material("sprites/glow04_noz")

function ATTACHMENT:WorldModelRender(weapon)
    if (weapon:IsCarriedByLocalPlayer()) then
        return
    end

    local pos, ang = self.m_TpModel:GetBonePosition(0)
    local dot = ang:Forward():Dot(EyeAngles():Forward())

    if (dot > 0) then
        return
    end

    local dist = EyePos():Distance(pos)

    if (dist < 1024) then
        return
    end

    local sizeFactor = (dist * 0.01)
    local scale = 6 * (0.5 - weapon.Zoom.FovMultiplier) * sizeFactor
    local randomSize = math.Rand(0, 2) * sizeFactor
    render.SetMaterial(glintMaterial)
    render.DrawSprite(pos + ang:Forward() * 10 + ang:Up() * 2, scale + (randomSize * 2), (scale * 0.5) + randomSize, Color(255, 255, 255, 255))
end