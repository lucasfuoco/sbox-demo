ATTACHMENT.Base = "att_base"
ATTACHMENT.Name = "Default Magazine"
ATTACHMENT.Category = "Magazines"

--for gameplay mag
ATTACHMENT.BulletList = {}

--for animation mag (offhand)
ATTACHMENT.ReserveBulletList = {}

ATTACHMENT.PoseParameter = "bullets_offset" --the spring

local small = Vector()
local normal = Vector(1, 1, 1)

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:SetMagFollowerPoseParam(weapon, val)
    local ppid = self.m_Model:LookupPoseParameter(self.PoseParameter)
    local min, max = self.m_Model:GetPoseParameterRange(ppid)
    min = min || 0
    max = max || 1
    
    self.m_Model:SetPoseParameter(self.PoseParameter, math.Clamp(val, min, max))
    --self.m_Model:InvalidateBoneCache()
end

function ATTACHMENT:Render(weapon)
    BaseClass.Render(self, weapon)
    
    if (!weapon:IsCarriedByLocalPlayer()) then
        return
    end

    if (!weapon:HasFlag("Reloading")) then
        self.m_Model._clip = weapon:Clip1()
        self.m_Model._ammo = weapon:Ammo1()
        self:SetMagFollowerPoseParam(weapon, weapon:GetMaxClip1() - weapon:Clip1())
    end
end

local function cacheBones(model, bones)
    for _, name in pairs(bones) do
        model.cachedBones[name] = {id = model:LookupBone(name), remove = false}
    end
end

function ATTACHMENT:PostInitModels(weapon)
    BaseClass.PostInitModels(self, weapon)
    
    if (SERVER) then
        return
    end
    
    if (table.IsEmpty(self.BulletList) && table.IsEmpty(self.ReserveBulletList)) then
        return
    end

    self.m_Model._requestedReset = false
    self.m_Model._clip = -1
    self.m_Model._lastClip = -1
    self.m_Model._ammo = -1
    self.m_Model._lastAmmo = -1
    self.m_Model.BulletList = table.Copy(self.BulletList)
    self.m_Model.ReserveBulletList = table.Copy(self.ReserveBulletList)

    self.m_Model:SetupBones()
    self.m_Model.cachedBones = {}
    for _, bones in pairs(self.m_Model.BulletList) do
        cacheBones(self.m_Model, bones)
    end

    for _, bones in pairs(self.m_Model.ReserveBulletList) do
        cacheBones(self.m_Model, bones)
    end

    self.m_Model:AddCallback("BuildBonePositions", function(ent, numbones)
        local function scaleBones(ent, bones, bRemove)
            for i, bone in pairs(bones) do
                ent.cachedBones[bone].remove = bRemove
            end
        end

        if (ent._lastClip != ent._clip) then
            for i, bones in pairs(ent.BulletList) do
                scaleBones(ent, bones, ent._clip <= i)
            end

            ent._lastClip = ent._clip
        end
        
        if (ent._lastAmmo != ent._ammo + ent._clip) then
            for i, bones in pairs(ent.ReserveBulletList) do
                scaleBones(ent, bones, weapon:Clip1() + weapon:Ammo1() < i)
            end

            ent._lastAmmo = ent._ammo + ent._clip
        end
        
        if (ent._requestedReset) then
            for i, bones in pairs(ent.BulletList) do
                scaleBones(ent, bones, weapon:Clip1() + weapon:Ammo1() < i)
            end

            ent._requestedReset = false
        end

        for name, boneStuff in pairs(ent.cachedBones) do
            if (!boneStuff.remove) then
                continue
            end

            local mat = ent:GetBoneMatrix(boneStuff.id)

            if (mat == nil) then
                continue
            end

            mat:SetScale(small)
            ent:SetBoneMatrix(boneStuff.id, mat)
        end
    end)
end

function ATTACHMENT:ResetBullets(weapon)
    self.m_Model._requestedReset = true
    self:SetMagFollowerPoseParam(weapon, weapon:GetMaxClip1() - (weapon:Clip1() + weapon:Ammo1()))
end