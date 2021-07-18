Callback = nil
CurrentStage = 1
MaxStage = 1
LastSuccess = nil
IsOpen = false

--[[ Threads ]]--
-- Citizen.CreateThread(function()
-- 	while true do
-- 		if IsOpen then
-- 			-- SetCursorLocation(0.0, 0.0)
-- 		end

-- 		Citizen.Wait(0)
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)

-- 	TriggerEvent("quickTime:begin", "linear", 10.0, function(status)
-- 		print(status)
-- 	end)
-- end)

--[[ Functions ]]--
function Begin(_type, size, callback, stage)
	if type(size) == "table" then
		MaxStage = #size

		for k, _size in ipairs(size) do
			if LastSuccess == false then
				LastSuccess = nil
				return
			end

			Begin(_type, _size, callback, k)

			while IsOpen do
				Citizen.Wait(0)
			end
		end
		return
	end
	
	if GetResourceState("inventory") == "started" then
		exports.inventory:ToggleMenu(false)
	end

	CurrentStage = stage
	Callback = callback
	IsOpen = true
	LastSuccess = nil
	
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(false)

	SendNUIMessage({
		type = _type or "linear",
		size = size,
	})
end

function End(status)
	-- if status == nil then
	-- 	SendNUIMessage({ close = true })
	-- end

	if MaxStage == CurrentStage then
		LastSuccess = nil
	else
		LastSuccess = status
	end

	IsOpen = false
	SetNuiFocus(false, false)
	
	if Callback then
		pcall(function()
			Callback(status, CurrentStage)
		end)
		
		Callback = nil
	end
end

--[[ Events ]]--
RegisterNetEvent("quickTime:begin")
AddEventHandler("quickTime:begin", function(_type, size, callback)
	Begin(_type, size, callback)
end)

RegisterNetEvent("quickTime:end")
AddEventHandler("quickTime:end", function(status)
	End(status)
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("finish", function(data)
	End(data.status)
end)