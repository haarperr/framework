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
		TriggerClientEvent("taxi-job:updateSavedRate", source, value)
	end

	if not Vehicles[vehicle] then
		Vehicles[vehicle] = {}
	end
	Vehicles[vehicle][key] = value
end)

RegisterNetEvent("taxi-job:getDropoffLocation")
AddEventHandler("taxi-job:getDropoffLocation", function()
	local source = source
	
	local blacklist = {
		"growroom",
		"drugroom",
		"counterfeit",
		"bunker",
		"facility",
		"sewer",
		"cayo_villa",
		"court_house",
		"samsoffice",
		"security"
	}

	local property = nil
	while not property do
		local randomProperty = exports.properties:GetRandomProperty()

		for k, v in ipairs(blacklist) do
			if randomProperty.type == v then goto continue end
		end

		property = randomProperty

		::continue::
	end

	TriggerClientEvent("taxi-job:sendDropoffLocation", source, property)
end)

RegisterNetEvent("taxi-job:completeFare")
AddEventHandler("taxi-job:completeFare", function(netId, name)
	local source = source
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(vehicle) then return end
	
	local job = exports.jobs:GetJob(name:lower())
	if not job then return end

	exports.log:Add({
		source = source,
		verb = "dropped off taxi fare",
		extra = ("job: %s"):format(name),
	})
	
	local pay = tonumber(string.format("%.2f", Vehicles[vehicle].fare))
	if type(pay) == "number" then
		local paycheck = exports.character:Get(source, "paycheck")
		paycheck = paycheck + pay
		exports.character:Set(source, "paycheck", paycheck)
		TriggerClientEvent("chat:addMessage", source, ("$%s has gone to your paycheck. You have $%s to collect."):format(exports.misc:FormatNumber(pay), exports.misc:FormatNumber(paycheck)))
	end
end)

AddEventHandler("entityRemoved", function(entity)
	if Vehicles[entity] then
		Vehicles[entity] = nil
	end
end)