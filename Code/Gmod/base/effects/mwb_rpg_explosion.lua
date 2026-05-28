AddCSLuaFile()

game.AddParticles("particles/generic_explosions_pak.pcf")
PrecacheParticleSystem("Generic_explo_vhigh")

EFFECT.DebrisSounds = {
    [MAT_CONCRETE] = Sound("MW_Physics.Frag.Debris.Concrete"),
    [MAT_DIRT] = Sound("MW_Physics.Frag.Debris.Dirt"),
    [MAT_GLASS] = Sound("MW_Physics.Frag.Debris.Glass"),
    [MAT_TILE] = Sound("MW_Physics.Frag.Debris.Glass"),
    [MAT_GRASS] = Sound("MW_Physics.Frag.Debris.Dirt"),
    [MAT_FOLIAGE] = Sound("MW_Physics.Frag.Debris.Dirt"),
    [MAT_SLOSH] = Sound("MW_Physics.Frag.Debris.Dirt"),
    [MAT_METAL] = Sound("MW_Physics.Frag.Debris.Metal"),
    [MAT_COMPUTER] = Sound("MW_Physics.Frag.Debris.Metal"),
    [MAT_GRATE] = Sound("MW_Physics.Frag.Debris.Metal"),
    [MAT_SAND] = Sound("MW_Physics.Frag.Debris.Sand"),
    [MAT_SNOW] = Sound("MW_Physics.Frag.Debris.Sand"),
    [MAT_VENT] = Sound("MW_Physics.Frag.Debris.Metal"),
    [MAT_WOOD] = Sound("MW_Physics.Frag.Debris.Wood")
}

function EFFECT:GetImpactPoint(data)
    return data:GetOrigin()
end

function EFFECT:GetImpactStart(data)
    return data:GetStart()
end

function EFFECT:GetImpactNormal(data)
    return (self:GetImpactPoint(data) - self:GetImpactStart(data)):GetNormalized()
end

function EFFECT:Init(data)
    local tr = util.TraceLine({
		start = self:GetImpactStart(data),
		endpos = self:GetImpactStart(data) + self:GetImpactNormal(data) * 10,
        filter = {data:GetEntity()}
	})

    local dlight = DynamicLight(data:GetEntity():EntIndex())
    
	if (dlight) then
		dlight.pos = tr.HitPos
		dlight.r = 255
		dlight.g = 75
		dlight.b = 0
		dlight.brightness = 5
		dlight.Decay = 500
		dlight.Size = 512
		dlight.DieTime = CurTime() + 6
	end

    ParticleEffect("Generic_explo_vhigh", tr.HitPos, (tr.HitNormal * -1):Angle() + Angle(270, 0, 0))

    util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, data:GetEntity())

    local shakeRadius = data:GetRadius() * data:GetRadius()
    local startDist = EyePos():DistToSqr(tr.HitPos)
    startDist = startDist - shakeRadius
    local shakeDelta = 1 - math.min(startDist / shakeRadius, 1)

    util.ScreenShake(tr.HitPos, 10 * shakeDelta, 40, 1, data:GetRadius())

	local ed = EffectData()
	ed:SetScale(5000)
	ed:SetOrigin(tr.HitPos)
	ed:SetRadius(data:GetRadius())
	ed:SetMagnitude(1000)
	ed:SetEntity(data:GetEntity())
	util.Effect("ShakeRopes", ed)

    if (tr.Hit 
        && util.GetSurfaceData(tr.SurfaceProps) != nil 
        && !tr.HitSky 
        && !tr.HitNoDraw 
        && !tr.Entity:IsPlayer() 
        && !tr.Entity:IsNPC() 
        && !tr.Entity:IsNextBot()
    ) then
        sound.Play(self.DebrisSounds[tr.MatType] || self.DebrisSounds[MAT_CONCRETE], tr.HitPos)

        if (GetConVar("mgbase_fx_debris"):GetInt() > 0 && tr.HitTexture != "**displacement**" && !(tr.Entity:IsWorld() && tr.HitBox > 0)) then
            MW19_DEBRIS_TEXTURE = tr.HitTexture -- :(

            for d = 6, 15 do
                ed = EffectData()
                ed:SetScale(math.random(1, 2))
                ed:SetOrigin(tr.HitPos + tr.HitNormal * 5)
                ed:SetNormal(tr.HitNormal)
                ed:SetMagnitude(math.Rand(500, 900))
                ed:SetSurfaceProp(tr.SurfaceProps)
                ed:SetEntity(tr.Entity)
                util.Effect("mwb_debris", ed)
            end

            MW19_DEBRIS_TEXTURE = nil
        end
    end

    self:SetNoDraw(true)
end

function EFFECT:Think()
    return false
end