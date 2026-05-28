AddCSLuaFile()

require("mw_math")
require("mw_utils")

function SWEP:RenderOverride(flags)
    if (IsValid(self.SpawnEffect)) then
        self.SpawnEffect.ParentEntity = nil
        --https://github.com/Facepunch/garrysmod-issues/issues/5345
    end

    if (GetConVar("mgbase_debug_wmrender"):GetInt() <= 0) then
        return
    end

    local bone = mw_utils.LookupBoneCached(self, self.WorldModelOffsets.Bone)

    if (bone != nil && bone > 0) then
        if (IsValid(self:GetOwner())) then
            self:ManipulateBoneAngles(bone, self.WorldModelOffsets.Angles)
            self:ManipulateBonePosition(bone, self.WorldModelOffsets.Pos)
        else
            self:ManipulateBoneAngles(bone, mw_math.ZeroAngle)
            self:ManipulateBonePosition(bone, mw_math.ZeroVector)
        end
    end

    --self:InvalidateBoneCache()
    self:SetupBones()

    self:DrawModel(flags)

    for _, att in pairs(self:GetAllAttachmentsInUse()) do
        if (IsValid(att.m_TpModel) && #att.m_TpModel:GetChildren() <= 0 && !att.DisableWorldModelRender) then
            att.m_TpModel:DrawModel(flags)

            if ((!att.RenderOverride && att.Render != nil) || att.WorldModelRender != nil) then
                if (att.WorldModelRender != nil) then
                    att:WorldModelRender(self)
                else
                    att:Render(self, att.m_TpModel)
                end
            end
        end
    end
end

function SWEP:DrawWorldModel(flags)
    self:DrawModel(flags)
end

function SWEP:DrawWorldModelTranslucent(flags)
    self:DrawWorldModel(flags)
end