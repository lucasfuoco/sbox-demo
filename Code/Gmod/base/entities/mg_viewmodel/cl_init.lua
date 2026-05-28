include("client/cl_animation.lua")
include("client/cl_calcview.lua")
include("client/cl_render.lua")
include("client/cl_events.lua")
include("shared.lua")
require("mw_utils")

ENT.m_Particles = {}
ENT.m_Shells = {}

function ENT:CreateRig()
    if (table.IsEmpty(MW_RIGS)) then
        return
    end

    local k, v = next(MW_RIGS)

    if (v == nil) then
        return
    end

    self.m_Rig = ClientsideModel(v.Model, self.RenderGroup)
    self.m_Rig:SetRenderMode(self.RenderMode)
    self.m_Rig:AddEffects(EF_BONEMERGE)
    self.m_Rig:AddEffects(EF_BONEMERGE_FASTCULL)
    self.m_Rig:AddEffects(EF_PARENT_ANIMATES)
    self.m_Rig:SetParent(self)

    function self.m_Rig:CanDraw()
        if (self:GetNoDraw()) then
            return false
        end

        if (gmod.GetGamemode().ForcePlayerHands) then
            return false
        end

        local rig = MW_RIGS[GetConVar("mgbase_rig"):GetString()]

        if (rig == nil) then
            return false
        end

        return true
    end

    function self.m_Rig:RenderOverride(flags)
        if (!self:CanDraw()) then
            return
        end

        self:SetModel(MW_RIGS[GetConVar("mgbase_rig"):GetString()].Model)
        self:SetSkin(GetConVar("mgbase_rig_skin"):GetInt())
        --self:DrawModel(flags)
        --gloves draw the arms as well
    end

    mw_utils.DealWithFullUpdate(self.m_Rig)
end

function ENT:CreateGloves()
    if (table.IsEmpty(MW_GLOVES)) then
        return
    end

    local k, v = next(MW_GLOVES)

    if (v == nil) then
        return
    end

    self.m_Gloves = ClientsideModel(v.Model, self.RenderGroup)
    self.m_Gloves:SetRenderMode(self.RenderMode)
    self.m_Gloves:AddEffects(EF_BONEMERGE)
    self.m_Gloves:AddEffects(EF_BONEMERGE_FASTCULL)
    self.m_Gloves:AddEffects(EF_PARENT_ANIMATES)
    self.m_Gloves:SetParent(self.m_Rig)

    function self.m_Gloves:CanDraw()
        if (self:GetNoDraw()) then
            return false
        end

        if (gmod.GetGamemode().ForcePlayerHands) then
            return false
        end
        
        local rig = MW_RIGS[GetConVar("mgbase_rig"):GetString()]
        local gloves = MW_GLOVES[GetConVar("mgbase_gloves"):GetString()]
        
        if (gloves == nil || rig == nil) then
            --checks rig as well since it draws it
            return false
        end

        return true
    end

    function self.m_Gloves:RenderOverride(flags)
        if (!self:CanDraw()) then
            return
        end

        self:SetModel(MW_GLOVES[GetConVar("mgbase_gloves"):GetString()].Model)
        self:SetSkin(GetConVar("mgbase_gloves_skin"):GetInt())
        self:DrawModel(flags)
    end

    mw_utils.DealWithFullUpdate(self.m_Gloves)
end

function ENT:CreateCHands()
    self.m_CHands = ClientsideModel(Model("models/weapons/c_arms_hev.mdl"), self.RenderGroup)
    self.m_CHands:SetRenderMode(self.RenderMode)
    self.m_CHands:AddEffects(EF_BONEMERGE)
    self.m_CHands:AddEffects(EF_BONEMERGE_FASTCULL)
    self.m_CHands:AddEffects(EF_PARENT_ANIMATES)
    self.m_CHands:SetParent(self)

    function self.m_CHands:CanDraw()
        if (self:GetNoDraw()) then
            return false
        end

        local rig = GetConVar("mgbase_rig"):GetString()

        if (rig != "chands" && !gmod.GetGamemode().ForcePlayerHands) then
            return false
        end
        
        return IsValid(LocalPlayer():GetHands())
    end

    function self.m_CHands:GetPlayerColor()
        return LocalPlayer():GetPlayerColor()
    end

    function self.m_CHands:RenderOverride(flags)
        if (!self:CanDraw()) then
            return
        end
        
        local p = LocalPlayer()

        if (VManip != nil) then
            p:GetHands():SetParent(self:GetParent())
            p:GetHands():DrawModel(flags) --for thermals
            --its a useless call outside of thermals but i dont care

            return
        end
        
        self:SetModel(p:GetHands():GetModel())
        self:SetSkin(p:GetHands():GetSkin())
        
        for b = 0, p:GetHands():GetNumBodyGroups() do
            self:SetBodygroup(b, p:GetHands():GetBodygroup(b))
        end
        
        self:DrawModel(flags)
    end

    mw_utils.DealWithFullUpdate(self.m_CHands)
end 

ENT.m_LastAnim = -1

function ENT:PlaySequence(anim, rate, cycle)
    rate = rate || 1
    cycle = cycle || 0
    
    if (self.m_LastAnim != anim) then
        self.m_MiscGripTarget = 1
        self.m_RightHandGripTarget = 1
        self.m_LeftHandGripTarget = 1
    end

    self.m_LastAnim = anim
    self:ResetSequence(anim)
    self:SetPlaybackRate(rate)
    self:SetCycle(cycle)
end

----------------------------------------------------

net.Receive("mgbase_viewmodelanim", function(len)
    local ent = net.ReadEntity()
    local rate = net.ReadFloat() 
    local animId = net.ReadUInt(16)
    local tick = net.ReadUInt(16)

    if (!IsValid(ent)) then
        return 
    end

    ent.m_AnimFromServer = {
        Rate = rate,
        Tick = tick,
        AnimID = animId,
        TimeDifference = ent:GetOwner():IsCarriedByLocalPlayer() && LocalPlayer():Ping() / 1000 || 0
    }
end) 

hook.Add("VManipPrePlayAnim", "MW19_VManipStopActions", function()
    local ply = LocalPlayer()
    local w = ply:GetActiveWeapon()
	
	if w.Base != "mg_base" then return true end
    local currentTask = w.Tasks[w:GetCurrentTask()]
    local inOkayTask = !currentTask or (GetConVar("mgbase_sv_sprintvmanip"):GetBool() and currentTask.Flag == "Sprinting")

    if (IsValid(w) && weapons.IsBasedOn(w:GetClass(), "mg_base")) then
        return inOkayTask && w:GetViewModel().m_CHands:CanDraw()
    end
end)