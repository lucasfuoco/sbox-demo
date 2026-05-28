--Class for VElements that have two magazines in their animations
require("mw_utils")
ATTACHMENT.Base = "att_magazine"

ATTACHMENT.VElement2 = {
    Bone = "j_mag2",
    Position = Vector(),
    Angles = Angle(),
    Offsets = {}
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Init(weapon)
    BaseClass.Init(self, weapon)

    if (CLIENT) then
        self.m_Model2 = ClientsideModel(self.Model, weapon.RenderGroup)
        self.m_Model2:SetRenderMode(weapon.RenderMode)
        self.m_Model2:SetMoveType(MOVETYPE_NONE)
        self.m_Model2:SetOwner(weapon:GetViewModel())
        self.m_Model2.bAttachmentRenderOverride = self.RenderOverride

        self.m_Model2:FollowBone(weapon:GetViewModel(), mw_utils.LookupBoneCached(weapon:GetViewModel(), self.VElement2.Bone))

        --hack to move element
        local oldve = table.Copy(self.VElement)
        local oldModel = self.m_Model

        self.VElement = table.Copy(self.VElement2)
        self.m_Model = self.m_Model2
        weapon:MoveVElement(weapon:GetViewModel(), self)

        self.VElement = oldve
        self.m_Model = oldModel
    end
end

function ATTACHMENT:OnRemove(weapon)
    BaseClass.OnRemove(self, weapon)

    if (CLIENT) then
        if (IsValid(self.m_Model2)) then
            self.m_Model2:Remove()
        end
    end
end

function ATTACHMENT:Render(weapon)
    BaseClass.Render(self, weapon)

    if (IsValid(self.m_Model2)) then
    --    self.m_Model2:DrawModel()
    end
end