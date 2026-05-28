AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.bCollided = false
ENT.Projectile = {
	Class = "mg_bullet",
	Speed = 4000,
	Gravity = 1
}
ENT.Maxs = Vector(1, 1, 1)
ENT.Model = Model("models/items/ar2_grenade.mdl")
ENT.AoeEntity = nil

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInitBox(Vector(-10, -1, -1), Vector(10, 1, 1))
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():SetMaterial("default_silent")
	self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
	self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	self:GetPhysicsObject():AddGameFlag(FVPHYSICS_HEAVY_OBJECT)
	self:GetPhysicsObject():EnableMotion(true)
	self:GetPhysicsObject():EnableDrag(false)
	self:GetPhysicsObject():SetMass(1000)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) --doesn't collide with anything, no traces
	self:AddEFlags(EFL_NO_DAMAGE_FORCES)
	self:AddEFlags(EFL_DONTWALKON)
	self:AddEFlags(EFL_DONTBLOCKLOS)
	self:AddEFlags(EFL_NO_PHYSCANNON_INTERACTION)

	self.Projectile = table.Copy(self.Weapon.Projectile)
	self:GetPhysicsObject():SetVelocityInstantaneous(self:GetAngles():Forward() * self.Projectile.Speed)
	self.LastPos = self:GetOwner():EyePos()
	self.Bullet = self.Weapon.Bullet
	self.ImpactDamage = self.Weapon.Explosive.ImpactBlastRatio
	self.BlastRadius = self.Weapon.Explosive.BlastRadius
end

ENT.m_gravity = 0

function ENT:PhysicsUpdate(phys)
	if (!phys:IsMotionEnabled()) then
		return
	end

	self.m_gravity = math.Clamp(self.m_gravity + (self.Projectile.Gravity), -90, 90)

	phys:SetAngles(phys:GetAngles() + Angle(self.m_gravity, 0, 0) * FrameTime())
	phys:SetPos(self.LastPos + phys:GetAngles():Forward() * (self.Projectile.Speed * FrameTime()))
	
	--Aim assist
	if (GetConVar("mgbase_debug_projectiles"):GetInt() > 0) then
		debugoverlay.Box(phys:GetPos(), -self.Maxs, self.Maxs, 0, Color(0, 200, 50, 10))
	end

	local trData = {
		start = self.LastPos,
		endpos = phys:GetPos(),
		filter = {self:GetOwner(), self},
		collisiongroup = COLLISION_GROUP_NONE,
		mins = -self.Maxs,
		maxs = self.Maxs
	}

	local tr = util.TraceHull(trData)

	if (tr.Hit && (tr.Entity:IsPlayer() || tr.Entity:IsNPC())) then
		self:Impact(tr, phys, true)
		return
	end

	--Normal hitscan
	if (GetConVar("mgbase_debug_projectiles"):GetInt() > 0) then
		debugoverlay.Line(self.LastPos, phys:GetPos(), 1, Color(255, 0, 0, 1))
	end

	tr = util.TraceLine(trData)

	if (tr.Hit) then
		self:Impact(tr, phys, false)
		return
	end

	self.LastPos = phys:GetPos()
end
 
function ENT:Impact(tr1, phys, bHull)
	phys:EnableMotion(false)

	self:SetPos(tr1.HitPos)
	
	self:FireBullets({
		Attacker = self:GetOwner(),
		Num = 1,
		Tracer = 0,
		Src = self.LastPos,
		Dir = (phys:GetPos() - self.LastPos):GetNormalized(),
		HullSize = bHull && self.Maxs:Length() * 2 || 1,
		IgnoreEntity = self,
		Callback = function(attacker, tr, dmgInfo)
			dmgInfo:SetInflictor(IsValid(self.Weapon) && self.Weapon || self)
			dmgInfo:SetDamageType(dmgInfo:GetDamageType() + DMG_DIRECT + self:GetDamageType())

			if (IsValid(self.Weapon)) then
				self.Weapon:BulletCallback(attacker, tr, dmgInfo)
			end
		end
	})

	local dmg = DamageInfo()

	dmg:SetAttacker(self:GetOwner())
	dmg:SetInflictor(self)
	dmg:SetDamage(self.Bullet.Damage[1])
	dmg:SetDamageType(DMG_BLAST + DMG_AIRBOAT)
	dmg:SetReportedPosition(self:GetPos())

	util.BlastDamageInfo(dmg, self:GetPos(), self.BlastRadius)
	util.ScreenShake(self:GetPos(), 3500, 1111, 1, 124 * 4)

	local ed = EffectData()
	ed:SetOrigin(tr1.HitPos)
	if !tr1.Speed then
		ed:SetStart(tr1.HitPos + tr1.HitNormal) 
	else 
		ed:SetStart(tr1.HitPos - tr1.HitNormal) 
	end
	ed:SetRadius(512)
	ed:SetEntity(self)
	util.Effect("mwb_grenade_explosion", ed)

    sound.Play("MW.ExplosionGrenade", self:GetPos())

	self:Remove()
end

function ENT:GetDamageType()
	return DMG_BLAST + DMG_DIRECT
end