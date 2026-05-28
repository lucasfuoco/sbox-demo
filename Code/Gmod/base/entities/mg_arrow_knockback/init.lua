AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_mag_firebolt.mdl")
ENT.AoeEntity = nil

local BaseClass = baseclass.Get(ENT.Base)

function ENT:Impact(tr, phys, bHull)
    BaseClass.Impact(self, tr, phys, bHull)

    if (tr.HitSky) then
        return
    end

    self:EmitSound("MW19_Crossbow.Knockback")

    local radius = self.KnockbackRadius

    for _, e in pairs(ents.FindInSphere(tr.HitPos, radius)) do
        if ((e:IsPlayer() || e:IsNPC()) && !e:IsLineOfSightClear(tr.HitPos + tr.HitNormal * 10)) then
            continue
        end

        local force = self.KnockbackForce * (e:IsNPC() && 1.5 || 1)

        local dir = (e:WorldSpaceCenter() - tr.HitPos):GetNormalized()
        local curVel = e:GetVelocity()
        e:SetVelocity(Vector(curVel.x, curVel.y, 200) + dir * force)
    end
end