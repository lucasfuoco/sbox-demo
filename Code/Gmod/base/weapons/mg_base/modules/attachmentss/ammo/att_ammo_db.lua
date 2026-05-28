ATTACHMENT.Base = "att_ammo"
ATTACHMENT.Name = "Dragons Breath"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo870/icon_attachment_sh_romeo870_caldb.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:OnImpact(weapon, dmgInfo, tr)
    BaseClass.OnImpact(self, weapon, dmgInfo, tr)

    if (SERVER && table.HasValue(weapon.FireSurfaces, tr.MatType)) then
        tr.Entity:Ignite(2)
    end

    ParticleEffect(self.Particle || "mwb_db_impact_effect", tr.HitPos, tr.HitNormal:Angle())
    util.Decal("dark", tr.HitPos + tr.HitNormal, tr.HitPos - (tr.HitNormal * 1), {weapon, weapon:GetOwner()})
    weapon:MakeLight(tr.HitPos, Color(255, 50, 0), 2, CurTime() + 1)

    dmgInfo:SetDamageType(dmgInfo:GetDamageType() + DMG_BURN + DMG_SLOWBURN)
end

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon:doDBStats()
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon.Projectile = nil
    weapon.ParticleEffects.MuzzleFlash = "mwb_muzzle_sg_3"
end