ActiveTasks = {}

--[[ Events ]]--
RegisterNetEvent("tasks:begin")
AddEventHandler("tasks:begin", function(id)
	local source = source

	local task = Tasks[id]
	if not task then return end

	local taskSettings = Config.Tasks[task.task]
	if not taskSettings then return end

	local activeTask = ActiveTasks[id]
	if activeTask then
		if activeTask.state == 1 and (os.clock() - activeTask.time) * 1000 < (taskSettings.Duration or taskSettings.Action.Duration or 0) then
			TriggerClientEvent("notify:sendAlert", source, "error", "That's already occupied...", 7000)
			return
		elseif activeTask.state == 2 and (taskSettings.Cooldown == -1 or (os.clock() - activeTask.time) * 1000 < (taskSettings.Cooldown or 0)) then
			TriggerClientEvent("notify:sendAlert", source, "error", "There's nothing left here...", 7000)
			return
		end
	end

	if taskSettings.Condition then
		local status, result = pcall(function()
			return taskSettings.Condition(source)
		end)
		if not result then return end
	end
	
	if taskSettings.Begin then
		pcall(function()
			taskSettings.Begin(source)
		end)
	end

	ActiveTasks[id] = { source = source, state = 1, time = os.clock() }

	TriggerClientEvent("tasks:begin", source, id)
end)

RegisterNetEvent("tasks:finish")
AddEventHandler("tasks:finish", function(id, wasCancelled)
	local source = source

	local task = Tasks[id]
	if not task then return end

	local taskSettings = Config.Tasks[task.task]
	if not taskSettings then return end

	local activeTask = ActiveTasks[id]
	if activeTask.source ~= source then return end

	-- Only finish in progress tasks.
	if activeTask.state ~= 1 then return end
	
	-- Clear a canceled task.
	if wasCancelled then
		ActiveTasks[id] = nil
		return
	end

	-- Check conditions.
	if taskSettings.Condition then
		local status, error = pcall(function()
			return taskSettings.Condition(source)
		end)
		if not error then
			ActiveTasks[id] = nil
			return
		end
	end

	-- Finish a non canceled task.
	activeTask.state = 2
	activeTask.time = os.clock()
	
	-- Log it.
	exports.log:Add({
		source = source,
		verb = "finished",
		noun = "task",
		extra = ("id: %s"):format(id),
		channel = "misc",
	})

	-- Results.
	if taskSettings.Result then
		pcall(function()
			taskSettings.Result(source, wasCancelled)
		end)
	end
end)

AddEventHandler("tasks:start", function()
	Initialize()
end)