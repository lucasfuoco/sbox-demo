ATTACHMENT.Name = "Attachment"
ATTACHMENT.Category = "Attachments"
ATTACHMENT.Icon = Material("mg/genericattachment")
ATTACHMENT.RenderOverride = false
ATTACHMENT.ShowOnWorldModel = true
function ATTACHMENT:Render(weapon)
    if (self == weapon.bipod) then
        if (IsValid(self.m_Model)) then
            self.m_Model:SetPoseParameter("bipod", weapon:HasFlag("BipodDeployed") && 1 || 0)
        end

        if (IsValid(self.m_TpModel)) then
            self.m_TpModel:SetPoseParameter("bipod", weapon:HasFlag("BipodDeployed") && 1 || 0)
        end
    end
end
function ATTACHMENT:Stats(weapon)
end
function ATTACHMENT:PostProcess(weapon)
end
function ATTACHMENT:Appearance(model, category)
end
function ATTACHMENT:Init(weapon)
end
function ATTACHMENT:PostInitModels(weapon)
end
function ATTACHMENT:OnRemove(weapon)
    if (CLIENT) then
        if (IsValid(self.m_Model)) then
            self.m_Model:Remove()
        end

        if (IsValid(self.m_TpModel)) then
            self.m_TpModel:Remove()
        end
    end
end

--new functionality to replace materials in model
--if returned path + mat doesn't exist on disk, default material will be applied
function ATTACHMENT:OverrideMaterial(path, mat)
    return path, mat
end

--new functionality to replace materials in weapon (viewmodel / worldmodel)
--if returned path + mat doesn't exist on disk, default material will be applied
function ATTACHMENT:OverrideWeaponMaterial(path, mat)
    return path, mat 
end

--new functionality to replace materials in other attachments
--if returned path + mat doesn't exist on disk, default material will be applied
function ATTACHMENT:OverrideAttachmentsMaterial(path, mat)
    return path, mat 
end

--playermodel color support for attachment model!
function ATTACHMENT:EnablePlayerColor(weapon)
    if (CLIENT) then
        if (IsValid(self.m_Model)) then
            self.m_Model.plyColor = Vector()
    
            function self.m_Model:GetPlayerColor()
                if (IsValid(weapon) && IsValid(weapon:GetOwner()) && weapon:GetOwner().GetPlayerColor != nil) then
                    self.plyColor = weapon:GetOwner():GetPlayerColor()
                end
    
                return self.plyColor
            end
        end
    
        if (IsValid(self.m_TpModel)) then
            self.m_TpModel.plyColor = Vector()
    
            function self.m_TpModel:GetPlayerColor()
                if (IsValid(weapon) && IsValid(weapon:GetOwner()) && weapon:GetOwner().GetPlayerColor != nil) then
                    self.plyColor = weapon:GetOwner():GetPlayerColor()
                end
    
                return self.plyColor
            end
        end
    end
end