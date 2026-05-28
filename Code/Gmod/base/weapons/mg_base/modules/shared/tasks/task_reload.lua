AddCSLuaFile()

local task = {}
task.Name = "Reload"
task.Flag = "Reloading"
task.Priority = 4
task.bCanAim = true
task.bCanBipod = true

function task:CanBeSet(weapon)
    return (weapon:Ammo1() > 0 || self:IsInfiniteReserve(weapon))
    && weapon:GetMaxClip1() > 0
    && weapon:Clip1() < weapon:GetMaxClip1WithChamber()
    && CurTime() >= weapon:LastShootTime() + 0.2
    && !weapon:HasFlag("Reloading")
end

function task:OnSet(weapon)
    local seqIndex = weapon:ChooseReloadAnim()

    weapon:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, weapon.HoldTypes[weapon:GetCurrentHoldType()].Reload)
    weapon:PlayViewModelAnimation(seqIndex)
    weapon:SetNextReloadSeq(seqIndex)

    if weapon:GetAnimation("Reload_Loop") then
        if weapon:Clip1() <= 0 and weapon:GetAnimation("Reload_Loop_Empty") then
            weapon:AddFlag("ReloadEmptyVariant")
        else
            weapon:RemoveFlag("ReloadEmptyVariant")
        end
        
        weapon:SetNextPrimaryFire(CurTime())
        weapon:SetNextSecondaryFire(CurTime() + 999) -- surely no animation lasts this long
    else
        weapon:SetNextPrimaryFire(CurTime() + weapon:GetAnimLength(seqIndex))
        weapon:SetNextSecondaryFire(CurTime() + weapon:GetAnimLength(seqIndex, weapon:GetAnimation(seqIndex).MagLength))
        weapon:RemoveFlag("MagInserted")
    end
end

function task:SetupDataTables(weapon)
    weapon:CustomNetworkVar("Flag", "MagInserted")
    weapon:CustomNetworkVar("Flag", "Reloading")
    weapon:CustomNetworkVar("Int", "ReloadIndex")
    weapon:CustomNetworkVar("String", "NextReloadSeq")
    weapon:CustomNetworkVar("Flag", "ReloadEmptyVariant")
end

function task:Think(weapon)
    self.bCanBipod = weapon:GetAimDelta() > 0.5
    self.bCanAim = !weapon.CanDisableAimReload
    
    if weapon:GetAnimation("Reload_Loop") then
        return self:LoopReload(weapon)
    else
        return self:MagazineReload(weapon)
    end
    return false
end

function task:IsInfiniteReserve(weapon)
    return game.GetAmmoMax(weapon:GetPrimaryAmmoType()) == -2
end

function task:LoopReload(weapon)
    if weapon:GetOwner():KeyPressed(IN_ATTACK) && weapon:Clip1() > 0 then
        weapon:TrySetTask("ReloadEnd") --abort but really early
        return true
    end

    local seqIndex = weapon:GetNextReloadSeq()
    local curAnim = weapon:GetAnimation(seqIndex)
    local magAmount = curAnim.MagAmount or 1
    local magLength = curAnim.MagLength
    local lengthIsTable = istable(magLength)

    if CurTime() > weapon:GetNextSecondaryFire() and !weapon:HasFlag("MagInserted") then
        local newClip = weapon:Clip1() + magAmount
        if GetConVar("mgbase_debug_mag"):GetBool() then
            newClip = math.min(newClip, 2)
        end

        weapon:SetClip1(newClip)
        weapon:GetOwner():SetAmmo(weapon:Ammo1() - magAmount, weapon:GetPrimaryAmmoType())

        if curAnim.Rechamber then
            weapon:AddFlag("Rechambered")
            weapon:SetRoundsUntilRechamber(0)
        end

        -- Loop for multiple rounds
        if lengthIsTable then
            local curMagIndex = weapon:GetReloadIndex() or 1
            weapon:SetReloadIndex(curMagIndex + 1)
            if curMagIndex + 1 > #magLength then
                weapon:AddFlag("MagInserted")
                weapon:SetNextReloadSeq(weapon:ChooseReloadLoopAnim())
            else
                weapon:SetNextSecondaryFire(CurTime() + weapon:GetAnimLength(seqIndex, magLength[curMagIndex + 1]))
            end
        else
            weapon:AddFlag("MagInserted")
            weapon:SetNextReloadSeq(weapon:ChooseReloadLoopAnim())
        end
    end

    if CurTime() > weapon:GetNextPrimaryFire() then
        local bShouldFinish = weapon:Clip1() + magAmount > weapon:GetMaxClip1WithChamber() || (!self:IsInfiniteReserve(weapon) && weapon:GetOwner():GetAmmoCount(weapon:GetPrimaryAmmoType()) <= 0)
		if bShouldFinish then
			weapon:TrySetTask("ReloadEnd") --abort
			return true
		end
        
        weapon:PlayViewModelAnimation(seqIndex)
        weapon:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, weapon.HoldTypes[weapon:GetCurrentHoldType()].Reload)

		local primaryDelay = weapon:GetAnimLength(seqIndex)

        if lengthIsTable then
            weapon:SetNextSecondaryFire(CurTime() + weapon:GetAnimLength(seqIndex, magLength[1]))
        else
            weapon:SetNextSecondaryFire(CurTime() + weapon:GetAnimLength(seqIndex, magLength))
			-- New system breaks if Length == MagLength
			primaryDelay = magLength == curAnim.Length && primaryDelay + FrameTime() || primaryDelay
        end
		
        weapon:SetNextPrimaryFire(CurTime() + primaryDelay)
        weapon:SetReloadIndex(1)
        weapon:RemoveFlag("MagInserted")
    end

    return false 
end

function task:MagazineReload(weapon)
    if CurTime() > weapon:GetNextSecondaryFire() && !weapon:HasFlag("MagInserted") then
        local seqIndex = weapon:GetNextReloadSeq()
        local curAnim = weapon:GetAnimation(seqIndex)
        local maxClip = weapon:GetMaxClip1WithChamber()
        local magAmount = self:IsInfiniteReserve(weapon) && (maxClip - weapon:Clip1()) || math.min(maxClip - weapon:Clip1(), weapon:Ammo1())

        if GetConVar("mgbase_debug_mag"):GetBool() then
            weapon:SetClip1(2)
            magAmount = 2
        else
            weapon:SetClip1(weapon:Clip1() + magAmount)
        end

        weapon:GetOwner():SetAmmo(weapon:Ammo1() - magAmount, weapon:GetPrimaryAmmoType())

        if (seqIndex == "Reload_Empty" && weapon.EmptyReloadRechambers) || weapon.ReloadRechambers || !weapon:GetAnimation("Rechamber") then
            weapon:AddFlag("Rechambered")
            weapon:SetRoundsUntilRechamber(0)
        end

        weapon:AddFlag("MagInserted")
    end
    
    if CurTime() > weapon:GetNextPrimaryFire() then
        return true
    end

    return false
end

SWEP:RegisterTask(task)