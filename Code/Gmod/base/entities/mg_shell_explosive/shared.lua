ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.Spawnable = false
ENT.AdminOnly = false

game.AddParticles("particles/mw19_attachments.pcf")
PrecacheParticleSystem("arrow_trail")

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Nailed")
end