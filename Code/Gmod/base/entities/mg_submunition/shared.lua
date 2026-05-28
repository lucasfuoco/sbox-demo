
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
	self:SetModel("models/items/ar2_grenade.mdl")
	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:SetCustomCollisionCheck(true)

	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:GetPhysicsObject():SetMaterial("metal")
		self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
		self:GetPhysicsObject():EnableDrag(false)
		self:GetPhysicsObject():EnableGravity(false)
		self:GetPhysicsObject():Wake()

		self.m_Propel = true
		self.m_Fuel = 300
		self.m_Stability = 0
		self.m_Water = false
		self.Target = ents.Create("info_target")
		self.Target:Spawn()
 
		self.m_Tracking = true

		self.Speed = math.random(1000, 1700)
	end

	if (CLIENT) then
		self.m_SpawnPos = self:GetPos()
		self:EmitSound("^viper/shared/move_rpapa7_proj_flame_cls.wav", SNDLVL_180db, 100, 1, CHAN_WEAPON) 
	end
end