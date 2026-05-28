
ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.ExplosionRadius = 430
ENT.ExplosionDamage = 700

game.AddParticles("particles/explosion_fx_ins.pcf")
game.AddParticles("particles/ins_rockettrail.pcf")
PrecacheParticleSystem("ins_C4_explosion")
PrecacheParticleSystem("ins_grenade_explosion")
PrecacheParticleSystem("ins_m203_explosion")
PrecacheParticleSystem("ins_rpg_explosion")
PrecacheParticleSystem("rockettrail")

function ENT:SetupDataTables()
end
 
--[[---------------------------------------------------------
	Name: Initialize
	Desc: First function called. Use to set up your entity
-----------------------------------------------------------]]

function ENT:Initialize()
	self:SetModel("models/viper/mw/weapons/w_juliet_rocket.mdl")
	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:SetCustomCollisionCheck(true)

	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:GetPhysicsObject():SetMaterial("metal")
		self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
		self:GetPhysicsObject():EnableDrag(false)
		self:GetPhysicsObject():EnableGravity(false)
		self:GetPhysicsObject():Wake()

		self.Projectile = table.Copy(self.Weapon.Projectile)
		self.WeaponData = self.Weapon:GetTable()

		self.m_Propel = true
		self.m_Fuel = self.Projectile.Fuel
		self.m_Stability = 0
		self.m_Water = false
		self.m_State = "Ascent"
		self.LastPos = self:GetOwner():EyePos()
		self.Target = ents.Create("info_target")
		self.Target:Spawn()

		local up = self:GetPos()
		up.z = up.z + 2000

		local tr = util.TraceLine( {
			start = self:GetPos(),
			endpos = up,
			filter = {self,self:GetOwner()}
		} )

		self.CruiseHeight = tr.HitPos.z - 900

		if self.WeaponData.TrackedEntity:IsValid() then 
			self.m_Tracking = self.Projectile.Tracking
			self.TrackedEntity = self.WeaponData.TrackedEntity
			self.TrackedPosition = self.WeaponData.TrackedEntity:GetPos()
		else  
			local tr = self.Weapon:GetOwner():GetEyeTrace()
			self.TrackedPosition = tr.HitPos
			self.TargetPos = tr.HitPos
		end

	end

	if (CLIENT) then
		self.m_SpawnPos = self:GetPos()
		self:EmitSound("^weapons/juliet/weap_juliet_proj_lp_01.wav", SNDLVL_180db, 100, 1, CHAN_WEAPON) 
	end
end