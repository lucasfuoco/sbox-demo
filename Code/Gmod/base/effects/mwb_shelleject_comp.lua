--this was made to remain compatible with unofficial stuff, consider moving to new method!
AddCSLuaFile()
include("mwb_shelleject.lua")

local oldInit = EFFECT.Init

function EFFECT:Init(data)
    local shellstr = data:GetEntity().Shell
    self.Model = shellstr.Model
    self.Force = shellstr.Force
    self.Scale = shellstr.Scale
    self.Offset = shellstr.Offset || Vector()
    self.m_TouchSound = shellstr.Sound
    
    oldInit(self, data)
end

function EFFECT:EmitSurfaceSound(tr)
    self:EmitSound(self.m_TouchSound)
end