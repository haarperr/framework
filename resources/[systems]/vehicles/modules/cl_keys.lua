Main:AddListener("Enter", function(vehicle)

end)

function Main.update:Ignition()
	
end

function Main:ToggleEngine(value)
	if not IsDriver then return end

	if value == nil then
		value = not GetIsVehicleEngineRunning(CurrentVehicle)
	end

	SetVehicleEngineOn(CurrentVehicle, value, false, true)
end

--[[ Keys ]]--
RegisterCommand("+nsrp_ignition", function()
	if not IsControlEnabled(0, 51) then
		return
	end

	Main:ToggleEngine()
end, true)

RegisterKeyMapping("+nsrp_ignition", "Vehicles - Ignition", "keyboard", "i")