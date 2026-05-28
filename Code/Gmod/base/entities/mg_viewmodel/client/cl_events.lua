require("mw_utils")

--Events we can use:
-- CL_EVENT_SOUND [sound, vector for spatial] (5004) -> sound (eg: "event 5004 mw19.sound 0,10,10")
-- CL_EJECT_BRASS1 [attachment name] (6001) -> ejection (eg: event 6001 tag_ejection)
-- CL_EVENT_DISPATCHEFFECT0 [particle name, attachment name] (9001) -> particles (eg: event 9001 mw_muzzleflash tag_flash)
-- CL_EVENT_DISPATCHEFFECT1 [0/1] (9011) -> left hand grip pose toggle (eg: event 9011 0 -> event 9011 1)
-- CL_EVENT_DISPATCHEFFECT2 [0/1] (9021) -> right hand grip pose toggle (eg: event 9021 0 -> event 9021 1)
-- CL_EVENT_DISPATCHEFFECT3 [name] (9031) -> run attachment function (eg: event 9031 FillBullets) 

--Animation event codes
local CL_EVENT_MUZZLEFLASH0 = 5001 -- Muzzleflash on attachment 0
local CL_EVENT_MUZZLEFLASH1 = 5011 -- Muzzleflash on attachment 1
local CL_EVENT_MUZZLEFLASH2 = 5021 -- Muzzleflash on attachment 2
local CL_EVENT_MUZZLEFLASH3 = 5031 -- Muzzleflash on attachment 3
local CL_EVENT_SPARK0 = 5002 -- Spark on attachment 0
local CL_EVENT_NPC_MUZZLEFLASH0	= 5003 -- Muzzleflash on attachment 0 for third person views
local CL_EVENT_NPC_MUZZLEFLASH1	= 5013 -- Muzzleflash on attachment 1 for third person views
local CL_EVENT_NPC_MUZZLEFLASH2	= 5023 -- Muzzleflash on attachment 2 for third person views
local CL_EVENT_NPC_MUZZLEFLASH3	= 5033 -- Muzzleflash on attachment 3 for third person views
local CL_EVENT_SOUND = 5004 -- Emit a sound // NOTE THIS MUST MATCH THE DEFINE AT CBaseEntity::PrecacheModel on the server!!!!!
local CL_EVENT_EJECTBRASS1 = 6001 -- Eject a brass shell from attachment 1
local CL_EVENT_DISPATCHEFFECT0	= 9001 -- Hook into a DispatchEffect on attachment 0
local CL_EVENT_DISPATCHEFFECT1	= 9011 -- Hook into a DispatchEffect on attachment 1
local CL_EVENT_DISPATCHEFFECT2	= 9021 -- Hook into a DispatchEffect on attachment 2
local CL_EVENT_DISPATCHEFFECT3	= 9031 -- Hook into a DispatchEffect on attachment 3
local CL_EVENT_DISPATCHEFFECT4	= 9041 -- Hook into a DispatchEffect on attachment 4
local CL_EVENT_DISPATCHEFFECT5	= 9051 -- Hook into a DispatchEffect on attachment 5
local CL_EVENT_DISPATCHEFFECT6	= 9061 -- Hook into a DispatchEffect on attachment 6
local CL_EVENT_DISPATCHEFFECT7	= 9071 -- Hook into a DispatchEffect on attachment 7
local CL_EVENT_DISPATCHEFFECT8	= 9081 -- Hook into a DispatchEffect on attachment 8
local CL_EVENT_DISPATCHEFFECT9	= 9091 -- Hook into a DispatchEffect on attachment 9

local utilef = util.Effect
local pef = ParticleEffectAttach

local function invalidateBoneCacheForParticles(ent)
    while (IsValid(ent)) do
        if (ent:IsEffectActive(EF_BONEMERGE) || !IsValid(ent:GetParent())) then
            ent:InvalidateBoneCache()
        end
        ent = ent:GetParent()
    end
end

local function findAttachmentInChildren(ent, attName)
    local attId = mw_utils.LookupAttachmentCached(ent, attName)

    for _, c in pairs(ent:GetChildren()) do
        if (c:GetClass() != "class C_BaseFlex") then
            continue
        end
        
        local ce, ca = findAttachmentInChildren(c, attName)

        if (ca != nil) then
            attId = ca
            ent = ce
        end
    end

    return ent, attId
end

function ENT:FindAttachment(attName)
    return findAttachmentInChildren(self, attName)
end

local function createEffectDataForShell(owner, attName)
    local data = EffectData()
    data:SetEntity(owner)
    
    local attEnt, attId = findAttachmentInChildren(owner, attName)

    if (attId == nil) then
        mw_utils.ErrorPrint("createEffectDataForShell: "..attName.." does not exist on model!")
        return data
    end

    local att = attEnt:GetAttachment(attId)
    data:SetOrigin(att.Pos)
    data:SetAngles(att.Ang)
    
    owner = owner:GetOwner()

    while (IsValid(owner) && !owner:IsPlayer()) do
        owner = owner:GetOwner()
    end

    if (IsValid(owner)) then
        data:SetNormal(owner:GetVelocity():GetNormalized())
        data:SetMagnitude(owner:GetVelocity():Length())
    end

    return data
end

function ENT:IsFirstPerson()
    local w = self:GetOwner()
    local plr = w:GetOwner()
    return IsValid(plr) && plr:IsPlayer() && !plr:ShouldDrawLocalPlayer() && w:IsCarriedByLocalPlayer()
end

function ENT:HandleEjection(attName)
    local w = self:GetOwner()
    local theShell = w.Shell

    if theShell == "mwb_shelleject" || theShell == "mwb_shelleject_comp" then
        mw_utils.ErrorPrint("DoEjection: do not use mwb_shelleject! Use an existing caliber or make your own.")
        return true
    elseif !isstring(theShell) && !istable(theShell) then
        mw_utils.ErrorPrint("shell Fuck you die")
        return true
    end
 
    local isFps = self:IsFirstPerson()
    local data = createEffectDataForShell(isFps && self || w, attName)
    data:SetFlags(isFps && 1 || 0)

    if istable(theShell) then
        for _, shellie in pairs(theShell) do
            utilef(shellie, data)
        end
    else
        utilef(theShell, data)
    end

    return true
end

function ENT:HandleParticle(partName, attName)
    local w = self:GetOwner()

    if (w.ParticleEffects != nil && w.ParticleEffects[partName] != nil) then
        partName = w.ParticleEffects[partName]
    end

    if self:IsFirstPerson() then
        local ent, attId = findAttachmentInChildren(self, attName)

        if (attId == nil) then
            mw_utils.ErrorPrint("HandleParticle: "..attName.." does not exist on viewmodel!")
            return true
        end

        if (self.m_Particles[partName] != nil) then
            self.m_Particles[partName]:StopEmissionAndDestroyImmediately()
        end

        local particleSystem = CreateParticleSystem(ent, partName, PATTACH_POINT_FOLLOW, attId)
        particleSystem:SetIsViewModelEffect(true)
        particleSystem:SetShouldDraw(false)
        self.m_Particles[partName] = particleSystem
    else
        local ent, attId = findAttachmentInChildren(w, attName)

        if (attId == nil) then
            mw_utils.ErrorPrint("HandleParticle: "..attName.." does not exist on worldmodel!")
            return true
        end

        ent:StopParticlesNamed(partName)
        pef(partName, PATTACH_POINT_FOLLOW, ent, attId)
    end

    return true
end

function ENT:HandleSound(soundName, spatialVector)
    local w = self:GetOwner()

    if (IsValid(w) && w.SoundOverrides != nil) then
        soundName = w.SoundOverrides[soundName] || soundName
    end

    if (spatialVector != nil && !spatialVector:IsZero()) then
        if (IsValid(w:GetOwner()) && !w:GetOwner():IsOnGround()) then
            return true
        end

        local ang = self:GetAngles()
        local pos = self:GetPos()
        pos:Add(ang:Forward() * spatialVector.y)
        pos:Add(ang:Right() * spatialVector.x)
        pos:Add(ang:Up() * spatialVector.z)

        sound.Play(soundName, pos)
        return true
    end
    
    --if (self:GetPlaybackRate() != 1) then
    --    self:EmitSound(soundName, 100, math.Clamp(self:GetPlaybackRate(), 0.95, 1.15) * 100, 1, CHAN_AUTO, SND_CHANGE_PITCH)
    --else
        self:EmitSound(soundName, 0, math.Clamp(self:GetPlaybackRate(), 1, 1.1) * 100, 0, 0, SND_SHOULDPAUSE + SND_CHANGE_PITCH)
    --end

    return true
end

function ENT:HandleLeftHandGrip(val)
    self.m_LeftHandGripTarget = tonumber(val)
    return true
end

function ENT:HandleRightHandGrip(val)
    self.m_RightHandGripTarget = tonumber(val)
    return true
end

function ENT:HandleMiscGrip(val)
    self.m_MiscGripTarget = tonumber(val)
    return true
end

function ENT:HandleAttFunction(name)
    self:GetOwner():AttachmentFunction(name)
    return true
end

local function eventError(event, msg)
    mw_utils.ErrorPrint("FireAnimationEvent ("..event.."): "..msg)
end

function ENT:FireAnimationEvent(pos, ang, event, name)
    if (event == CL_EVENT_DISPATCHEFFECT3) then
        return self:HandleAttFunction(name)
    end

    if (event == CL_EVENT_DISPATCHEFFECT1) then
        return self:HandleLeftHandGrip(name || 0)
    end

    if (event == CL_EVENT_DISPATCHEFFECT2) then
        return self:HandleRightHandGrip(name || 0)
    end

    if (event == CL_EVENT_DISPATCHEFFECT4) then
        return self:HandleMiscGrip(name || 0)
    end

    if (event == CL_EVENT_SOUND) then
        if (name == nil) then
            eventError(event, "Missing sound name!")
            return true
        end

        local args = string.Explode(" ", name)

        if (#args <= 0) then
            eventError(event, "Missing arguments!")
            return true
        end

        local soundName = args[1]
        local spatialVector = Vector()

        if (args[2] != nil) then
            local components = string.Explode(",", args[2])

            if (#components <= 1) then
                --jake used spaces like a dumbass
                spatialVector.x = args[2]
                spatialVector.y = args[3]
                spatialVector.z = args[4]
            else
                spatialVector.x = tonumber(components[1]) || 0
                spatialVector.y = tonumber(components[2]) || 0
                spatialVector.z = tonumber(components[3]) || 0
            end
        end

        return self:HandleSound(soundName, spatialVector)
    end

    if (event == CL_EVENT_EJECTBRASS1) then
        if (name == nil) then
            eventError(event, "Missing attachment name!")
            return true
        end

        if (self:GetOwner().HandleEjection != nil) then
            return self:GetOwner():HandleEjection(name)
        end

        return self:HandleEjection(name)
    end

    if (event == CL_EVENT_DISPATCHEFFECT0) then
        if (name == nil) then
            eventError(event, "Missing arguments!")
            return true
        end

        local args = string.Explode(" ", name)

        if (#args <= 0) then
            eventError(event, "Missing arguments!")
            return true
        end

        local partName = args[1]
        local attName = args[2]

        if (attName == nil) then
            eventError(event, "Missing attachment name!")
            return true
        end
        
        return self:HandleParticle(partName, attName)
    end
end