AddCSLuaFile()

function SWEP:CanChangeFiremode()
    return true
end

function SWEP:ApplyFiremodeStats()
    return self.Firemodes[self:GetFiremode()].OnSet(self)
end

function SWEP:ApplyFiremode(index)
    local seqIndex = "Idle"

    if isstring(index) then
        index = tonumber(index)
    end

    self:SetFiremode(index)

    local aimmode = self:GetAimMode()

    if (game.SinglePlayer() || IsFirstTimePredicted()) then
        self:BuildCustomizedGun() --to reset to defaults
    end
    
    self:SetAimMode(aimmode)
    self:SetAimModeDelta(aimmode)
    
    if (game.SinglePlayer() && SERVER) then
        self:CallOnClient("ApplyFiremode", index)
    end

    return self:ApplyFiremodeStats()
end