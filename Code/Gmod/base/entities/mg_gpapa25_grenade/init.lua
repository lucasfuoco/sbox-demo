AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.bCollided = false
ENT.Model = Model("models/viper/mw/attachments/ubgl/attachment_vm_ub_gpapa25_grenade.mdl")
ENT.ExplosionRadius = 256
ENT.Damage = 150
ENT.ImpactDamage = 100
ENT.Sounds = {
    Default = Sound("MW_Physics.Frag.Concrete"),
    [MAT_DIRT] = Sound("MW_Physics.Frag.Dirt"),
    [MAT_GLASS] = Sound("MW_Physics.Frag.Glass"),
    [MAT_TILE] = Sound("MW_Physics.Frag.Glass"),
    [MAT_GRASS] = Sound("MW_Physics.Frag.Grass"),
    [MAT_FOLIAGE] = Sound("MW_Physics.Frag.Grass"),
    [MAT_SLOSH] = Sound("MW_Physics.Frag.Mud"),
    [MAT_FLESH] = Sound("MW_Physics.Frag.Mud"),
    [MAT_BLOODYFLESH] = Sound("MW_Physics.Frag.Mud"),
    [MAT_ALIENFLESH] = Sound("MW_Physics.Frag.Mud"),
    [MAT_EGGSHELL] = Sound("MW_Physics.Frag.Mud"),
    [MAT_METAL] = Sound("MW_Physics.Frag.Metal"),
    [MAT_COMPUTER] = Sound("MW_Physics.Frag.Metal"),
    [MAT_GRATE] = Sound("MW_Physics.Frag.MetalGrate"),
    [MAT_SAND] = Sound("MW_Physics.Frag.Grass"),
    [MAT_SNOW] = Sound("MW_Physics.Frag.Grass"),
    [MAT_VENT] = Sound("MW_Physics.Frag.Metal"),
    [MAT_WOOD] = Sound("MW_Physics.Frag.Wood")
}
--game.AddDecal("mw40mmpunt", {"decals/bigshot2model", "decals/bigshot4model", "decals/bigshot5model"})

--ENT.m_bTrailSpawned = false

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
	self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	self:GetPhysicsObject():AddGameFlag(FVPHYSICS_HEAVY_OBJECT)
	self:GetPhysicsObject():EnableMotion(true)
	self:GetPhysicsObject():EnableDrag(false)
	self:GetPhysicsObject():SetMass(1000)
	self:SetSolid(SOLID_VPHYSICS)
	self:AddEFlags(EFL_NO_DAMAGE_FORCES)
	self:AddEFlags(EFL_DONTWALKON)
	self:AddEFlags(EFL_DONTBLOCKLOS)
	self:AddEFlags(EFL_NO_PHYSCANNON_INTERACTION)
	self:GetPhysicsObject():SetVelocityInstantaneous(self:GetAngles():Forward() * self.Projectile.Speed + Vector(0, 0, self.Projectile.Speed * 0.1))
	self:GetPhysicsObject():SetBuoyancyRatio(0)

	--[[hook.Add("OnEntityWaterLevelChanged", self, function(self, entity, old, new)
		if (new > 0 && !self.m_bTrailSpawned) then
			util.SpriteTrail(self, 0, Color(255, 255, 255, 255), false, 1, 0, 0.5, 0.5, "effects/beam001_white")
			self.m_bTrailSpawned = true
		end
	end)crashes the game]]
end

function ENT:Explode(colData)
    local dmgInfo = DamageInfo()
    dmgInfo:SetAttacker(self:GetOwner())
    dmgInfo:SetDamage(self.Damage)
    dmgInfo:SetDamageType(DMG_BLAST + DMG_AIRBOAT)
    dmgInfo:SetInflictor(self)
    util.BlastDamageInfo(dmgInfo, self:GetPos(), self.ExplosionRadius)

    sound.Play("MW.ExplosionGrenade", self:GetPos())
	
	local ed = EffectData()
	ed:SetOrigin(colData.HitPos)
	ed:SetStart(colData.HitPos - colData.HitNormal)
	ed:SetRadius(512)
	ed:SetEntity(self)
	util.Effect("mwb_grenade_explosion", ed)

	timer.Simple(0, function() self:Remove() end)
end

function ENT:PhysicsCollide(colData, collider)
	if (!self.bCollided) then
		self:StopParticles()

		if (CurTime() - self:GetCreationTime() > (self.Projectile.ArmTime || 0.2)) then
			self:Explode(colData)
		else
			timer.Simple(0, function() self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end)
			self:EmitSound(self.Sounds[util.GetSurfaceData(colData.TheirSurfaceProps).material] || self.Sounds.Default)
			self:GetPhysicsObject():SetVelocityInstantaneous(self:GetVelocity() * -0.1 + Vector(math.Rand(-30, 30), math.Rand(-30, 30), math.Rand(160, 250)))
			self:GetPhysicsObject():SetAngleVelocityInstantaneous(VectorRand() * 1300)

			self:FireBullets({
				Attacker = self,
				Damage = 0,
				Src = self:GetPos(),
				Dir = (colData.HitPos - self:GetPos()):GetNormalized(),
				HullSize = 10,
				Dist = 8,
				IgnoreEntity = self,
				Force = 0,
				Callback = function(attacker, tr, dmgInfo)
					return {
						effects = tr.Entity == colData.HitEntity,
						damage = false
					}
				end
			})
		end
		
		dmgInfo = DamageInfo()
		dmgInfo:SetAttacker(self:GetOwner())
		dmgInfo:SetDamage(self.ImpactDamage)
		dmgInfo:SetDamageType(DMG_CLUB + DMG_DIRECT)
		dmgInfo:SetInflictor(self)
		dmgInfo:SetDamageForce(self:GetAngles():Forward() * (dmgInfo:GetDamage() * 100))
		dmgInfo:SetDamagePosition(colData.HitPos)
		colData.HitEntity:TakeDamageInfo(dmgInfo)

		timer.Simple(2, function()
			if (IsValid(self)) then
				self:Remove()
			end
		end)
	end

	self.bCollided = true
end

function ENT:GetDamageType()
	return DMG_BLAST + DMG_DIRECT
end