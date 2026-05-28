include("shared.lua")

killicon.Add("mg_aoe_arrow_explosion", "VGUI/entities/mg_crossbow", Color(255, 0, 0, 255))

local BaseClass = baseclass.Get(ENT.Base)

function ENT:Draw(flags)
    self:DrawShadow(false)
end 