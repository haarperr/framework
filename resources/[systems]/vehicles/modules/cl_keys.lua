--[[ Functions: Main ]]--
function Main.update:Ignition()
	
end

function Main:ToggleEngine(value)
	if not IsDriver then return end

	TriggerServerEvent("vehicles:toggleEnigne", netId)

	-- if value == nil then
	-- 	value = not GetIsVehicleEngineRunning(CurrentVehicle)
	-- end

	-- SetVehicleEngineOn(CurrentVehicle, value, false, true)
end

--[[ Listeners ]]--


--[[ Commands ]]--
RegisterCommand("+nsrp_ignition", function()
	if not IsControlEnabled(0, 51) then
		return
	end

	Main:ToggleEngine()
end, true)

RegisterKeyMapping("+nsrp_ignition", "Vehicles - Ignition", "keyboard", "i")