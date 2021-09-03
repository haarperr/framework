-- RegisterNetEvent("vehicles:requestKey", function(netId)
-- 	local entity = NetworkGetEntityFromNetworkId(netId)
-- 	if not entity then return end

	
-- end)

RegisterNetEvent("vehicles:toggleEnigne", function(netId)
	local source = source

	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity then return end

	local value = not GetIsVehicleEngineRunning(entity)

	print("toggle engine", entity, value)

	TriggerClientEvent("vehicles:toggleEngine", source, netId, value)
end)