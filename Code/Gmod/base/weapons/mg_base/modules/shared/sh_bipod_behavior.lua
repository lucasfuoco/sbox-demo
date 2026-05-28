AddCSLuaFile()

function SWEP:CanDeployBipod()
    if (self:GetCurrentTask() > 0 && !self.Tasks[self:GetCurrentTask()].bCanBipod) then
        return false
    end

    return true
end

function SWEP:BipodLogic()
    if (self:GetBipod() == nil || !self:CanDeployBipod()) then
        if (self:HasFlag("BipodDeployed")) then
            self:EmitSound("ViewModel.BipodExit")
        end

        self:RemoveFlag("BipodDeployed")
        return
    end

    local bDeployed = false

    if (!self:IsOwnerMoving() && self:GetOwner():IsOnGround()) then
        local pos = self:GetOwner():EyePos() + Angle(0, self:GetOwner():EyeAngles().y, 0):Forward() * 16
        
        if (!self:GetOwner():Crouching()) then
            local tr = util.TraceHull({
                start = pos,
                endpos = pos - Vector(0, 0, 32),
                mins = Vector(-16, -16, 0),
                maxs = Vector(16, 16, 2),
                filter = player.GetAll(),
                mask = MASK_PLAYERSOLID
            })
            
            bDeployed = tr.Hit && !tr.StartSolid
        else
            bDeployed = true
        end
    end

    if (self:HasFlag("BipodDeployed") != bDeployed) then
        if (bDeployed) then
            self:EmitSound("ViewModel.BipodDeploy")

            if (self:GetCurrentTask() == 0 && !self:HasFlag("Aiming")) then
                self:PlayViewModelAnimation(self:GetAnimation("Bipod_Deploy") != nil && "Bipod_Deploy" || "Jog_Out")
            end
        else
            self:EmitSound("ViewModel.BipodExit")

            if (self:GetCurrentTask() == 0 && !self:HasFlag("Aiming")) then
                self:PlayViewModelAnimation(self:GetAnimation("Bipod_Leave") != nil && "Bipod_Leave" || "Jog_Out")
            end
        end
    end

    if (bDeployed) then
        self:AddFlag("BipodDeployed")
    else
        self:RemoveFlag("BipodDeployed")
    end
end