local Vehicles = {}
local VehicleCache = {}
local Keys = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)

		local counts = {}

		for vehicle, info in pairs(VehicleCache) do
			if not DoesEntityExist(vehicle) then goto continue end

			local lifetime = os.clock() - info.time
			local owner = NetworkGetEntityOwner(vehicle)
			local ped = GetPlayerPed(owner)
			local count = counts[owner] or 0

			if HasVehicleBeenOwnedByPlayer(vehicle) then
				count = count + 1
			end
			
			if DoesEntityExist(ped) and GetVehiclePedIsIn(ped, false) == vehicle or GetVehiclePedIsIn(ped, true) == vehicle then
				info.time = os.clock()
			elseif lifetime > 600 and count >= 4 then
				DeleteEntity(vehicle)
			end
			counts[info.owner] = count

			::continue::
		end
	end
end)

--[[ Functions ]]--
function InitializeVehicle(vehicle, data)
	Vehicles[vehicle] = data or {}
end

function HasKey(source, entity)
	if not DoesEntityExist(entity) then return false end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return false end

	local netId = NetworkGetNetworkIdFromEntity(entity)
	if not netId then return false end

	return Keys[characterId][tostring(netId)] == true
end
exports("HasKey", HasKey)

function GiveKey(source, entity)
	if not DoesEntityExist(entity) then return false end

	local netId = NetworkGetNetworkIdFromEntity(entity)
	if not netId then return false end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return false end
	
	-- Give keys to player.
	local keys = Keys[characterId]
	if not keys then
		keys = {}
		Keys[characterId] = keys
	end
	keys[tostring(netId)] = true

	-- Give keys to vehicle.
	local vehicle = Vehicles[entity]
	if vehicle then
		vehicle.keys[characterId] = true
	else
		InitializeVehicle(entity, {
			keys = {
				[characterId] = true,
			}
		})
	end

	TriggerClientEvent("vehicles:receiveKeys", source, netId)

	return true
end
exports("GiveKey", GiveKey)

--[[ Events ]]--
RegisterNetEvent("vehicles:requestKey")
AddEventHandler("vehicles:requestKey", function(netId, reason)
	local source = source
	
	if type(netId) ~= "number" then return end
	if type(reason) ~= "string" or reason:len() > 32 then return end

	local log = ""
	if reason == "hotwire" then
		log = "[%s] hotwired vehicle (%s, %s)"
	elseif reason == "on" then
		log = "[%s] took the key to vehicle (%s, %s)"
	else
		log = "[%s] requested the key to vehicle (%s, %s): %s"
	end

	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if vehicle == 0 then
		local attempts = 10
		for i = 1, attempts do
			Citizen.Wait(500)
			vehicle = NetworkGetEntityFromNetworkId(netId)
			if vehicle ~= 0 then
				break
			end
		end
		if vehicle == 0 then
			TriggerClientEvent("vehicles:receiveKeys", source, netId, true)
			Citizen.Trace(("[VEHICLES] [%s] Failed requesting keys after %s attempts for non-existent vehicle: %s\n"):format(source, attempts, vehicle))
			return
		end
	end

	GiveKey(source, vehicle)

	local model = GetEntityModel(vehicle)
	if model then
		model = exports.vehicles:GetVehicle(model) or model
	end

	exports.log:Add({
		source = source,
		verb = "requested",
		noun = "keys",
		extra = ("model: %s - net id: %s - reason: %s"):format(model, netId, reason),
	})
end)

RegisterNetEvent("vehicles:requestVehicle")
AddEventHandler("vehicles:requestVehicle", function(netId)
	local source = source

	TriggerClientEvent("vehicles:receiveVehicle", source, netId)
end)

RegisterNetEvent("vehicles:giveKey")
AddEventHandler("vehicles:giveKey", function(target, netId)
	local source = source

	if not netId then return end
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(vehicle) then return end
	if not HasKey(source, vehicle) then return end

	target = tonumber(target)
	if not target or target <= 0 then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "gave",
		noun = "keys",
		extra = ("net id: %s"):format(netId),
	})
	
	GiveKey(target, vehicle)

	TriggerClientEvent("notify:sendAlert", source, "inform", "You gave keys!", 7000)
end)

AddEventHandler("character:loaded", function(source, character)
	local keys = Keys[character.id]
	TriggerClientEvent("vehicles:receiveKeys", source, keys)
end)

AddEventHandler("vehicles:start", function()
	if GetResourceState("cache") ~= "started" then return end

	Vehicles = exports.cache:Get("Vehicles") or Vehicles
	VehicleCache = exports.cache:Get("VehicleCache") or VehicleCache
end)

AddEventHandler("vehicles:stop", function()
	if GetResourceState("cache") ~= "started" then return end

	exports.cache:Set("Vehicles", Vehicles)
	exports.cache:Set("VehicleCache", VehicleCache)
end)

AddEventHandler("entityCreating", function(entity)
	if GetEntityType(entity) ~= 2 then return end
	
	VehicleCache[entity] = { time = os.clock(), owner = NetworkGetEntityOwner(entity), netId = NetworkGetNetworkIdFromEntity(entity) }
end)

AddEventHandler("entityRemoved", function(entity)
	if entity == nil then return end

	local cache = VehicleCache[entity]
	if cache == nil then return end

	local netId = cache.netId
	if netId then
		local vehicle = Vehicles[entity]
		if vehicle then
			for characterId, _ in pairs(vehicle.keys) do
				local keys = Keys[characterId]
				if keys then
					keys[tostring(netId)] = nil
				end
			end
		end
	end

	VehicleCache[entity] = nil
	Vehicles[entity] = nil
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:fix", function(source, args, rawCommand)
	exports.log:Add({
		source = source,
		verb = "fixed",
		noun = "their vehicle",
		channel = "admin",
	})
	TriggerClientEvent("vehicles:fix", source)
end, {}, -1, 25)

exports.chat:RegisterCommand("a:unfix", function(source, args, rawCommand)
	exports.log:Add({
		source = source,
		verb = "unfixed",
		noun = "their vehicle",
		channel = "admin",
	})
	TriggerClientEvent("vehicles:unfix", source)
end, {}, -1, 25)

exports.chat:RegisterCommand("a:clean", function(source, args, rawCommand)
	exports.log:Add({
		source = source,
		verb = "cleaned",
		noun = "their vehicle",
		channel = "admin",
	})
	TriggerClientEvent("vehicles:clean", source)
end, {}, -1, 25)