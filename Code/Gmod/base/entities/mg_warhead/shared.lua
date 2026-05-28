
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
PrecacheParticleSystem("Generic_explo_vhigh")

function ENT:SetupDataTables()
end
 
--[[---------------------------------------------------------
	Name: Initialize
	Desc: First function called. Use to set up your entity
-----------------------------------------------------------]]

function ENT:Initialize()


	if (SERVER) then
		self.Projectile = table.Copy(self.Weapon.Projectile)
		self.WeaponData = self.Weapon:GetTable()

		if !self.Projectile.Model then
			self:SetModel("models/viper/mw/weapons/w_rpapa7_rocket.mdl") 
		else 
			self:SetModel(self.Projectile.Model) 
		end
		self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
		--self:SetCustomCollisionCheck(true)
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:GetPhysicsObject():SetMaterial("metal")
		self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
		self:GetPhysicsObject():EnableDrag(false)
		self:GetPhysicsObject():EnableGravity(false)
		self:GetPhysicsObject():Wake()


		self.m_Propel = true
		self.m_Fuel = self.Projectile.Fuel
		self.m_Stability = 0
		self.m_TargetLostTime = 0
		self.m_Water = false
		self.LastPos = self:GetOwner():EyePos()
		self.Target = ents.Create("info_target")
		self.Target:Spawn()

		if self.WeaponData.TrackedEntity then 
			self.m_Tracking = self.Projectile.Tracking
			self.TrackedEntity = self.WeaponData.TrackedEntity
		end
	end

	if (CLIENT) then
		self.m_SpawnPos = self:GetPos()
		self:EmitSound("^viper/shared/move_rpapa7_proj_flame_cls.wav", SNDLVL_180db, 100, 1, CHAN_WEAPON) 
	end
end