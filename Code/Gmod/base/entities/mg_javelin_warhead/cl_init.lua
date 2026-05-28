include("shared.lua")

ENT.AutomaticFrameAdvance = true


local flair = Material("shadowdark/flairs/grenade_flair.vmt")
ENT.OuterFlairColor = Color(236,153,17,255)
ENT.InnerFlairColor = Color(255,255,255,255)

ENT.OuterFlairScale = 1
ENT.InnerFlairScale = 0.3

function ENT:Draw(flags)
	self:DrawModel(flags)

	if (self.m_SpawnPos != nil && self:GetPos():Distance(self.m_SpawnPos) > 64) then
		ParticleEffectAttach("rockettrail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		self.m_SpawnPos = nil
	end

	local ang = LocalPlayer():EyeAngles()
    local angle = Angle( 0, LocalPlayer():EyeAngles()[2], 0 )

    angle = Angle(LocalPlayer():EyeAngles()[1], angle.y, 0 )
       
    angle:RotateAroundAxis( angle:Up(), -90 )
    angle:RotateAroundAxis( angle:Forward(), 90 )

	cam.Start3D2D( self:GetPos() - self:GetForward() * 20, angle, 0.2 )

	local OuterScale = 512 * self.OuterFlairScale
	local InnerScale = 512 * self.InnerFlairScale

	surface.SetMaterial(flair)
	surface.SetDrawColor(self.OuterFlairColor)
	surface.DrawTexturedRect(-OuterScale/2, -OuterScale/2, OuterScale, OuterScale)

	surface.SetDrawColor(self.InnerFlairColor)
	surface.DrawTexturedRect(-InnerScale/2, -InnerScale/2, InnerScale, InnerScale)
cam.End3D2D()

end

function ENT:DrawTranslucent(flags)
	self:Draw(flags)
end

function ENT:OnRemove()
	if (self:WaterLevel() <= 0) then
		self:EmitSound("^viper/shared/rocket_expl_env_0"..math.random(1, 3)..".wav", 150, 100, 1, CHAN_WEAPON) --snd scripts dont work lol!

		local dlight = DynamicLight(self:EntIndex())
		if (dlight) then
			dlight.pos = self:GetPos()
			dlight.r = 255
			dlight.g = 75
			dlight.b = 0
			dlight.brightness = 5
			dlight.Decay = 2000
			dlight.Size = 1024
			dlight.DieTime = CurTime() + 5
		end
	end
	
	self:StopParticles()
end

--[[---------------------------------------------------------
	Name: Think
	Desc: Client Think - called every frame
-----------------------------------------------------------]]
function ENT:Think()
	if (self:WaterLevel() > 0) then
		self:EmitSound("viper/shared/melee/melee_world_fist_soft_plr_01.ogg", 75, 100, 0.001, CHAN_WEAPON)
		self:StopParticles()
	end
end

--[[---------------------------------------------------------
	Name: OnRestore
	Desc: Called immediately after a "load"
-----------------------------------------------------------]]
function ENT:OnRestore()
end
