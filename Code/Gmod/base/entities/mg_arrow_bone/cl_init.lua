include("shared.lua")

killicon.Add("mg_arrow_bone", "VGUI/entities/mg_crossbow", Color(255, 0, 0, 255))

local BaseClass = baseclass.Get(ENT.Base)

function ENT:Initialize()
    BaseClass.Initialize(self)
    self:EmitSound("MW19_Crossbow.Bone")
end