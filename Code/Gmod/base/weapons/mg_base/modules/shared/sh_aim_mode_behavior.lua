AddCSLuaFile()

function SWEP:CanChangeAimMode()
    return true
end

function SWEP:GetHybrid()
    if !self:GetSight() then
        return false
    end

    return self:GetSight().ReticleHybrid
end

function SWEP:CanTacStance()
    return self.Cone.TacStance
        && GetConVar("mgbase_sv_tacstance"):GetBool()
        && self:HasFlag("Aiming")
        && !self:GetHybrid()
        && !self:HasFlag("UsingUnderbarrel")
end

function SWEP:TacStance()
    if !self:CanTacStance() then return end
    
    if self:HasFlag("TacStance") then
        self:RemoveFlag("TacStance")
        self:EmitSound("Canted.On")
    else
        self:AddFlag("TacStance")
        self:EmitSound("Canted.Off")
    end
end

function SWEP:TacStanceLogic()
    local speed = 1 / self:GetAnimLength("Ads_Out");

    if self:HasFlag("TacStance") then
        self:SetTacStanceDelta(math.min(self:GetTacStanceDelta() + speed * FrameTime(), 1))
    else
        self:SetTacStanceDelta(math.max(self:GetTacStanceDelta() - speed * FrameTime(), 0))
    end
end