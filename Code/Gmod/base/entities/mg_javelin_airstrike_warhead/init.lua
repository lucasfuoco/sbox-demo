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

--[[---------------------------------------------------------
	Name: Think
	Desc: Entity's think function.
-----------------------------------------------------------]]
function ENT:Think()
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

			if (e:GetClass() == "npc_strider") then
				e:Fire("Explode")
			end

			bHasExploded = true
		end
	end

	if (!bHasExploded) then
		self:Explode(colData)
	end
end

local function WithinRange(num,min,max) 
	return num < max && num > min
end

function ENT:PhysicsUpdate(phys)

		self.Target:SetPos(phys:GetPos())

		debugoverlay.Cross( self.TrackedPosition, 30, 1, Color( 255, 255, 255 ), true )

		self.m_Fuel = self.m_Fuel - 100 * FrameTime()
		
		if (self.m_Propel && self.m_Fuel <= 0) then
			self.m_Propel = false
			phys:EnableDrag(true)
			phys:EnableGravity(true)
			phys:AddVelocity(phys:GetAngles():Forward() * self.Projectile.Speed)
		end
		
		if (self.m_Propel) then

			if self.TrackedEntity && self.TrackedEntity:IsValid() then 
				self.TargetPos = self.TrackedEntity:GetPos()
			else 
				--self.TrackedPosition = self.WeaponData.TrackedPosition
			end

			phys:SetPos(self.LastPos + phys:GetAngles():Forward() * (self.Projectile.Speed * FrameTime()) - (Vector(0, 0, self.m_gravity) * FrameTime()))

			if (self.m_State == "Ascent") then
				local angle = phys:GetAngles()
				angle.p = math.Clamp(angle.p - 6, -89, 89)
				phys:SetAngles(angle)
				if self:GetPos().z >= self.CruiseHeight then
					self.m_State = "Cruise"
				end
			elseif (self.m_State == "Cruise") then
				local range = 1100
				local angle = phys:GetAngles()
				angle.p = math.Clamp(angle.p + 2, -90,-0)
				phys:SetAngles(angle)
				if WithinRange(phys:GetPos().x,self.TrackedPosition.x - range,self.TrackedPosition.x + range) && WithinRange(phys:GetPos().y,self.TrackedPosition.y - range,self.TrackedPosition.y + range) then 
					self:Explode()
				end
			end

		else 
			local vel = phys:GetVelocity()
			phys:SetAngles(vel:Angle() + Angle(self.Projectile.Gravity,math.Rand(self.m_Stability / -self.Projectile.Stability, self.m_Stability / self.Projectile.Stability),self.m_gravity))
			phys:SetVelocity(vel)
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

			if (tr.Entity:GetClass() == "npc_strider") then
				tr.Entity:Fire("Explode")
			elseif tr.Entity:GetClass() != self:GetClass() && tr.Entity:GetClass() != "mg_javelin_airstrike_warhead" then
				local dmg = DamageInfo()
				dmg:SetDamage(1)
				dmg:SetAttacker(self:GetOwner())
				dmg:SetInflictor(self)
				tr.Entity:TakeDamageInfo(dmg)
			end

			return
		end

		--Normal hitscan
		if (GetConVar("mgbase_debug_projectiles"):GetInt() > 0) then
			debugoverlay.Line(self.LastPos, phys:GetPos(), 1, Color(255, 0, 0, 1))
		end
		
		tr = util.TraceLine(trData)

		if (tr.Hit) then
			self:SetPos(tr.HitPos)
			self:Explode(tr)
			return
		end
	end

	self.LastPos = phys:GetPos()
end

function ENT:Explode()

	local phys = self:GetPhysicsObject()
	if (self:WaterLevel() <= 0) then
		ParticleEffect("Generic_explo_high", phys:GetPos(),Angle(0,0,0))
	else
		local effectdata = EffectData()
		effectdata:SetOrigin(phys:GetPos())
		util.Effect("WaterSurfaceExplosion", effectdata)
	end

	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage(50)
	dmgInfo:SetAttacker(IsValid(self:GetOwner()) && self:GetOwner() || self)
	dmgInfo:SetInflictor(self)
	dmgInfo:SetDamageType(self:GetDamageType())
	util.BlastDamageInfo(dmgInfo, phys:GetPos(), self.WeaponData.Explosive.BlastRadius)

	util.ScreenShake(phys:GetPos(), 3500, 1111, 1, self.WeaponData.Explosive.BlastRadius * 4)


	--release submunitions

	for i = 1,12,1 do
		local ent = ents.Create("mg_submunition")
		ent:SetPos(self:GetPos())
		ent:SetAngles(AngleRand())
		ent.LastPos = self:GetPos()
		ent:SetOwner(self:GetOwner())
		ent.Damage = self.WeaponData.Bullet.Damage[1] / 12

		if self.TrackedEntity then 
			ent.TrackedEntity = self.TrackedEntity
		else 
			local ents = ents.FindInSphere(self.TrackedPosition, 1000)
			local targets = {}
			for k,v in pairs(ents) do 
				if v:IsNPC() || v:IsPlayer() || v:IsVehicle() then 
					table.insert(targets, v)
				end
			end
			if targets[1] then
				ent.TrackedEntity = targets[math.random(1, #targets)] 
			end
		end

		timer.Simple(i/50, function() 
			ent:Spawn() 
		end)
	end

	self:Remove()
end

function ENT:GetDamageType() 
	return DMG_BLAST + DMG_AIRBOAT
end