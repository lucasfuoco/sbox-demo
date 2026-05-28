AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize() 
    self:SetModel("models/items/grenadeammo.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetColor(Color(0,0,0))

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then

        phys:Wake()

    end

    self.DetonationTime = self.FuseTime + CurTime()

    self:Throw()

end


function ENT:PhysicsCollide( data, phys )
    if data.Speed > 40 then
        self:EmitSound("equipment/mike67/phy_frag_bounce_concrete_med_0"..math.random(1,8).."_ext.ogg",75, 100, math.Remap(data.Speed, 40, 80, 0, 1), CHAN_AUTO) 
    end
end

function ENT:Think() 
    
    if self.DetonationTime <= CurTime() then 
        self:Explode()
    end
    
end

function ENT:Explode() 
    ParticleEffect( "Generic_explo_high", self:GetPos(), Angle(0,0,0))
    util.BlastDamage(self, self:GetOwner(), self:GetPos(), 475, 640)
    util.ScreenShake(self:GetPos(), 8, 3, 1, 700)
    self:EmitSound("^viper/shared/frag_expl.ogg", 0, 100, 1, CHAN_WEAPON)
    util.Decal( "Scorch", self:GetPos(), self:GetPos() + Vector(0, 0, -10), {self})
    self:Remove() 
end

function ENT:Throw() 
    local phys = self:GetPhysicsObject()
    phys:SetVelocity(self:GetOwner():GetAimVector() * 3000)
    phys:ApplyTorqueCenter( VectorRand( -3, 3) )
end