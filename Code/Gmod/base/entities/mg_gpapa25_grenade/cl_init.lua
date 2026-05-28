include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.m_bStartedParticle = false

function ENT:IsMoving()
	return self:GetVelocity():LengthSqr() > 0
end

function ENT:DrawTranslucent(flags)
	if (self:IsMoving()) then
		self:DrawModel(flags)
	end
end

function ENT:Think()
	if (self:WaterLevel() > 0) then
		self:StopParticles()
		self.m_bStartedParticle = true
	end

	if (self:IsMoving() && !self.m_bStartedParticle) then
		ParticleEffectAttach("40mm_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		self.m_bStartedParticle = true
	end
end