AddCSLuaFile()

function SWEP:GetMaxClip1WithChamber()
    if self.CanChamberRound && self:HasFlag("Rechambered") && self:GetMaxClip1() > 0 then
        return self:GetMaxClip1() + 1
    end

    return self:GetMaxClip1()
end

function SWEP:ChooseReloadAnim()
    if self:GetAnimation("Reload_Empty_Chamber") && self:Clip1() <= 0 then
        return "Reload_Empty_Chamber"
    end

    if self:GetAnimation("Reload_Start_Empty") && self:Clip1() <= 0 then
        return "Reload_Start_Empty"
    end

    if self:GetAnimation("Reload_Start")then
        return "Reload_Start"
    end

    if self:GetAnimation("Rechamber") && !self:HasFlag("Rechambered") then
        return "Reload_Empty"
    end

    if self:GetAnimation("Reload_Empty") && self:Clip1() <= 0 then
        return "Reload_Empty"
    end

    return "Reload"
end

function SWEP:ChooseReloadLoopAnim()
    local emptyVariant = self:HasFlag("ReloadEmptyVariant")

    if self:GetNextReloadSeq() == "Reload_Empty_Chamber" then
        return emptyVariant && "Reload_Start_Empty" || "Reload_Start"
    end

    return emptyVariant && "Reload_Loop_Empty" || "Reload_Loop"
end

function SWEP:ChooseReloadEndAnim()
    local emptyVariant = (self:GetAnimation("Reload_End_Empty") && !self:HasFlag("Rechambered")) || self:HasFlag("ReloadEmptyVariant")

    return emptyVariant && "Reload_End_Empty" || "Reload_End"
end