AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ExplosionRadius = 256

function ENT:Initialize()
    self:SetModel("models/dav0r/hoverball.mdl")
    --[[self:PhysicsInit(SOLID_VPHYSICS)
    self:GetPhysicsObject():EnableMotion(false)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)]]
    self:SetLifeTime(1.5)
    self:AddFlags(FL_GRENADE)
    self:AddFlags(FL_ONFIRE)
    self.nextBeep = self:GetLifeTime()
end 

function ENT:Think()
    if (IsValid(self:GetParent()) && self:GetParent():Health() <= 0 && self:GetParent():GetMaxHealth() > 1) then
        self:Explode()
        self:Remove()
        return
    end

    self:SetLifeTime(self:GetLifeTime() - FrameTime())

    if (self:GetLifeTime() > 0.1 && self:GetLifeTime() <= self.nextBeep) then
        sound.EmitHint(SOUND_DANGER, self:GetPos(), self.ExplosionRadius * 2, 1, nil) --make shit run away (nil owner so even rebels run)
        self.nextBeep = self:GetLifeTime() * 0.75
        
        local effectData = EffectData()
        effectData:SetEntity(self)
        effectData:SetOrigin(self:GetPos())

        util.Effect("mwb_semtex", effectData)
    end

    if (self:GetLifeTime() <= 0) then
        self:Explode()
        self:Remove()
    end

    self:NextThink(CurTime())
    return true
end

function ENT:Explode()
    self:EmitSound("MW.ExplosionGrenade")

    local dmgInfo = DamageInfo()
    dmgInfo:SetAttacker(self:GetOwner())
    dmgInfo:SetDamage(150)
    dmgInfo:SetDamageType(DMG_BLAST + DMG_AIRBOAT)
    dmgInfo:SetInflictor(self)
    util.BlastDamageInfo(dmgInfo, self:GetPos(), self.ExplosionRadius)

    local ed = EffectData()
	ed:SetOrigin(self:GetPos())
	ed:SetStart(self:GetPos() + self:GetUp())
	ed:SetRadius(512)
	ed:SetEntity(self)
	util.Effect("mwb_grenade_explosion", ed)

    if (IsValid(self.arrow)) then
        self.arrow:Remove()
    end
end