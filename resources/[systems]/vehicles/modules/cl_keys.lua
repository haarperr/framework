--[[ Functions: Main ]]--
function Main.update:Ignition()
	
end

function Main:ToggleEngine()
	if not IsDriver then return end

	local netId = GetNetworkId(CurrentVehicle)
	if not netId then return end
	
	if not DoesVehicleHaveEngine(CurrentVehicle) then
		print("no engine")
		return
	end

	TriggerServerEvent("vehicles:toggleEnigne", netId)
end

--[[ Listeners ]]--

--[[ Events ]]--
RegisterNetEvent("vehicles:toggleEngine", function(netId, state)
	local _netId = GetNetworkId(CurrentVehicle)
	if not _netId or _netId ~= netId then return end

	SetVehicleEngineOn(CurrentVehicle, state, false, true)
end)

--[[ Commands ]]--
RegisterCommand("+nsrp_ignition", function()
	if not IsControlEnabled(0, 51) then
		return
	end

	Main:ToggleEngine()
end, true)

RegisterKeyMapping("+nsrp_ignition", "Vehicles - Ignition", "keyboard", "i")