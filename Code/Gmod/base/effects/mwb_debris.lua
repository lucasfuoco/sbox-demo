AddCSLuaFile()
MW19_DEBRIS_TEXTURE = nil

EFFECT.Models = {
	[MAT_CONCRETE] = {
		Model("models/props_junk/watermelon01_chunk02a.mdl"), 
		Model("models/props_junk/watermelon01_chunk02a.mdl"), 
		Model("models/props_junk/watermelon01_chunk02b.mdl")
	},
	[MAT_PLASTIC] = {
		Model("models/props_junk/watermelon01_chunk02a.mdl"), 
		Model("models/props_junk/watermelon01_chunk02a.mdl"), 
		Model("models/props_junk/watermelon01_chunk02b.mdl")
	},
	[MAT_DIRT] = {
		Model("models/props_junk/watermelon01_chunk02a.mdl"), 
		Model("models/props_junk/watermelon01_chunk02a.mdl"), 
		Model("models/props_junk/watermelon01_chunk02b.mdl")
	},
	[MAT_METAL] = {
		Model("models/props_junk/garbage_glassbottle001a_chunk03.mdl"), 
		Model("models/props_junk/garbage_glassbottle001a_chunk04.mdl"), 
		Model("models/props_junk/garbage_glassbottle003a_chunk02.mdl"),
		Model("models/props_junk/garbage_coffeemug001a_chunk02.mdl"),
		Model("models/props_c17/canisterchunk02m.mdl")
	},
	[MAT_WOOD] = {
		Model("models/props_c17/canisterchunk02l.mdl"), 
		Model("models/props_c17/canisterchunk02k.mdl"), 
		Model("models/props_c17/canisterchunk02e.mdl"),
		Model("models/props_c17/canisterchunk01m.mdl")
	},
	[MAT_GLASS] = {
		Model("models/gibs/glass_shard01.mdl"), 
		Model("models/gibs/glass_shard02.mdl"), 
		Model("models/gibs/glass_shard03.mdl"),
		Model("models/gibs/glass_shard04.mdl"),
		Model("models/gibs/glass_shard05.mdl"),
		Model("models/gibs/glass_shard06.mdl")
	}
}

function EFFECT:Init(data)
	local surfData = util.GetSurfaceData(data:GetSurfaceProp())
	local modelData = self.Models[surfData.material]

	if (modelData == nil) then
		self:SetNoDraw(true)
		self.m_nextDeathTime = 0
		return
	end

	self.m_nextDeathTime = CurTime() + math.Rand(5, 10)
	
	self:SetModel(modelData[math.random(1, #modelData)])
	self:SetModelScale(data:GetScale(), 0)
	self:SetPos(data:GetOrigin())

	self:PhysicsInit(SOLID_VPHYSICS)
	self:GetPhysicsObject():SetVelocityInstantaneous((data:GetNormal() * data:GetMagnitude()) + VectorRand() * (data:GetMagnitude() * 0.25))
	self:GetPhysicsObject():SetAngleVelocityInstantaneous(VectorRand() * 3000)

	if (IsValid(data:GetEntity()) && !data:GetEntity():IsWorld() && string.EndsWith(data:GetEntity():GetModel(), ".mdl")) then
		self:SetMaterial(data:GetEntity():GetMaterials()[1])
	else
		local mat = Material(MW19_DEBRIS_TEXTURE)
		local bTransparent = bit.band(mat:GetInt("$flags"), 2097152) == 2097152

		local newMat = CreateMaterial(mat:GetName().."_mwdebris", "VertexLitGeneric", {
			["$basetexture"] = mat:GetTexture("$basetexture"):GetName(),
			["$model"] = 1,
			["$translucent"] = bTransparent && 1 || 0
		})

		self:SetMaterial("!"..newMat:GetName())

		if (bTransparent) then
			self:SetRenderMode(RENDERMODE_TRANSCOLOR)
			self:SetColor(Color(255, 255, 255, 254))
		end
	end

	self:GetPhysicsObject():SetMaterial(surfData.name != "default" && surfData.name || "gmod_silent")
end

function EFFECT:Think()
	if (CurTime() > self.m_nextDeathTime - 1) then
		self:SetRenderFX(6)
	end

    return CurTime() < self.m_nextDeathTime
end