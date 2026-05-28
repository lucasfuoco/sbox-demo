ATTACHMENT.Base = "att_ammo"
ATTACHMENT.Name = "Black Powder Warheads"
ATTACHMENT.Category = "WARHEADS"
ATTACHMENT.Icon = Material("vgui/perkicons/warhead_icon")
ATTACHMENT.CustomText = "Explosions will ignite entities in an extended blast radius."
ATTACHMENT.CustomTextColor = Color(255,128,0)
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
ATTACHMENT.Bodygroups ={
    ["warhead"] = 1
}

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Explosive.BlastRadius = weapon.Explosive.BlastRadius * 0.6
end

function ATTACHMENT:OnImpact(weapon, dmgInfo, tr) 
    for k,e in pairs(ents.FindInSphere(tr.HitPos, weapon.Explosive.BlastRadius * 1.8)) do --pretty high extra radius since the original is nerfed by the att
        if e:IsLineOfSightClear(tr.HitPos) then 
            e:Ignite(6, 64)
        end
    end
end
