AddCSLuaFile()
require("mw_utils")

function SWEP:StopCustomizing()
    if (self:HasFlag("Customizing")) then
        self:Customize(false)
    end
end

function SWEP:GetCustomizationCount()
    if (!self.Customization) then
        return 0
    end

    return #self.Customization
end

function SWEP:GetAttachmentCount(slot)
    if (!self.Customization) then
        return 0
    end

   return #self.Customization[slot]
end

function SWEP:CanCustomize()
    return true
end

function SWEP:CanPlayInspectAfterCustomization() --people lagging could still be playing draws
    return !self:HasFlag("Drawing")
end

function SWEP:Attach(slot, attIndex)
    if (self.Customization[slot] == nil) then
        return
    end

    local attachmentClass = self.Customization[slot][attIndex]

    self:CreateAttachmentForUse(attachmentClass)

    --BUILD:
    local inspectAnim = self.Animations["Inspect"].Sequences[1]

    self:BuildCustomizedGun()

    --reset inspect animation
    if (CLIENT) then
        local inspectDelta = self.FreezeInspectDelta || 0.15

        if (self:Clip1() <= 0 && self.EmptyFreezeInspectDelta) then
            inspectDelta = self.EmptyFreezeInspectDelta
        end

        if (self.Animations["Inspect"].Sequences[1] != inspectAnim || self:HasFlag("Drawing")) then
            self:GetViewModel():UpdateAnimation()
        end
        
        self:GetViewModel():SetCycle(inspectDelta)
    end
end

function SWEP:IsBodygroupAllowed(bgName)
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        if (att.BlockedBodygroups != nil && table.HasValue(att.BlockedBodygroups, bgName)) then
            return false
        end
    end

    return true
end

local function doAttBodygroups(wep, model)
    for i = 0, model:GetNumBodyGroups(), 1 do
        model:SetBodygroup(i, 0)
    end

    for slot, att in pairs(wep:GetAllAttachmentsInUse()) do
        if (att.AttachmentBodygroups != nil) then
            for bodyGroupName, value in pairs(att.AttachmentBodygroups) do
                if (!wep:IsBodygroupAllowed(bodyGroupName)) then
                    continue
                end
                local id = model:FindBodygroupByName(bodyGroupName)
                if (id != -1) then
                    model:SetBodygroup(id, value)
                end
            end
        end
    end
end

local function doMaterialOverride(att, model, funcName)
    for i, mat in pairs(model:GetMaterials()) do
        local originalPath, originalName = string.GetPathFromFilename(mat), string.GetFileFromFilename(mat)
        local path, name = att[funcName](att, originalPath, originalName)
        if (path != originalPath || name != originalName) then
            local material = Material(path..name)
            if (!material:IsError()) then
                model:SetSubMaterial(i - 1, path..name)
                model.CustomizationAnimationDelta = 1
                model.CustomizationAnimationColor = att.UIColor || Color(255, 255, 255, 255)
            end
        end
    end
end

function SWEP:CreateAttachmentModel(attachment)
    if (SERVER) then
        return
    end
    
    doMaterialOverride(attachment, self:GetViewModel(), "OverrideWeaponMaterial")
    doMaterialOverride(attachment, self, "OverrideWeaponMaterial")

    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        if (att == attachment) then
            continue
        end

        if (IsValid(att.m_Model)) then
            doMaterialOverride(attachment, att.m_Model, "OverrideAttachmentsMaterial")
        end

        if (IsValid(att.m_TpModel)) then
            doMaterialOverride(attachment, att.m_TpModel, "OverrideAttachmentsMaterial")
        end
    end

    if (attachment.Model == nil) then
        return
    end

    if (!IsValid(attachment.m_Model)) then
        attachment.m_Model = ClientsideModel(attachment.Model, RENDERGROUP_VIEWMODEL)
        attachment.m_Model:SetRenderMode(RENDERMODE_ENVIROMENTAL)
        attachment.m_Model:SetMoveType(MOVETYPE_NONE)
        attachment.m_Model:SetSolid(SOLID_NONE)
        attachment.m_Model:SetNotSolid(true)
        attachment.m_Model:SetOwner(self:GetViewModel())
        attachment.m_Model.bAttachmentRenderOverride = attachment.RenderOverride
        attachment.m_Model:AddEffects(EF_PARENT_ANIMATES)
        mw_utils.DealWithFullUpdate(attachment.m_Model)
        
        if (attachment.VElement == nil) then
            attachment.m_Model:AddEffects(EF_BONEMERGE)
            attachment.m_Model:AddEffects(EF_BONEMERGE_FASTCULL)
            attachment.m_Model:SetParent(self:GetViewModel())
        else
            attachment.m_Model:FollowBone(self:GetViewModel(), mw_utils.LookupBoneCached(self:GetViewModel(), attachment.VElement.Bone))
        end

        attachment.m_Model.CustomizationAnimationDelta = 0
        attachment.m_Model.CustomizationAnimationColor = Color(255, 255, 255, 255)
        
        --this is for the highlight effect on the attachments
        if (attachment.Index > 1) then
            attachment.m_Model.CustomizationAnimationDelta = 1 
            attachment.m_Model.CustomizationAnimationColor = attachment.UIColor || attachment.m_Model.CustomizationAnimationColor
        end
    end

    if (attachment.VElement != nil) then  
        self:MoveVElement(self:GetViewModel(), attachment)
    end

    if (!IsValid(attachment.m_TpModel)) then
        attachment.m_TpModel = ClientsideModel(attachment.Model, self.RenderGroup)
        attachment.m_TpModel:SetRenderMode(self.RenderMode)
        attachment.m_TpModel:SetMoveType(MOVETYPE_NONE)
        attachment.m_TpModel:SetSolid(SOLID_NONE)
        attachment.m_TpModel:SetNotSolid(true)
        attachment.m_TpModel:SetOwner(self)
        attachment.m_TpModel:SetNoDraw(true) --perf
        attachment.m_TpModel.ShowOnWorldModel = attachment.ShowOnWorldModel
        attachment.m_TpModel:AddEffects(EF_PARENT_ANIMATES)
        mw_utils.DealWithFullUpdate(attachment.m_TpModel)

        if (attachment.VElement == nil) then
            attachment.m_TpModel:AddEffects(EF_BONEMERGE)
            attachment.m_TpModel:AddEffects(EF_BONEMERGE_FASTCULL)
            attachment.m_TpModel:SetParent(self)
        else
            attachment.m_TpModel:FollowBone(self, mw_utils.LookupBoneCached(self, attachment.VElement.Bone))
        end

        attachment:PostInitModels(self)
    end

    if (attachment.VElement != nil) then
        self:MoveVElement(self, attachment)
    end

    doAttBodygroups(self, attachment.m_Model)
    doAttBodygroups(self, attachment.m_TpModel)
    doMaterialOverride(attachment, attachment.m_Model, "OverrideMaterial")
    doMaterialOverride(attachment, attachment.m_TpModel, "OverrideMaterial")
end

function SWEP:ShouldInvalidateBoneCache()
    for _, att in pairs(self:GetAllAttachmentsInUse()) do
        if (!IsValid(att.m_Model) || !att.m_Model:IsEffectActive(EF_FOLLOWBONE)) then
            continue
        end

        if (att.m_Model:GetAttachments() != nil) then
            return true
        end
    end

    return false
end

function SWEP:GetAttachmentInUseForSlot(slot)
    return self.m_CustomizationInUse[slot]
end

function SWEP:GetAttachmentInUseByCategory(cat)
    for _, att in pairs(self:GetAllAttachmentsInUse()) do
        if (att.Category == cat) then
            return att
        end
    end

    return nil
end

function SWEP:GetAllAttachmentsInUse()
    return self.m_CustomizationInUse
end

function SWEP:BuildCustomizedGun()
    --this resets gun to defaults, but keeps the internal variables
    self:DeepObjectCopy(weapons.Get(self:GetClass()), self)

    local oldSkin = IsValid(self:GetViewModel()) && self:GetViewModel():GetSkin() || 0
    self:ResetBodygroups()

    self:SetBurstRounds(0)
    self:SetSprayRounds(0)

    self.reticle = nil
    self.flashlight = nil
    self.laser = nil
    self.bipod = nil
    self.underbarrel = nil

    if (self.Customization == nil) then
        return
    end
    
    clearBaseClass(self.Customization)

    --conversions can add attachments, base doesnt know what is new or not so we restore customization to original
    self.Customization = table.Copy(weapons.GetStored(self:GetClass()).Customization)
    self.Animations = table.Copy(weapons.GetStored(self:GetClass()).Animations)

    clearBaseClass(self.Animations)

    local vmspeed = 1

    if (IsValid(self:GetViewModel())) then
        vmspeed = self:GetViewModel():GetPlaybackRate()
        self:GetViewModel():SetPlaybackRate(0)
        self:GetViewModel():SetModel(self.VModel)
    end

    self:SetModel(self.WorldModel)

    if (CLIENT) then
        if (IsValid(self:GetViewModel())) then
            self:GetViewModel():SetSubMaterial()
            self:GetViewModel().m_LeftHandGripPoseParameter = nil
            self:GetViewModel().m_RightHandGripPoseParameter = nil
            self:GetViewModel().m_MiscGripPoseParameter = nil
        end
        
        for slot, att in pairs(self:GetAllAttachmentsInUse()) do
            if (att.Model != nil) then
                if (IsValid(att.m_TpModel)) then
                    att.m_TpModel:SetSubMaterial()
                end

                if (IsValid(att.m_Model)) then
                    att.m_Model:SetSubMaterial()
                end
            end
        end
        self:SetSubMaterial()
    end 

    --check if atts are allowed
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        if (att == nil || !self:IsAttachmentAllowed(att)) then
            self:CreateAttachmentForUse(self.Customization[slot][1])
        end
    end

    --this is needed for level transitions
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        table.Inherit(att, self:GetStoredAttachment(att.ClassName))
    end
    
    self:PreAttachments()

    local stats = {}
    self:DeepObjectCopy(self:GetTable(), stats)

    stats.SetViewModel = function(self, vm)
        mw_utils.ErrorPrint("SetViewModel: Don't call this in Stats!")
    end

    local c = 0

    for slot, attachment in pairs(self:GetAllAttachmentsInUse()) do
        if (attachment.Flashlight != nil) then
            self.flashlight = attachment
        end

        if (attachment.Laser != nil) then
            self.laser = attachment
        end

        if (attachment.Reticle != nil) then
            self.reticle = attachment
        end
        
        if (attachment.Bipod) then
            self.bipod = attachment
        end

        local base = attachment.Base

        while (base != nil && self.underbarrel == nil) do
            if (base == "att_underbarrel") then
                self.underbarrel = attachment
            end

            base = MW_ATTS[base].Base
        end
        
        attachment:Stats(stats)

        if (attachment.Index > 1) then
            self:MakeBreadcrumbsForAttachment(attachment)
        end
    end

    --check if customization changed
    local bChanged = false
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        if (stats.Customization[slot] == nil) then
            mw_utils.DevPrint("BuildCustomizedGun: Slot "..slot.." got removed!")
            self:RemoveAttachment(att)
            bChanged = true
            continue
        end

        if (att.ClassName != stats.Customization[slot][att.Index]) then
            local classToChangeTo = stats.Customization[slot][att.Index] != nil && stats.Customization[slot][att.Index] || stats.Customization[slot][1]

            mw_utils.DevPrint("BuildCustomizedGun: "..att.ClassName.." changed to "..classToChangeTo)
            local newAtt = self:CreateAttachmentForUse(classToChangeTo, stats.Customization)

            if (CLIENT) then
                if (newAtt.Base == att.ClassName || att.Base == newAtt.ClassName) then
                    if (mw_utils.IsAssetFavorite(self:GetClass(), att.ClassName)) then
                        mw_utils.FavoriteAsset(self:GetClass(), newAtt.ClassName)
                    else
                        mw_utils.UnfavoriteAsset(self:GetClass(), newAtt.ClassName)
                    end
                end
            end
            
            bChanged = true
        end
    end
    
    if (bChanged) then
        mw_utils.DevPrint("BuildCustomizedGun: Customization changed! Redoing...")
        self:BuildCustomizedGun()
        return
    end

    clearBaseClass(stats)
    self:DeepObjectCopy(stats, self)

    local oldVm = self.SetViewModel
    self.SetViewModel = function(self, vm) 
        self.VModel = vm
    end

    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        local oldModel = self.VModel
        att:PostProcess(self)

        if (self.VModel != oldModel && IsValid(self:GetViewModel())) then
            self:GetViewModel().CustomizationAnimationColor = att.UIColor || Color(255, 255, 255, 255)
            self:GetViewModel().CustomizationAnimationDelta = 1
        end
    end

    self.SetViewModel = oldVm

    if (IsValid(self:GetViewModel())) then
        self:GetViewModel():SetModel(self.VModel)
    end

    self:SetModel(self.WorldModel)
    
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        self:PostAttachment(att) --letting all atts do their thing and then run ours
    end

    --check magazine:
    if (IsValid(self:GetOwner())) then
        if (self:GetUnderbarrel() == nil) then
            self:SetClip2(0) --reset
        end

        local maxClip = self:GetMaxClip1WithChamber()
        if (!self:HasFlag("PlayFirstDraw")) then
            if (self:Clip1() > maxClip) then
                local diff = self:Clip1() - maxClip
                self:SetClip1(self:Clip1() - diff)
                self:GetOwner():SetAmmo(self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) + diff, self:GetPrimaryAmmoType())
            end
        else
            self:SetClip1(maxClip)
            self:SetClip2(self.Secondary.ClipSize)
        end
    end

    --check if we can keep aim mode
    --if ((self:GetSight() == nil || self:GetSight().ReticleHybrid == nil) && (self:GetLaser() == nil || self:GetAimMode() == 0)) then
    self:SetAimMode(0)
    self:SetAimModeDelta(0)
    self:RemoveFlag("TacStance")
    self:SetTacStanceDelta(0)
    --end

    --create models:
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        self:CreateAttachmentModel(att)
    end

    --bodygroups:
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        if (att.Bodygroups != nil) then
            for bg, v in pairs(att.Bodygroups) do
                if (!self:IsBodygroupAllowed(bg)) then
                    continue
                end
                self:DoBodygroup(bg, v)
            end
        end
    end

    self:SetBonemergeParents()
    self:GenerateAimOffset()

    if (CLIENT) then
        local curSkin = IsValid(self:GetViewModel()) && self:GetViewModel():GetSkin() || 0
        local skinCount = IsValid(self:GetViewModel()) && self:GetViewModel():SkinCount() || 0

        for slot, att in pairs(self:GetAllAttachmentsInUse()) do
            att:Appearance(self:GetViewModel(), "Weapon")
            if (curSkin != oldSkin && curSkin > 0 && curSkin <= skinCount) then
                self:GetViewModel().CustomizationAnimationColor = att.UIColor || Color(255, 255, 255, 255)
                self:GetViewModel().CustomizationAnimationDelta = 1
            end

            att:Appearance(self, "Weapon")

            for _, att2 in pairs(self:GetAllAttachmentsInUse()) do
                if (att2.Model != nil) then
                    att:Appearance(att2.m_Model, att2.Category)

                    if (att2.m_Model:GetSkin() != oldSkin && att2.m_Model:GetSkin() > 0 && att2.m_Model:GetSkin() <= att2.m_Model:SkinCount()) then
                        att2.m_Model.CustomizationAnimationColor = att.UIColor || Color(255, 255, 255, 255)
                        att2.m_Model.CustomizationAnimationDelta = 1
                    end

                    att:Appearance(att2.m_TpModel, att2.Category)
                end
            end
        end
    end

    --meme marine
    self:SetHoldType("camera")
    timer.Simple(0, function()
        if !IsValid(self) then return end
        self:SetShouldHoldType(true)
    end)
    
    --apply firemode first while resetting defaults:
    if !self.Firemodes[self:GetFiremode()] then
        self:ApplyFiremode(1)
    else
        self:ApplyFiremodeStats()
    end
    

    --shadowdark was here
    --this hook passes the swep object after stats are built, allowing for custom 3rd party stat scaling
    hook.Call("OnBuildCustomizedGun", nil, self)

    if (IsValid(self:GetViewModel())) then
        self:GetViewModel():SetPlaybackRate(vmspeed)
    end
end

--some of this was hard to read so i changed it
function SWEP:MakeBreadcrumbsForAttachment(attachment)
    if (attachment.Breadcrumbs == nil) then
        -- copy weapon to a table
        local original = weapons.Get(self:GetClass())
        local changed = {}
        self:DeepObjectCopy(original, changed)
        attachment:Stats(changed) --run stats (lol he doesnt know its actually not a gun!!)

        -- merge tables
        local holder = {}
        self:MakeBreadcrumbs(holder, original, changed) --looks at differences in numbers only

        attachment.Breadcrumbs = {}

        for statInfo, crumb in pairs(holder) do
            crumb.statInfo = statInfo
            table.insert(attachment.Breadcrumbs, crumb)
        end

        local sort = function(a, b) 
            local aStat = self.StatInfo[a.statInfo]
            local bStat = self.StatInfo[b.statInfo]

            local baPositive = a.Current <= a.Original
                    
            if (aStat.ProIfMore) then
                baPositive = !baPositive
            end
            
            local bbPositive = b.Current <= b.Original
                    
            if (bStat.ProIfMore) then
                bbPositive = !bbPositive
            end

            if (baPositive && !bbPositive) then
                return true
            elseif (!baPositive && bbPositive) then
                return false
            elseif ((baPositive && bbPositive) || (!baPositive && !bbPositive)) then
                local aName = aStat.Name
                local bName = bStat.Name

                return aName < bName
            end
        end
        table.sort(attachment.Breadcrumbs, sort)
    end
end

function SWEP:MakeBreadcrumbs(holder, original, changed, currentPath)
    if !istable(changed) then return end
    currentPath = currentPath || "SWEP"

    for index, value in pairs(original) do
        if changed == nil then return end
        if tostring(index) == "BaseClass" || tostring(index) == "m_Index" then
            continue
        end

        if isnumber(value) then
            if changed[index] != value then
                -- find stat definition
                local path = currentPath.."."..tostring(index)
                if (self.StatDefinitions[path] == nil) then
                    continue
                end

                holder[self.StatDefinitions[path]] = holder[self.StatDefinitions[path]] || {}
                table.Merge(holder[self.StatDefinitions[path]], {Original = value, Current = changed[index]}) 
            end
        elseif istable(value) && changed[index] != nil then
            self:MakeBreadcrumbs(holder, value, changed[index], currentPath.."."..tostring(index))
        end
    end
end

function SWEP:SetBonemergeParents()
    if (SERVER) then
        return
    end
    
    for slot, attachment in pairs(self:GetAllAttachmentsInUse()) do
        if (attachment.Model == nil) then
            continue
        end

        if (attachment.VElement == nil) then
            for slot, attParent in pairs(self:GetAllAttachmentsInUse()) do
                if (attParent.Model == nil) then
                    continue
                end

                if (attParent == attachment) then
                    continue
                end

                if (attachment.BonemergeToCategory != nil && table.HasValue(attachment.BonemergeToCategory, attParent.Category)) then
                    attachment.m_Model:SetParent(attParent.m_Model)
                    attachment.m_TpModel:SetParent(attParent.m_TpModel)
                    
                    attachment.m_Model:SetupBones()
                    attParent.m_Model:SetupBones()

                    if (!mw_utils.CheckMatchingBones(attachment.m_Model, attParent.m_Model)) then
                        attachment.m_Model:SetParent(self:GetViewModel())
                        attachment.m_TpModel:SetParent(self)
                    else
                        break
                    end
                end

                if (attachment.BonemergeToAttachment != nil && table.HasValue(attachment.BonemergeToAttachment, attParent.ClassName)) then
                    if (mw_utils.CheckMatchingBones(attachment.m_Model, attParent.m_Model)) then
                        attachment.m_Model:SetParent(attParent.m_Model)
                        attachment.m_TpModel:SetParent(attParent.m_TpModel)
                        break
                    end
                end
            end
        end
    end
end

function SWEP:GenerateAimOffset()
    if (SERVER) then
        return
    end
    
    for _, attachment in pairs(self:GetAllAttachmentsInUse()) do
        if (attachment.Model == nil) then
            continue
        end

        if (attachment.Reticle != nil) then
            self:GetViewModel():SetPoseParameter("hybrid_offset", 0)
            self:GetViewModel():InvalidateBoneCache()
            self:GetViewModel():SetupBones()

            local alignAttachmentId = mw_utils.LookupAttachmentCached(self:GetViewModel(), self.ViewModelOffsets.Aim.AlignAttachment || "align")

            if (alignAttachmentId != nil) then
                attachment.m_Model:InvalidateBoneCache()
                attachment.m_Model:SetupBones() --shaky otherwise
                attachment.m_Model:GetParent():InvalidateBoneCache()
                attachment.m_Model:GetParent():SetupBones()

                local data = self:GetViewModel():GetAttachment(alignAttachmentId)
                local reticleData = attachment.m_Model:GetAttachment(attachment.m_Model:LookupAttachment(attachment.Reticle.Attachment))

                local localPos, localAng = WorldToLocal(data.Pos, data.Ang, reticleData.Pos, reticleData.Ang)
                attachment.AimPos = Vector(-localPos.y, localPos.x + 4, localPos.z) --converted from stupid cod forward
                attachment.AimAng = Angle(localAng.p, localAng.y, -localAng.r) --shouldnt need to change aim angles

                if (attachment.ReticleHybrid != nil) then
                    local reticle2Data = attachment.m_Model:GetAttachment(attachment.m_Model:LookupAttachment(attachment.ReticleHybrid.Attachment))

                    localPos, localAng = WorldToLocal(reticle2Data.Pos, reticle2Data.Ang, reticleData.Pos, reticleData.Ang)
                    attachment.HybridAimPos = attachment.AimPos + Vector(localPos.y, -localPos.x, -localPos.z) 
                    attachment.HybridAimAng = attachment.AimAng + Angle(localAng.p, localAng.y, -localAng.r)
                end
            end
        end
    end
end

function SWEP:MoveVElement(model, attachment)
    local attModel = model == self:GetViewModel() && attachment.m_Model || attachment.m_TpModel
    local ve = attachment.VElement
    local bone = mw_utils.LookupBoneCached(model, ve.Bone)
    local oPos, oAng = self:GetTotalAttachmentOffset(attachment)

    local ang = Angle()
    ang:RotateAroundAxis(ang:Forward(), ve.Angles.r + oAng.r)
    ang:RotateAroundAxis(ang:Right(), ve.Angles.y + oAng.y)
    ang:RotateAroundAxis(ang:Up(), ve.Angles.p + oAng.p)

    local pos = Vector()
    mw_math.VectorAddAndMul(pos, ang:Forward(), ve.Position.y + oPos.y)
    mw_math.VectorAddAndMul(pos, ang:Right(), ve.Position.x + oPos.x)
    mw_math.VectorAddAndMul(pos, ang:Up(), ve.Position.z + oPos.z)

    attModel:SetLocalPos(pos)
    attModel:SetLocalAngles(ang)
end

function SWEP:GetTotalAttachmentOffset(currentAttachment)
    local pos = Vector()
    local ang = Angle()

    local offsets = currentAttachment.VElement.Offsets

    if offsets != nil then
        for slot, attachment in pairs(self:GetAllAttachmentsInUse()) do
            if (offsets[attachment.ClassName] != nil) then
                pos:Add(offsets[attachment.ClassName][1])
                ang:Add(offsets[attachment.ClassName][2])
            end
        end
    end

    return pos, ang
end

function SWEP:DoBodygroup(name, value)
    local ind = self:GetViewModel():FindBodygroupByName(name)

    if (ind != -1) then
        self:GetViewModel():SetBodygroup(ind, value)
    end

    ind = self:FindBodygroupByName(name)

    if (ind != -1) then
        self:SetBodygroup(ind, value)
    end
end

function SWEP:ResetBodygroups()
    if (IsValid(self:GetViewModel())) then
        self:GetViewModel():SetSkin(0)

        for b = 0, self:GetViewModel():GetNumBodyGroups() do
            self:GetViewModel():SetBodygroup(b, 0)
        end
    end

    if (IsValid(self)) then
        self:SetSkin(0)

        for b = 0, self:GetNumBodyGroups() do
            self:SetBodygroup(b, 0)
        end
    end
end

function SWEP:GetAttachmentModels(slot)
    return self.m_CustomizationInUse[slot].m_Model, self.m_CustomizationInUse[slot].m_TpModel
end

function SWEP:GetSight()
    return self.reticle
end

function SWEP:GetLaser()
    return self.laser
end

function SWEP:GetFlashlightAttachment()
    return self.flashlight
end

function SWEP:GetBipod()
    return self.bipod
end

function SWEP:GetUnderbarrel()
    return self.underbarrel
end

hook.Add("PlayerSwitchFlashlight", "MW19_PlayerSwitchFlashlight", function(ply, enabled)
    local w = ply:GetActiveWeapon()
    if (ply:CanUseFlashlight() && !ply:FlashlightIsOn() && IsValid(w) && weapons.IsBasedOn(w:GetClass(), "mg_base")) then
        if (w:GetFlashlightAttachment() != nil) then
            ply:EmitSound("MW.Flashlight")
            w:ToggleFlag("FlashlightOn")
            return false
        end
    end
end)

function SWEP:HasAttachment(class)
    if (self.Customization == nil) then
        return false
    end

    if (self.m_CustomizationInUse == nil) then
        return false
    end
    
    for slot, att in pairs(self:GetAllAttachmentsInUse()) do
        if (att.ClassName == class) then
            return true
        end
    end

    return false
end

function SWEP:GetBlockerAttachment(attachment)
    for slot, attachmentInUseInSlot in pairs(self:GetAllAttachmentsInUse()) do
        --by class name (very specific)
        if (attachmentInUseInSlot.ExcludedAttachments != nil) then
            if (table.HasValue(attachmentInUseInSlot.ExcludedAttachments, attachment.ClassName)) then
                return attachmentInUseInSlot
            end
        end

        --by category name (broad for more attachments)
        if (attachmentInUseInSlot.ExcludedCategories != nil) then
            if (table.HasValue(attachmentInUseInSlot.ExcludedCategories, attachment.Category)) then
                return attachmentInUseInSlot
            end

            if (table.HasValue(attachmentInUseInSlot.ExcludedCategories, attachment.CategoryAliases || {})) then
                return attachmentInUseInSlot
            end
        end

        if (attachment.ExcludedByAttachments != nil && table.HasValue(attachment.ExcludedByAttachments, attachmentInUseInSlot.ClassName)) then
            return attachmentInUseInSlot
        end

        if (attachment.ExcludedByCategories != nil && table.HasValue(attachment.ExcludedByCategories, attachmentInUseInSlot.Category) && attachmentInUseInSlot.Index > 1) then
            return attachmentInUseInSlot
        end
    end

    return nil
end

function SWEP:IsAttachmentAllowed(attachment)
    if (attachment.Index == nil || attachment.Index > 1) then
        if (!attachment.CosmeticChange) then
            local attLimit = GetConVar("mgbase_sv_customization_limit"):GetInt()
            local currentCount = 0

            for slot, attachmentInUseInSlot in pairs(self:GetAllAttachmentsInUse()) do
                if (attachment != attachmentInUseInSlot && attachmentInUseInSlot.Index > 1 && !attachmentInUseInSlot.CosmeticChange) then
                    currentCount = currentCount + 1
                end
            end

            if (attLimit > 0 && currentCount >= attLimit) then
                return false
            end
        end

        if (hook.Run("MW19_AllowAttachment", self, attachment) == false) then
            return false
        end

        if (self:GetBlockerAttachment(attachment) != nil) then
            return false
        end
    end

    return true
end

function SWEP:SetGripPoseParameter(value)
    if (CLIENT) then
        if (self.GripPoseParameters == nil) then
            mw_utils.ErrorPrint("SetGripPoseParameter: No left hand grip pose parameters have been defined!")
            return
        end

        if (!table.HasValue(self.GripPoseParameters, value)) then
            mw_utils.ErrorPrint("SetGripPoseParameter: Left hand grip pose parameter " ..value.. " was not defined in GripPoseParameters!")
            return
        end

        self:GetViewModel().m_LeftHandGripPoseParameter = value
    end
end

function SWEP:SetGripPoseParameter2(value)
    if (CLIENT) then
        if (self.GripPoseParameters2 == nil) then
            mw_utils.ErrorPrint("SetGripPoseParameter2: No right hand grip pose parameters have been defined!")
            return 
        end

        if (!table.HasValue(self.GripPoseParameters2, value)) then
            mw_utils.ErrorPrint("SetGripPoseParameter2: Right hand grip pose parameter " ..value.. " was not defined in GripPoseParameters2!")
            return
        end

        self:GetViewModel().m_RightHandGripPoseParameter = value
    end
end

function SWEP:SetGripPoseParameter3(value)
    if (CLIENT) then
        if (self.GripPoseParameters3 == nil) then
            mw_utils.ErrorPrint("SetGripPoseParameter3: No misc grip pose parameters have been defined!")
            return 
        end

        if (!table.HasValue(self.GripPoseParameters3, value)) then
            mw_utils.ErrorPrint("SetGripPoseParameter3: Misc grip pose parameter " ..value.. " was not defined in GripPoseParameters3!")
            return
        end

        self:GetViewModel().m_MiscGripPoseParameter = value
    end
end

function SWEP:SetWorldModel(path)
   self:SetModel(path)
   self.WorldModel = path
end