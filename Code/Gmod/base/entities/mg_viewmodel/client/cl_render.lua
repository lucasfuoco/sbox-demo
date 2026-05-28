local function drawModels(vm, ent, flags)
    --https://github.com/Facepunch/garrysmod-issues/issues/4821
    --i didn't need this before, but now i do :shrug:
    ent:RemoveEFlags(EFL_USE_PARTITION_WHEN_NOT_SOLID)

    local children = ent:GetChildren()
    local numChildren = #children

    if (ent:IsEffectActive(EF_BONEMERGE)) then
        if (ent == vm.m_CHands) then
            ent:SetRenderOrigin(LocalToWorld(-ent:OBBCenter(), mw_math.ZeroAngle, vm:GetRenderOrigin(), vm:GetRenderAngles()))
        else    
            if (ent:EntIndex() < 0) then
                ent:SetRenderOrigin(vm:GetRenderOrigin())
            end

            if (numChildren > 0) then
                --some weird issue on windowed needs this
                ent:SetupBones()
            end
        end  
    end
    
    if ((numChildren <= 0 || ent:EntIndex() > 0) && !ent.bAttachmentRenderOverride) then
        ent:DrawModel(flags)
    end

    ent.CustomizationAnimationDelta = 0
    
    for c = 1, numChildren do
        drawModels(vm, children[c], flags)
    end
end

local function isCustomizing()
    return IsValid(MW_CUSTOMIZEMENU)
end

local function drawCustomizationBackground()
    if (!isCustomizing()) then
        return
    end

    cam.Start2D()
        surface.SetDrawColor(0, 0, 0, MW_CUSTOMIZEMENU.AlphaDelta * 200)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    cam.End2D()
end

local function shouldDrawModel(model, children)
    for _, c in pairs(children) do
        if (!c:IsEffectActive(EF_BONEMERGE)) then
            return true
        end
    end

    return #children <= 0 || model:EntIndex() > 0
end

local function drawCustomizationHighlights(model, flags, refvalue)
    model.CustomizationAnimationDelta = (model.CustomizationAnimationDelta || 0) - (math.min(FrameTime(), 0.1) * 3)
    
    local children = model:GetChildren()

    if (shouldDrawModel(model, children)) then
        model:RemoveEFlags(EFL_USE_PARTITION_WHEN_NOT_SOLID)

        if (#children > 0) then
            --some weird issue on windowed needs this
            model:SetupBones()
        end

        render.SetStencilWriteMask(0xFF)
        render.SetStencilTestMask(0xFF)
        render.SetStencilReferenceValue(0)

        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilPassOperation(STENCIL_REPLACE)
        render.SetStencilFailOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_KEEP)
                
        render.SetStencilEnable(true)
        render.SetStencilReferenceValue(refvalue + 1)
            model:RemoveEFlags(EFL_USE_PARTITION_WHEN_NOT_SOLID)
            model:DrawModel(flags)
        render.SetStencilCompareFunction(STENCIL_EQUAL)

        if (model.CustomizationAnimationDelta > 0) then
            cam.Start2D()
                surface.SetDrawColor(model.CustomizationAnimationColor.r, model.CustomizationAnimationColor.g, model.CustomizationAnimationColor.b, model.CustomizationAnimationDelta * 200)
                surface.DrawRect(0, 0, ScrW(), ScrH())
            cam.End2D()
        end

        render.SetStencilEnable(false)
    end

    for i, c in pairs(children) do
        drawCustomizationHighlights(c, flags, refvalue + i + #c:GetChildren()) --this is gonna get out of hand eventually
    end
end

function ENT:Draw(flags)
    local isDepthPass = ( bit.band( flags, STUDIO_SSAODEPTHTEXTURE ) != 0 || bit.band( flags, STUDIO_SHADOWDEPTHTEXTURE ) != 0 )

    if (GetConVar("mgbase_debug_vmrender"):GetInt() <= 0) then
        return
    end

    if (self.m_LastSequenceIndex == "INIT" || self:GetRenderOrigin() == nil) then
        --calcview / no anim called
        return
    end
    
    local w = self:GetOwner()

    if (!IsValid(w) || !w:IsCarriedByLocalPlayer()) then
        return
    end
    
    if (IsValid(w:GetOwner())) then
        w:GetOwner():DrawViewModel(false)
    end
    
    render.SetColorModulation(1, 1, 1)
    if !isDepthPass then
        drawCustomizationBackground()
    end

    self:DrawShadow(false)

    self.bRendering = true
    self:SetupBones() --makes velements and vmanip work
    self.bRendering = false

    if (!isCustomizing()) then
        self:SetNoDraw(false)
        drawModels(self, self, flags)

        if !isDepthPass then
            for name, particleSystem in pairs(self.m_Particles) do
                if (!particleSystem:IsValid() || particleSystem:IsFinished()) then
                    self.m_Particles[name] = nil
                    continue
                end
                    
                particleSystem:Render()
            end
        end

        --attachments
        local atts = w:GetAllAttachmentsInUse()
            
        for slot = #atts, 1, -1 do
            if (IsValid(atts[slot].m_Model)) then
                atts[slot]:Render(w, atts[slot].m_Model, flags)
            end
        end
        
        if !isDepthPass then
            self:SetNoDraw(true)
        end
    else
        --self.m_CHands:SetNoDraw(false)
        self.m_CHands:DrawModel(flags)
        --self.m_CHands:SetNoDraw(true)
        drawCustomizationHighlights(self, flags, MWBASE_STENCIL_REFVALUE + 17)
    end
    
    for shell, _ in pairs(self.m_Shells) do
        if (!IsValid(shell)) then
            self.m_Shells[shell] = nil
            continue
        end
        
        shell:DrawModel(flags)
    end

    if !isDepthPass then
        self:ViewBlur()
    end

    if (IsValid(w:GetOwner())) then
        w:GetOwner():DrawViewModel(true)
    end
end

local function drawBlurModels(model, flags)
    local children = model:GetChildren()

    --if (shouldDrawModel(model, children)) then
        model:RemoveEFlags(EFL_USE_PARTITION_WHEN_NOT_SOLID)
        model:DrawModel(flags)
    --end

    for i, c in pairs(children) do
        drawBlurModels(c, flags) --this is gonna get out of hand eventually
    end
end

local blurMaterial = Material("mg/blur.vmt")
ENT.LerpBlur = 0
function ENT:ViewBlur()
    local w = self:GetOwner()

    if (!IsValid(w)) then
        return
    end

    local bPixelShaders2 = render.SupportsPixelShaders_2_0()

    if (!bPixelShaders2) then
        return
    end

    if (GetConVar("mgbase_fx_blur"):GetInt() != 1) then return end

    if (w.DisableReloadBlur && w:HasFlag("Reloading")) then return end

    local bOpticAim = (w:GetAimDelta() > 0 && w:GetSight() != nil && w:GetSight().Optic != nil && w:GetAimModeDelta() <= w.m_hybridSwitchThreshold  && w:GetTacStanceDelta() <= w.m_hybridSwitchThreshold)
    local bCanBlur = w:HasFlag("Reloading") || w:HasFlag("Customizing") || bOpticAim || w:HasFlag("Inspecting")

    if (bCanBlur) then
        local delta = 1 - w:GetAimDelta()

        if (bOpticAim) then
            delta = w:GetAimDelta() 
        end

        self.LerpBlur = Lerp(5 * FrameTime(), self.LerpBlur, 5 * delta)

        render.SetStencilWriteMask(0xFF)
        render.SetStencilTestMask(0xFF)
        render.SetStencilReferenceValue(0)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilReferenceValue(MWBASE_STENCIL_REFVALUE + 13)
        render.SetStencilCompareFunction(STENCIL_NEVER)
        render.SetStencilFailOperation(STENCIL_REPLACE)
        render.SetBlend(0)

            if (w:GetAimDelta() < 1) then
                drawBlurModels(self, flags)
            elseif (w:GetSight() != nil && IsValid(w:GetSight().hideModel)) then
                w:GetSight().m_Model:SetupBones()
                w:GetSight().m_Model:InvalidateBoneCache()
                local matrix = w:GetSight().m_Model:GetBoneMatrix(0)

                w:GetSight().hideModel:SetPos(matrix:GetTranslation())
                w:GetSight().hideModel:SetAngles(matrix:GetAngles())

                w:GetSight().hideModel:DrawModel()
            end
        render.SetBlend(1)
        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
            cam.Start2D()
                for i = 1, self.LerpBlur, 1 do
                    render.UpdateScreenEffectTexture()
                    surface.SetMaterial(blurMaterial)
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
                end
            cam.End2D()
        render.SetStencilEnable(false)
        render.ClearStencil()
    else
        self.LerpBlur = 0
    end
end