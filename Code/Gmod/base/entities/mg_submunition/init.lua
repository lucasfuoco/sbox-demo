AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



--[[---------------------------------------------------------
	Name: KeyValue
	Desc: Called when a keyvalue is added to us
-----------------------------------------------------------]]
function ENT:KeyValue( key, value )
end

--[[---------------------------------------------------------
	Name: OnRestore
	Desc: The game has just been reloaded. This is usually the right place
		to call the GetNW* functions to restore the script's values.
-----------------------------------------------------------]]
function ENT:OnRestore()
end

--[[---------------------------------------------------------
	Name: AcceptInput
	Desc: Accepts input, return true to override/accept input
-----------------------------------------------------------]]
function ENT:AcceptInput( name, activator, caller, data )
	return false
end

--[[---------------------------------------------------------
	Name: UpdateTransmitState
	Desc: Set the transmit state
-----------------------------------------------------------]]
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:PhysicsCollide(colData, collider)
	if (self.m_Water && self:GetVelocity():Length() < 250) then
		timer.Simple(0, function()
			self:Remove()
		end)

		return
	end

	local bHasExploded = false

	for i, e in pairs(ents.FindInSphere(self:GetPos(), 16)) do
		if (e:IsNPC()) then
			self:Explode({
				HitEntity = e, 
				HitNormal = (e:NearestPoint(self:GetPos()) - self:GetPos()):GetNormalized(), 
				HitPos = e:NearestPoint(self:GetPos())
			})

			bHasExploded = true
		end
	end

	if (!bHasExploded) then
		self:Explode(colData)
	end
end

function ENT:PhysicsUpdate(phys)

		self.m_Fuel = self.m_Fuel - 100 * FrameTime()
		self.m_Stability = self.m_Stability + 700 * FrameTime()
		
		if (self.m_Propel && self.m_Fuel <= 0) then
			self.m_Propel = false
			phys:EnableDrag(true)
			phys:EnableGravity(true)
			phys:AddVelocity(phys:GetAngles():Forward() * self.Speed)
		end
		
		if (self.m_Propel) then

			phys:SetPos(self.LastPos + phys:GetAngles():Forward() * (self.Speed * FrameTime()))

			if self.TrackedEntity && self.TrackedEntity:IsValid() then
				local dir = self.TrackedEntity:WorldSpaceCenter() - phys:GetPos()
				phys:SetAngles(LerpAngle(0.1, phys:GetAngles(), dir:Angle()))
			else
				self.m_Fuel = 0
			end

		end

	if (!self.bCollided) then
		--Aim assist
		if (GetConVar("mgbase_debug_projectiles"):GetInt() > 0) then
			debugoverlay.Box(phys:GetPos(), -self.Maxs, self.Maxs, 0, Color(0, 200, 50, 10))
		end

		local trData = {
			start = self.LastPos,
			endpos = phys:GetPos(),
			filter = {self:GetOwner(), self},
			mask = MASK_SHOT_PORTAL,
			collisiongroup = COLLISION_GROUP_NONE,
			mins = -self:OBBMaxs(),
			maxs = self:OBBMins()
		}

		local tr = util.TraceHull(trData)

		if (tr.Hit && (tr.Entity:IsPlayer() || tr.Entity:IsNPC())) then
			self:SetPos(tr.HitPos)
			self:Explode(tr)
			return
		end

		--Normal hitscan
		if (GetConVar("mgbase_debug_projectiles"):GetInt() > 0) then
			debugoverlay.Line(self.LastPos, phys:GetPos(), 1, Color(255, 0, 0, 1))
		end
		
		tr = util.TraceLine(trData)

		if (tr.Hit) then
			if tr.Entity:GetClass() == "func_breakable_surf" then 
				--shatter glass windows and other weak surfaces
				util.BlastDamage(self, self, tr.HitPos, 1, 1)
			elseif tr.Entity:GetClass() != self:GetClass() && tr.Entity:GetClass() != "mg_javelin_airstrike_warhead" then
				self:SetPos(tr.HitPos)
				self:Explode(tr) 
				return
			end
		end
	end

	self.LastPos = phys:GetPos()
end

function ENT:Explode(trData)

	local phys = self:GetPhysicsObject()
	if (self:WaterLevel() <= 0) then
		ParticleEffect("Generic_explo_mid", phys:GetPos() + trData.HitNormal,Angle(0,0,0))
	else
		local effectdata = EffectData()
		effectdata:SetOrigin(phys:GetPos())
		util.Effect("WaterSurfaceExplosion", effectdata)
	end

	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage(self.Damage)
	dmgInfo:SetAttacker(IsValid(self:GetOwner()) && self:GetOwner() || self)
	dmgInfo:SetInflictor(self)
	dmgInfo:SetDamageType(self:GetDamageType())
	util.BlastDamageInfo(dmgInfo, phys:GetPos(), 190)

	util.ScreenShake(phys:GetPos(), 3500, 1111, 1, 300)

	util.Decal("Scorch", trData.HitPos - trData.HitNormal, trData.HitPos + trData.HitNormal, self)

	for i, e in pairs(ents.FindInSphere(self:GetPos(), 32)) do
		if (e:GetClass() == "npc_strider") then
			e:Fire("Explode")
		end 
	end

	self:Remove()
end

function ENT:ImpactDamage(ent) 

end

function ENT:GetDamageType() 
	return DMG_BLAST + DMG_AIRBOAT
end