Markers = {}

--[[ Functions ]]--
function TryTask(id)
	local task = Tasks[id]
	local taskSettings = Config.Tasks[task.task]

	if taskSettings.Condition then
		local status, result = pcall(function()
			return taskSettings.Condition()
		end)
		if not result then return end
	end

	TriggerServerEvent("tasks:begin", id)
end

function StartTask(id)
	local task = Tasks[id]
	local taskSettings = Config.Tasks[task.task]

	local ped = PlayerPedId()
	local coords = vector3(task.coords.x, task.coords.y, task.coords.z)
	local heading = task.coords.w

	-- Walk to the coords.
	local cancelled = false

	TaskGoToCoordAnyMeans(ped, coords.x, coords.y, coords.z, 1.0, 0, 0, 786603, 0xbf800000)
	Citizen.Wait(100)
	while GetIsTaskActive(ped, 224) and #(GetEntityCoords(ped) - coords) > 0.3 do
		Citizen.Wait(0)
		for k, v in ipairs({ 22, 24, 25, 30, 31, 32, 33, 34, 35, 36 }) do
			if IsControlPressed(0, v) then
				cancelled = true
				ClearPedTasks(ped)
				ClearPedSecondaryTask(ped)
				break
			end
		end
	end
	
	if cancelled then
		TriggerServerEvent("tasks:finish", id, true)
		return
	end

	-- Face the coords.
	local targetCoords = coords + exports.misc:FromRotation(vector3(0.0, 0.0, heading + 90))
	TaskTurnPedToFaceCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, 5000)
	Citizen.Wait(100)
	while exports.misc:Dot(GetEntityForwardVector(ped), targetCoords - coords) < 0.8 do
		for k, v in ipairs({ 22, 24, 25, 30, 31, 32, 33, 34, 35, 36 }) do
			if IsControlPressed(0, v) then
				cancelled = true
				ClearPedTasks(ped)
				ClearPedSecondaryTask(ped)
				break
			end
		end
		Citizen.Wait(0)
	end

	if cancelled then
		TriggerServerEvent("tasks:finish", id, true)
		return
	end
	
	-- Begin task.
	if taskSettings.Begin then
		pcall(taskSettings.Begin)
	end

	exports.mythic_progbar:Progress(taskSettings.Action, function(wasCancelled)
		TriggerServerEvent("tasks:finish", id, wasCancelled)

		if taskSettings.Result then
			pcall(function()
				taskSettings.Result(nil, wasCancelled)
			end)
		end
	end)
end

--[[ Events ]]--
RegisterNetEvent("tasks:begin")
AddEventHandler("tasks:begin", function(id)
	StartTask(id)
end)

AddEventHandler("tasks:add", function(id, task, coords)
	local taskSettings = Config.Tasks[task]
	local callbackId = "Tasks_"..tostring(id)
	Markers[id] = {
		exports.markers:CreateUsable(GetCurrentResourceName(), coords, callbackId, taskSettings.Label or "???", 2.0, 1.0),
		AddEventHandler("markers:use_"..callbackId, function()
			TryTask(id)
		end)
	}
end)

AddEventHandler("tasks:remove", function(id)
	local marker = Markers[id]
	if marker then
		exports.markers:Remove(marker[1])
		RemoveEventHandler(marker[2])
	end
end)

AddEventHandler("tasks:clientStart", function()
	Initialize()
end)