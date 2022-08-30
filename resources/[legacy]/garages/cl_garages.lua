Debug = true
DebugBlips = {}
CurrentGarage = nil
Garages = {}
GarageIds = {}
LastSpawned = 0
Markers = {}
Out = {}
RetrieveAt = nil
VehicleInfo = {}
Vehicles = {}
Tires = { 0, 1, 4, 5 }

--[[ Functions ]]--
function Initialize()
	for id, garage in pairs(Garages) do
		if garage.outCoords and not Markers[id] then
			local blip = nil
			local shouldDisplay = true
			if garage.name then
				blip = Config.Blips[garage.type]
			elseif garage.property_id then
				shouldDisplay = exports.properties:HasProperty(garage.property_id)
				if Debug and not DebugBlips[id] and false then
					local property = exports.properties:GetProperty(garage.property_id)
					local blip = AddBlipForCoord(garage.inCoords.x, garage.inCoords.y, garage.inCoords.z)
					SetBlipScale(blip, 0.5)
					SetBlipColour(blip, 83)
					SetBlipHiddenOnLegend(blip, true)
					DebugBlips[id] = blip
				end
			end

			if shouldDisplay then
				local markerId = "Garage"..tostring(id)
				local inMarker = exports.markers:CreateUsable(GetCurrentResourceName(), garage.inCoords, markerId, "Access Garage", Config.DrawRadius, Config.Radius, blip)

				AddEventHandler("markers:use_"..markerId, function()
					local factions = garage.Faction
					if type(factions) == "string" then
						factions = { factions }
					end
					if factions then
						local hasFaction = false
						for group, faction in ipairs(factions) do
							if exports.factions:Has(faction, group) then
								hasFaction = true
								break
							end
						end
						if not hasFaction then
							TriggerEvent("chat:notify", "Missing faction!", "error")
							return
						end
					end
					CurrentGarage = id
					Menu:Open()
				end)

				Markers[id] = inMarker
			end
		end
		GarageIds[garage.id] = id
	end
end

function CountVehiclesInGarage(garageId, vehicleId)
	local vehicles = GetVehicles()
	local count = 0
	for _, vehicle in ipairs(vehicles) do
		if vehicle.garage_id == garageId and vehicle.id ~= vehicleId then
			count = count + 1
		end
	end
	return count
end

function CanFitInGarage(garageId, vehicleId)
	return Garages[garageId].limit == -1 or CountVehiclesInGarage(garageId, vehicleId) < Garages[garageId].limit
end

function GetVehicles()
	return exports.character:GetCharacter().vehicles
end

function GetVehicle(id)
	return VehiclesInfo[id] or GetVehicles()[id]
end

function GetGarage(id)
	return Garages[GarageIds[id]]
end
exports("GetGarage", GetGarage)

function GetVehicleInfo(vehicle)
	-- Components.
	local components = {{}, {}, {}}

	-- Doors.
	for i = 1, GetNumberOfVehicleDoors(vehicle) do
		local door = 0
		if IsVehicleDoorDamaged(vehicle, i - 1) then
			door = 1
		end
		components[1][i] = door
	end

	-- Tires.
	-- for i = 1, GetVehicleNumberOfWheels(vehicle) do
	for k, v in ipairs(Tires) do
		local burst = 0
		if IsVehicleTyreBurst(vehicle, v, true) then
			burst = 2
		elseif IsVehicleTyreBurst(vehicle, v, false) then
			burst = 1
		end
		components[2][k] = burst
	end

	-- Windows.
	for i = 1, 14 do
		local window = 0
		local status, retval = pcall(function() return IsVehicleWindowIntact(vehicle, i - 1) end)
		if status and not retval then
			window = 1
		end
		components[3][i] = window
	end
	
	-- Wheel type
	components[4] = GetVehicleWheelType(vehicle)

	-- Mods.
	SetVehicleModKit(vehicle, 0)

	local mods = {}
	for i = 1, 50 do
		local mod = GetVehicleMod(vehicle, i - 1)
		if IsToggleModOn(vehicle, i - 1) then
			mod = { mod, 1 }
		end
		mods[i] = mod
	end

	-- Extras.
	local extras = {}
	for i = 1, 14 do
		local extra = 0
		if DoesExtraExist(vehicle, i - 1) and IsVehicleExtraTurnedOn(vehicle, i - 1) then
			extra = 1
		end
		extras[i] = extra
	end

	-- Neons.
	components[5] = {}
	for i = 0, 3 do
		local value = 0
		if IsVehicleNeonLightEnabled(vehicle, i) then
			components[5][tostring(i)] = 1
		else
			components[5][tostring(i)] = 0
		end
	end

	print(GetVehicleCustomPrimaryColour(vehicle))

	-- Colors.
	local paintType, color = GetVehicleModColor_1(vehicle)
	local pearlescent, wheelColor = GetVehicleExtraColours(vehicle)
	local colors = {}
	colors[1] = table.pack(GetVehicleCustomPrimaryColour(vehicle))
	colors[2] = table.pack(GetVehicleCustomSecondaryColour(vehicle))
	colors[3] = paintType or -1
	colors[4] = color or -1
	colors[5] = pearlescent or -1
	colors[6] = wheelColor or -1
	colors[7] = GetVehicleWindowTint(vehicle) or -1
	colors[8] = table.pack(GetVehicleTyreSmokeColor(vehicle)) or {255,255,255}
	colors[9] = GetVehicleXenonLightsColour(vehicle) or -1
	colors[10] = GetVehicleInteriorColour(vehicle) or -1
	colors[11] = GetVehicleDashboardColour(vehicle) or -1
	colors[12] = table.pack(GetVehicleNeonLightsColour(vehicle))
	colors[13] = GetVehicleLivery(vehicle)
	colors[14] = GetVehicleRoofLivery(vehicle)

	-- Return info.
	local otherHealth = {}
	for k, v in ipairs(otherHealth) do
		otherHealth[k] = math.floor(v * 1000.0)
	end

	return {
		colors = colors,
		fuel = GetVehicleFuelLevel(vehicle) or 100,
		body_health = math.min(math.max(math.floor(GetVehicleBodyHealth(vehicle)) or 1000, 0), 1000),
		engine_health = math.min(math.max(math.floor(GetVehicleEngineHealth(vehicle)) or 1000, 0), 1000),
		fuel_health = math.min(math.max(math.floor(GetVehiclePetrolTankHealth(vehicle)) or 1000, 0), 1000),
		other_health = otherHealth,
		components = components,
		mods = mods,
		extras = extras,
	}
end
exports("GetVehicleInfo", GetVehicleInfo)

function SetVehicleInfo(vehicle, info)
	if info.colors and not info.colors[8] then info.colors[8] = {255,255,255} end
	SetVehicleModKit(vehicle, 0)

	local components = info.components
	if not components then components = {} end
	
	-- Extras.
	if info.extras then
		for i = 1, 14 do
			if DoesExtraExist(vehicle, i - 1) then
				SetVehicleExtra(vehicle, i - 1, info.extras[i] ~= 1)
			end
		end
	end
	
	-- Wheel type
	if components[4] then
		SetVehicleWheelType(vehicle, components[4])
	end

	-- Mods.
	if info.mods then
		for i = 1, 50 do
			local mod = info.mods[i]
			if type(mod) == "table" then
				if mod[2] == 1 then
					ToggleVehicleMod(vehicle, i - 1, true)
				end
				mod = mod[1]
			end
			SetVehicleMod(vehicle, i - 1, mod)
		end
	end

	-- Colors.
	if info.colors then
		SetVehicleCustomPrimaryColour(vehicle, table.unpack(info.colors[1]))
		SetVehicleCustomSecondaryColour(vehicle, table.unpack(info.colors[2]))
		if GetNumModColors(vehicle, true) > 0 then
			SetVehicleModColor_1(vehicle, info.colors[3] or 0, info.colors[4] or 0, 0)
		end
		SetVehicleExtraColours(vehicle, info.colors[5] or 0, info.colors[6] or 0)
		SetVehicleWindowTint(vehicle, info.colors[7] or 0)
		SetVehicleTyreSmokeColor(vehicle, info.colors[8][1], info.colors[8][2], info.colors[8][3])
		SetVehicleXenonLightsColour(vehicle, info.colors[9] or -1)
		SetVehicleInteriorColour(vehicle, info.colors[10] or -1)
		SetVehicleDashboardColour(vehicle, info.colors[11] or -1)
		SetVehicleNeonLightsColour(vehicle, table.unpack(info.colors[12] or {255, 255, 255}))
		SetVehicleLivery(vehicle, info.colors[13] or -1)
		SetVehicleRoofLivery(vehicle, info.colors[14] or -1)
	end

	-- Fuel.
	SetVehicleFuelLevel(vehicle, (info.fuel + 0.0) or 100.0)

	-- Healths.
	SetVehicleBodyHealth(vehicle, (info.body_health or 1000.0) * 1.0)
	SetVehicleEngineHealth(vehicle, (info.engine_health or 1000.0) * 1.0)
	SetVehiclePetrolTankHealth(vehicle, (info.fuel_health or 1000.0) * 1.0)
	SetVehicleAutoRepairDisabled(vehicle, true)

	if info.other_health then
		for k, v in ipairs(info.other_health) do
			info.other_health[k] = v / 1000.0
		end
		--exports.vehicles:InitializeVehicle(vehicle, info.other_health)
	end

	-- Doors.
	if components[1] then
		for i = 1, GetNumberOfVehicleDoors(vehicle) do
			if components[1][i] == 1 then
				SetVehicleDoorBroken(vehicle, i - 1, false)
			end
		end
	end

	-- Tires.
	if components[2] then
		-- for i = 1, GetVehicleNumberOfWheels(vehicle) do
		for k, v in ipairs(Tires) do
			local burst = components[2][k]
			if burst ~= 0 then
				SetVehicleTyreBurst(vehicle, v, burst == 2, 1000)
			end
		end
	end

	-- Windows.
	if components[3] then
		for i = 1, 14 do
			local window = components[3][i]
			if window ~= 0 then
				pcall(function()
					SmashVehicleWindow(vehicle, i - 1)
				end)
			end
		end
	end

	-- Neons.
	if components[5] then
		for i = 0, 3 do
			if components[5][tostring(i)] == 1 then
				SetVehicleNeonLightEnabled(vehicle, i, true)
			end
		end
	end
end
exports("SetVehicleInfo", SetVehicleInfo)

function GetNearest()
	local ped = PlayerPedId()
	local pedPos = GetEntityCoords(ped)
	local nearest = nil
	local nearestDist = 0
	local garage = Garages[CurrentGarage]

	for netId, vehicleCache in pairs(Vehicles) do
		local vehicle = NetToVeh(netId)
		local class = GetVehicleClass(vehicle)
		if garage.type == Config.Classes[class] then
			local dist = #(GetEntityCoords(vehicle) - pedPos)
			if (not nearest or dist < nearestDist) and dist < (Config.Ranges[class] or Config.Radius) then
				nearestDist = dist
				nearest = netId
			end
		end
	end
	return nearest
end

function StoreNearest()
	Store(GetNearest())
end

function Retrieve(id, pos)
	RetrieveAt = pos
	TriggerServerEvent("garages:retrieveVehicle", id)
end
exports("Retrieve", Retrieve)

function Store(netId, failedToRetrieve)
	if not netId then return end
	local vehicleCache = Vehicles[netId]
	local vehicle = NetToVeh(netId)
	if not DoesEntityExist(vehicle) then return end

	while not NetworkHasControlOfEntity(vehicle) do
		NetworkRequestControlOfEntity(vehicle)
		Citizen.Wait(200)
	end

	local garageId = CurrentGarage
	if type(garageId) == "string" then
		garageId = Config.Garages[garageId].Id or garageId
	end

	if not failedToRetrieve then
		-- Update to server.
		local info = GetVehicleInfo(vehicle)
		info.garage_id = garageId

		TriggerServerEvent("garages:storeVehicle", vehicleCache.id, netId, info)

		-- Update client garage.
		local vehicles = exports.character:Get("vehicles") or {}
		vehicles[vehicleCache.id].garage_id = garageId
		exports.character:Set("vehicles", vehicles)
	end

	Vehicles[netId] = nil
	Out[vehicleCache.id] = nil
end

function IsVehicleOut(id)
	return Out[id] ~= nil
end

--[[ Vehicle Events ]]--
RegisterNetEvent("garages:retrieveVehicle")
AddEventHandler("garages:retrieveVehicle", function(vehicleInfo)
	if not CurrentGarage and not RetrieveAt then return end
	if not vehicleInfo then return end

	local ped = PlayerPedId()
	local garage = Garages[CurrentGarage]
	local pos = RetrieveAt or garage.outCoords

	local vehicle = exports.oldutils:CreateVehicle(GetHashKey(vehicleInfo.model), pos.x, pos.y, pos.z, pos.w, true, true)
	local class = GetVehicleClass(vehicle)

	SetVehicleInfo(vehicle, vehicleInfo)
	SetVehicleNumberPlateText(vehicle, vehicleInfo.plate or exports.misc:GetRandomText(vehicleInfo.id, 8))

	local netId = NetworkGetNetworkIdFromEntity(vehicle)
	LastSpawned = netId
	Vehicles[netId] = { id = vehicleInfo.id }

	Out[vehicleInfo.id] = true

	TriggerServerEvent("garages:retrievedVehicle", netId, vehicleInfo.id, class)
end)

RegisterNetEvent("vehicles:receiveKeys")
AddEventHandler("vehicles:receiveKeys", function(vehicle, failed)
	local vehicleInfo = Vehicles[LastSpawned]
	if not vehicleInfo then return end

	local vehicle = NetToVeh(LastSpawned)
	if not DoesEntityExist(vehicle) then return end

	local ped = PlayerPedId()

	if failed then
		Citizen.Trace("There was an issue registering your vehicle as an entity!\n")
		Store(LastSpawned, true)
	else
		SetPedIntoVehicle(ped, vehicle, -1)
	end
	LastSpawned = nil
end)

RegisterNetEvent("garages:storeVehicle")
AddEventHandler("garages:storeVehicle", function(netId)
	local vehicle = NetToVeh(netId)
	if DoesEntityExist(vehicle) and exports.oldutils:RequestAccess(vehicle) then
		DeleteEntity(vehicle)
	end
end)

--[[ Resource Events ]]--
AddEventHandler("character:selected", function(character)
	TriggerServerEvent("garages:requestGarages")

	if GetResourceState("cache") == "started" then
		Vehicles = exports.cache:Get("GarageVehicles") or Vehicles
	end
end)

AddEventHandler("garages:stop", function()
	if GetResourceState("cache") == "started" then
		exports.cache:Set("GarageVehicles", Vehicles)
	end
end)

RegisterNetEvent("garages:receiveGarages")
AddEventHandler("garages:receiveGarages", function(garages)
	Garages = garages
	for name, garage in pairs(Config.Garages) do
		if garage.Id then
			Garages[name] = {
				id = garage.Id,
				type = garage.Type,
				faction = garage.Faction,
				inCoords = garage.InCoords,
				outCoords = garage.OutCoords,
				limit = garage.Limit,
			}
		end
	end
	Initialize()
end)

RegisterNetEvent("garages:receiveVehicles")
AddEventHandler("garages:receiveVehicles", function(vehicles)
	Vehicles = vehicles
	Initialize()
end)

RegisterNetEvent("properties:bought")
AddEventHandler("properties:bought", function(id)
	Initialize()
end)


RegisterNetEvent("character:selected")
AddEventHandler("character:selected", function(character)
	if character then
		Initialize()
	end
end)

RegisterNetEvent("garages:store")
AddEventHandler("garages:store", function(netId)
	local vehicle = Vehicles[netId]
	if not vehicle then return end

	Out[vehicle.id] = nil
	Vehicles[netId] = nil
end)

if Debug then
	RegisterCommand("garageget", function()
		local nearestGarage = nil
		local coords = GetEntityCoords(PlayerPedId())
		for id, garage in pairs(Garages) do
			if garage.inCoords and #(coords - vector3(garage.inCoords.x, garage.inCoords.y, garage.inCoords.z)) < 2.0 then
				nearestGarage = id
				break
			end
		end
		if nearestGarage then
			TriggerEvent("chat:addMessage", ("You're near garage: %s!"):format(nearestGarage))
		else
			TriggerEvent("chat:addMessage", "You're not near any garage!")
		end
	end)

	local debugDisplay = false
	RegisterCommand("garagedisplay", function()
		debugDisplay = not debugDisplay
	end)

	Citizen.CreateThread(function()
		while true do
			if debugDisplay then
				for id, garage in pairs(Garages) do
					if garage.outCoords and garage.property_id then
						local property = exports.properties:GetProperty(garage.property_id)
						if property and #(GetEntityCoords(PlayerPedId()) - vector3(garage.outCoords.x, garage.outCoords.y, garage.outCoords.z)) < 50.0 then
							DrawLine(garage.outCoords.x, garage.outCoords.y, garage.outCoords.z, property.x, property.y, property.z, 255, 0, 255, 255)
							DrawMarker(
								26,
								garage.outCoords.x,
								garage.outCoords.y,
								garage.outCoords.z,
								0,
								0,
								0,
								0,
								0,
								garage.outCoords.w,
								1.0,
								1.0,
								1.0,
								255,
								0,
								255,
								255,
								false,
								false,
								0,
								false
							)
						end
					end
				end
			end
			Citizen.Wait(10)
		end
	end)
end