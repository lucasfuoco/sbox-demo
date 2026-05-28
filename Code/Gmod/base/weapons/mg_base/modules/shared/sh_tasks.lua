AddCSLuaFile()
require("mw_utils")

SWEP.Tasks = {}
SWEP.m_bTickingTasks = false

function SWEP:RegisterTask(task)
    for t, registeredTask in pairs(self.Tasks) do
        if (registeredTask.Name == task.Name) then
            --mw_utils.ErrorPrint("RegisterTask: Trying to register a task that's already registered! (" .. task.Name .. ")")
            --i dont know if i should block that for now
            self.Tasks[t] = table.Copy(task)
            return
        end
    end

    self.Tasks[#self.Tasks + 1] = table.Copy(task)
end

function SWEP:RemoveTask(name)
    for t = #self.Tasks, 1, -1 do
        if (self.Tasks[t].Name == name) then
            table.remove(self.Tasks, t)
            break
        end
    end
end

function SWEP:TrySetTask(name)
    local requestedTaskIndex = 0

    for i, task in pairs(self.Tasks) do
        if (task.Name == name) then
            requestedTaskIndex = i
            break
        end
    end

    if (requestedTaskIndex == 0) then
        mw_utils.ErrorPrint("TrySetTask: Trying to set a task that doesn't exist! (" .. name .. ")")
        return
    end

    local requestedTask = self.Tasks[requestedTaskIndex]
    local currentTask = self.Tasks[self:GetCurrentTask()]

	local reqPriority = requestedTask.Priority
	local curPriority = currentTask != nil && currentTask.Priority || 0
	
	if GetConVar("mgbase_sv_sprintreloads"):GetBool() then
		if currentTask != nil && currentTask.Flag == "Reloading" then
			curPriority = 7
		elseif requestedTask.Flag == "Reloading" then
			reqPriority = 7
		end
	end
	
    if (!self.m_bTickingTasks && reqPriority <= curPriority) then
        return
    end

    if (!requestedTask:CanBeSet(self)) then
        return
    end

    if (currentTask != nil) then
        if (currentTask.Flag != nil) then
            self:RemoveFlag(currentTask.Flag)
        end

        if (currentTask.OnInterrupted != nil) then
            currentTask:OnInterrupted(self, requestedTask.Name)
        end
    end

    self:SetCurrentTask(requestedTaskIndex)
    currentTask = self.Tasks[self:GetCurrentTask()]

    if (currentTask.Flag != nil) then
        self:AddFlag(currentTask.Flag)
    end

    if (currentTask.OnSet != nil) then
        currentTask:OnSet(self)
    end

    mw_utils.DevPrint("TrySetTask: Set " .. currentTask.Name)
end

function SWEP:TickTasks()
    local currentTask = self.Tasks[self:GetCurrentTask()]

    self.m_bTickingTasks = true

    if (currentTask != nil && currentTask:Think(self)) then
        mw_utils.DevPrint("TickTasks: Done with " .. currentTask.Name)

        if (currentTask.Flag != nil) then
            self:RemoveFlag(currentTask.Flag)
        end

        if (self.Tasks[self:GetCurrentTask()] == currentTask) then
            self:SetCurrentTask(0) --no task
        end
    end

    self.m_bTickingTasks = false
end

function SWEP:GetTaskByName(name)
    for _, task in pairs(self.Tasks) do
        if (task.Name == name) then
            return task
        end
    end

    return nil
end