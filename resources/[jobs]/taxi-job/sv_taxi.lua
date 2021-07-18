Vehicles = {}

RegisterNetEvent("taxi-job:requestVehicle")
AddEventHandler("taxi-job:requestVehicle", function(netId, key)
	local source = source
	if type(netId) ~= "number" then return end
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(vehicle) then return end
	
	TriggerClientEvent("taxi-job:receiveVehicle", source, Vehicles[vehicle] or {})
end)

RegisterNetEvent("taxi-job:updateVehicle")
AddEventHandler("taxi-job:updateVehicle", function(netId, key, value)
	local source = source
	if type(netId) ~= "number" or type(value) ~= "number" or type(key) ~= "string" then return end
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(vehicle) then return end

	if key == "rate" then
		value = math.min(math.max(value, 0.0), 100.0)
	end

	if not Vehicles[vehicle] then
		Vehicles[vehicle] = {}
	end
	Vehicles[vehicle][key] = value
end)

AddEventHandler("entityRemoved", function(entity)
	if Vehicles[entity] then
		Vehicles[entity] = nil
	end
end)