ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_VIEWMODEL
ENT.RenderMode = RENDERMODE_ENVIROMENTAL
--ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
    if (!IsValid(self:GetOwner())) then
        error("Invalid weapon for viewmodel!")
    end

    self:AddEFlags(EFL_KEEP_ON_RECREATE_ENTITIES)
    self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
    self:AddEFlags(EFL_NO_THINK_FUNCTION)
    self:AddEFlags(EFL_NO_GAME_PHYSICS_SIMULATION)
    self:AddEFlags(EFL_DONTBLOCKLOS)
    self:AddEFlags(EFL_DONTWALKON)
    self:AddEFlags(EFL_NO_DISSOLVE)
    self:AddEFlags(EFL_NO_PHYSCANNON_INTERACTION)
    self:AddEFlags(EFL_NO_DAMAGE_FORCES)
    self:AddEffects(EF_NOINTERP)
    self:AddFlags(FL_NOTARGET)
    self:AddFlags(FL_DONTTOUCH)
    self:AddFlags(FL_STEPMOVEMENT)

    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:SetNotSolid(true)
    self:SetRenderMode(self.RenderMode)
    self:DrawShadow(false)
    --self:SetNoDraw(true)
    self:UseClientSideAnimation()

    local weapon = self:GetOwner()

    if (CLIENT) then
        self:DestroyShadow()
        self:InvalidateBoneCache()
        self:SetupBones()

        self:ResetSequence(0)
        self:SetCycle(0)
        self:SetPlaybackRate(1)

        self:CreateRig()
        self:CreateGloves()
        self:CreateCHands()

        self:AddCallback("BuildBonePositions", function(vm, numbones)
            if (!vm.bRendering) then
                return
            end

            --vm:GetAttachment(vm:LookupAttachment("camera"))
            local matrix = vm:GetBoneMatrix(mw_utils.LookupBoneCached(vm, "tag_camera"))
            
            if (matrix != nil) then
                local worldMatrix = Matrix()
                worldMatrix:SetTranslation(vm:GetPos())
                worldMatrix:SetAngles(vm:GetAngles())
                
                self.m_CameraAttachment = matrix:GetInverse() * worldMatrix
            end

            if (VManip != nil) then
                hook.GetTable()["PostDrawViewModel"]["VManip"](vm, vm:GetOwner():GetOwner(), vm:GetOwner()) 
            end
        end)
        
        if (VManip != nil) then
            hook.Add("VManipPostPlayAnim", self, function(self, name) 
                self:VManipPostPlayAnim(name)
            end)

            hook.Add("VManipHoldQuit", self, function(self) 
                self:VManipHoldQuit()
            end)

            hook.Add("VManipRemove", self, function(self) 
                self:VManipRemove()
            end)
        end
    end

    self.m_LastSequenceIndex = "INIT"
    self.m_Tick = 0
    
    --old compatibility
    --weapon.m_ViewModel = self
end

function ENT:GetAnimID(weaponSequenceIndex)
    local id = 0

    for index, _ in SortedPairs(self:GetOwner().Animations) do
        id = id + 1

        if (string.lower(index) == string.lower(weaponSequenceIndex)) then
            return id
        end
    end

    return -1
end

function ENT:GetSequenceIndexByID(animId)
    local id = 0

    for index, _ in SortedPairs(self:GetOwner().Animations) do
        id = id + 1

        if (id == animId) then
            return index
        end
    end

    return nil
end

function ENT:GetPlayerOwner()
    if (IsValid(self:GetOwner())) then
        return self:GetOwner():GetOwner()
    end

    return NULL
end

function ENT:GetWeaponOwner()
    return self:GetOwner()
end

function ENT:OnRemove()
    if (IsValid(self.m_Rig)) then self.m_Rig:Remove() end
    if (IsValid(self.m_Gloves)) then self.m_Gloves:Remove() end
    if (IsValid(self.m_CHands)) then self.m_CHands:Remove() end
end

function ENT:PlayAnimation(weaponSequenceIndex, bNoTick) --"Holster", "Draw", ...
    local weapon = self:GetOwner()
    self.m_LastSequenceIndex = weaponSequenceIndex

    if (!bNoTick) then
        self.m_Tick = self.m_Tick + 1
    end

    local weaponSequence = weapon:GetAnimation(weaponSequenceIndex)--self:GetOwner().Animations[weaponSequenceIndex]
    if !weaponSequence then
        return
    end
    
    local animId = self:GetAnimID(weaponSequenceIndex)
    local rate = weaponSequence.Fps / 30

    if (CLIENT) then
        local anims = weaponSequence.Sequences
        self:PlaySequence(anims[math.random(1, #anims)], rate)
    end

    if (SERVER) then
        net.Start("mgbase_viewmodelanim", true)
            net.WriteEntity(self)
            net.WriteFloat(rate)
            net.WriteUInt(animId, 16)
            net.WriteUInt(self.m_Tick, 16)
        net.Broadcast() 
    end
end

function ENT:UpdateAnimation()
    local cycle = self:GetCycle()
    self:PlayAnimation(self.m_LastSequenceIndex, true)
    self:SetCycle(cycle)
end