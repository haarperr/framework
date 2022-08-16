Garages = {}
Vehicles = {}
VehicleCache = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	InitializeGarages()
end)

--[[ Functions ]]--
function InitializeGarages()
	-- Add or update garages to the database from the config file.
	local queries = {}
	
	for name, garage in pairs(Config.Garages) do
		if garage.Id then goto continue end

		queries[#queries + 1] =
		[[
			INSERT INTO garages SET
				`limit`=]]..garage.Limit..[[,
				`type`="]]..garage.Type..[[",
				`name`="]]..name..[["
			ON DUPLICATE KEY UPDATE
				`limit`=]]..garage.Limit..[[,
				`type`="]]..garage.Type..[["
		]]
		
		::continue::
	end

	exports.GHMattiMySQL:Transaction(queries)
	local garages = exports.GHMattiMySQL:QueryResult("SELECT * FROM garages")

	for k, garage in ipairs(garages) do
		if garage.name then
			-- Configured garages.
			local garageConfig = Config.Garages[garage.name]
			if garageConfig then
				garage.inCoords = garageConfig.InCoords
				garage.outCoords = garageConfig.OutCoords
			end
		else
			-- Custom garages.
			garage.inCoords = vector4(garage.x, garage.y, garage.z, garage.w)
			garage.outCoords = garage.inCoords
		end
		Garages[garage.id] = garage
	end
	
	TriggerClientEvent("garages:receiveGarages", -1, Garages)
end

function AddGarage(garage, callback)
	exports.GHMattiMySQL:Insert("garages", {
		garage
	}, function(id)
		garage.id = id
		garage.inCoords = vector4(garage.x, garage.y, garage.z, garage.w)
		garage.outCoords = garage.inCoords

		Garages[id] = garage
		TriggerClientEvent("garages:receiveGarages", -1, Garages)

		if callback then
			pcall(function() callback(id) end)
		end
	end, true)
end
exports("AddGarage", AddGarage)

function GetVehicle(source, id, character)
	if not id then
		if source then
			return VehicleCache[source]
		end
		return
	end

	local character = character or exports.character:GetCharacter(source)
	if not character then return end

	local vehicle = exports.GHMattiMySQL:QueryResult("SELECT * FROM vehicles WHERE id=@id AND character_id=@character_id AND deleted=0", {
		["@id"] = id,
		["@character_id"] = character.id,
	})[1]

	return ConvertTableResult({vehicle})[1]
end
exports("GetVehicle", GetVehicle)

function GetVehicleByPlate(plate)
	if not plate then
		return false
	end

	local vehicle = exports.GHMattiMySQL:QueryResult("SELECT * FROM vehicles WHERE plate=@plate AND deleted=0", {
		["@plate"] = plate,
	})[1]

	return ConvertTableResult({vehicle})[1]
end
exports("GetVehicleByPlate", GetVehicleByPlate)

function AddVehicle(source, model, garage, func)
	local character = exports.character:GetCharacter(source)
	if not character then return end

	local vehicle = {
		character_id = character.id,
		model = model,
		garage_id = garage or 1,
		fuel = 100,
		body_health = 1000,
		engine_health = 1000,
		fuel_health = 1000,
	}

	exports.GHMattiMySQL:Insert("vehicles", {
		vehicle
	}, function(id)
		exports.log:Add({
			source = source,
			verb = "added",
			noun = "vehicle",
			extra = ("model: %s - garage: %s"):format(model, garage),
		})
		
		vehicle.id = id

		local vehicleData = {
			id = id,
			character_id = character.id,
			model = model,
			garage_id = garage or 1,
		}

		character.vehicles = character.vehicles or {}
		character.vehicles[id] = vehicleData
		exports.character:Set(source, "vehicles", character.vehicles)
		
		if func then
			pcall(function() func(vehicleData) end)
		end
	end, true)
end
exports("AddVehicle", AddVehicle)

function DeleteVehicle(id)
	local result = exports.GHMattiMySQL:QueryScalar("SELECT `deleted` FROM `vehicles` WHERE `id`=@id", { ["@id"] = id })

	if result ~= 0 then return false end

	exports.GHMattiMySQL:Query("UPDATE `vehicles` SET deleted=1 WHERE `id`=@id", { ["@id"] = id })

	local cache = VehicleCache[id]
	if cache and DoesEntityExist(cache.entity or 0) then
		DeleteEntity(cache.entity)
	end

	if cache.vehicle then
		local characterId = cache.vehicle.character_id
		if characterId then
			local source = exports.character:GetCharacterById(id)
			if source then
				local vehicles = exports.character:Get(source, "vehicles")
				vehicles[id] = nil
				exports.character:Set(source, "vehicles", vehicles)
			end
		end
	end

	return true
end
exports("DeleteVehicle", DeleteVehicle)

function StoreVehicle(source, id, entity, info)
	local character = exports.character:GetCharacter(source)
	if not character then return end
	
	local vehicle = GetVehicle(source, id, character)
	if not vehicle then return end

	exports.log:Add({
		source = source,
		verb = "stored",
		noun = "vehicle",
		extra = ("model: %s - id: %s"):format(vehicle.model or "?", id or "?"),
	})

	Vehicles[entity] = nil
	VehicleCache[id] = nil

	if not info then return end
	if type(info.garage_id) ~= "number" then return end

	character.vehicles[vehicle.id].garage_id = info.garage_id
	exports.character:Set(source, "vehicles", character.vehicles)

	local query = "UPDATE vehicles SET "
	local params = {
		["@id"] = id,
		["@character_id"] = character.id
	}
	for k, field in ipairs(Config.CustomFields) do
		if k ~= 1 then
			query = query..", "
		end
		query = query.."`"..field.."`=@"..field

		local value = info[field]
		if type(value) == "table" then
			value = json.encode(value)
		elseif type(value) == "string" then
			return
		end

		params["@"..field] = value
	end
	exports.GHMattiMySQL:Query(query.." WHERE id=@id AND character_id=@character_id", params)
end

function GetId(vehicle)
	local _vehicle = Vehicles[vehicle]
	if not _vehicle then return nil end

	return _vehicle.id
end
exports("GetId", GetId)

--[[ Events ]]--
RegisterNetEvent("garages:storeVehicle")
AddEventHandler("garages:storeVehicle", function(id, netId, info)
	local source = source
	if type(id) ~= "number" then return end

	local entity = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(entity) then return end

	StoreVehicle(source, id, entity, info)
	TriggerClientEvent("garages:storeVehicle", source, netId)
end)

RegisterNetEvent("garages:retrieveVehicle")
AddEventHandler("garages:retrieveVehicle", function(id)
	local source = source

	local oldVehicle = (VehicleCache[id] or {}).entity or 0
	if oldVehicle ~= 0 and DoesEntityExist(oldVehicle) then
		DeleteEntity(oldVehicle)
		while DoesEntityExist(oldVehicle) do
			Citizen.Wait(200)
		end
	end

	local vehicle = GetVehicle(source, id)
	if not vehicle then return end

	local garage = Garages[vehicle.garage_id or false]
	local value = (garage.property_id ~= nil and 0) or GetStorageValue(vehicle.model)

	if value > 0 then
		if not exports.inventory:CanAfford(source, value, 0, true) then return end
		exports.inventory:TakeMoney(source, value, 0, true)
	end
	
	local oldPlate = vehicle.plate
	vehicle.plate = (oldPlate or exports.misc:GetRandomText(vehicle.id, 8)):upper():gsub("%s+", "")
	
	if oldPlate ~= vehicle.plate then
		exports.GHMattiMySQL:QueryAsync("UPDATE vehicles SET plate=@plate WHERE id=@id", {
			["@id"] = vehicle.id,
			["@plate"] = vehicle.plate,
		})
	end

	exports.log:Add({
		source = source,
		verb = "retrieved",
		noun = "vehicle",
		extra = ("model: %s - id: %s"):format(vehicle.model or "?", vehicle.id or "?"),
	})

	TriggerClientEvent("garages:retrieveVehicle", source, vehicle)

	VehicleCache[id] = { vehicle = vehicle, entity = nil }
end)

RegisterNetEvent("garages:retrievedVehicle")
AddEventHandler("garages:retrievedVehicle", function(netId, id, class)
	local source = source

	if class and type(class) ~= "number" then return end

	local character = exports.character:GetCharacter(source)
	if not character then return end

	local vehicle = (VehicleCache[id] or {}).vehicle
	if not vehicle or vehicle.character_id ~= character.id then return end

	if not netId then return end
	local entity
	
	local attempts = 15
	for i = 1, attempts do
		entity = NetworkGetEntityFromNetworkId(netId)
		if DoesEntityExist(entity) then
			break
		else
			Citizen.Wait(200)
		end
	end

	if not DoesEntityExist(entity) then
		Citizen.Trace(("[VEHICLES] [%s] Failed receiving vehicle after %s attempts for non-existent vehicle: %s\n"):format(source, attempts, netId))
		return
	end
	
	TriggerEvent("vehicle:loaded", source, vehicle, entity, class)

	if class ~= 13 then
		TriggerEvent("vehicles:subscribe", netId, true)
		exports.vehicles:GiveKey(source, netId)
	end

	TriggerEvent("vehicles:subscribe", netId, true)
	exports.vehicles:GiveKey(source, netId)

	Vehicles[entity] = {
		source = source,
		id = id,
		netId = netId,
		class = class,
	}

	if VehicleCache[id] then
		VehicleCache[id].entity = entity
	else
		VehicleCache[id] = { vehicle = vehicle, entity = entity }
	end
end)

AddEventHandler("character:selected", function(source, character)
	if character then
		local vehicles = {}
		local result = exports.GHMattiMySQL:QueryResult("SELECT id, garage_id, model FROM vehicles WHERE character_id=@character_id AND deleted=0", {
			["@character_id"] = character.id,
		})

		for k, v in ipairs(result) do
			vehicles[v.id] = v
		end

		exports.character:Set(source, "vehicles", vehicles)
		TriggerClientEvent("garages:receiveGarages", source, Garages)
	end
end)

AddEventHandler("entityRemoved", function(entity)
	local vehicle = Vehicles[entity]
	if not vehicle then return end
	
	if GetPlayerEndpoint(vehicle.source) ~= nil then
		TriggerClientEvent("garages:store", vehicle.source, vehicle.netId)
	end

	StoreVehicle(vehicle.source, vehicle.id, entity)
end)

AddEventHandler("garages:start", function()
	Vehicles = exports.cache:Get("Garage_Vehicles") or Vehicles
	VehicleCache = exports.cache:Get("Garage_VehicleCache") or VehicleCache
end)

AddEventHandler("garages:stop", function()
	exports.cache:Set("Garage_Vehicles", Vehicles)
	exports.cache:Set("Garage_VehicleCache", VehicleCache)
end)

RegisterNetEvent("garages:requestGarages")
AddEventHandler("garages:requestGarages", function()
	TriggerClientEvent("garages:receiveGarages", source, Garages)
end)