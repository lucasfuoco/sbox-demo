AddCSLuaFile()

MW19_FPSHELLS = {}

function EFFECT:Init(data)
    self:SetOwner(data:GetEntity())
    self:SetModel(self.Model)
    self:SetAngles(data:GetAngles())

    local pos = data:GetOrigin()
    pos:Add(self:GetAngles():Forward() * (self.Offset.y + self:GetModelRadius()))
    pos:Add(self:GetAngles():Right() * self.Offset.x)
    pos:Add(self:GetAngles():Up() * self.Offset.z)
    self:SetPos(pos) 
    
    self:SetModelScale(self.Scale)

    self.m_Velocity = self:GetAngles():Forward()
    self.m_Velocity:Mul(self.Force * math.Rand(0.9, 1.3))
    self.m_Velocity:Add(data:GetNormal() * data:GetMagnitude())

    self.m_NextDeath = CurTime() + 1
    self.m_LastPos = self:GetPos()
    self.m_NextPos = self:GetPos()
    self.m_AnglePolarity = math.random(0, 1) == 1 && 1 || -1

    if (data:GetFlags() == 1) then
        self:SetNoDraw(true)
        self:GetOwner().m_Shells[self] = true
    end

    self.m_Timestep = self:GetDeltaTime()
end

function EFFECT:EmitSurfaceSound(tr)
    self:EmitSound(self.Sounds[tr.MatType] || self.Sounds.Default)
end

function EFFECT:OnImpact(tr)
    self:EmitSurfaceSound(tr)
    self.m_Velocity:Add(tr.HitNormal * (self.m_Velocity:Length() * 1.15))
    
    if (tr.MatType == "Water") then
        local data = EffectData()
        data:SetOrigin(self:GetPos())
        data:SetScale(1)
        util.Effect("waterripple", data)
    end
end 

function EFFECT:GetDeltaTime()
    return 0.1
end

function EFFECT:Think()
    --Collisions
    while self.m_Timestep >= self:GetDeltaTime() do
        self.m_Velocity:SetUnpacked(self.m_Velocity.x, self.m_Velocity.y, self.m_Velocity.z - (400 * self:GetDeltaTime()))

        local tr = util.TraceLine({
            start = self.m_LastPos,
            endpos = self.m_NextPos + (self.m_Velocity * self:GetDeltaTime()),
            mask = MASK_BLOCKLOS
        })

        if bit.band(util.PointContents(tr.HitPos), CONTENTS_WATER) == CONTENTS_WATER then
            tr.MatType = "Water"
            self:OnImpact(tr)
            return false
        end

        if tr.Hit then
            self:OnImpact(tr)
        end
        
        self.m_LastPos = self.m_NextPos * 1
        self.m_NextPos = tr.HitPos

        self.m_Timestep = self.m_Timestep - self:GetDeltaTime()
    end

    self.m_Timestep = self.m_Timestep + FrameTime()

    --Interpolation
    local delta = self.m_Timestep / self:GetDeltaTime()
    self:SetPos(LerpVector(delta, self.m_LastPos, self.m_NextPos))
    
    local newAngle = Angle(180,180,180) * (20 * self.m_AnglePolarity) * FrameTime()
    self:SetAngles(self:GetAngles() + newAngle)
    
    return CurTime() < self.m_NextDeath
end