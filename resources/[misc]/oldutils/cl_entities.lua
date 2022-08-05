--[[ Enumeration ]]--
-- https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2
local EntityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
		enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
		
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, EntityEnumerator)
		
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
		
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

local function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

local function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

local Transforms = {}
local NearestPed = 0
local Objects = {}
local Peds = {}
local Players = {}
local Vehicles = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local playerPed = PlayerPedId()
		local playerPos = GetEntityCoords(playerPed)

		-- Clean transforms.
		for object, transform in pairs(Transforms) do
			if not DoesEntityExist(object) then
				Transforms[object] = nil
			end
		end
		
		-- Objects.
		Objects = {}
		
		for object, _ in EnumerateObjects() do
			if not NetworkIsEntityConcealed(object) then
				Objects[#Objects + 1] = object
				if not Transforms[object] then
					Transforms[object] = { GetEntityCoords(object), GetEntityRotation(object) }
				end
			end
		end
		
		-- Peds.
		Peds = {}
		Players = {}
		NearestPed = 0
		NearestPedDistance = 0.0

		for ped, _ in EnumeratePeds() do
			if not NetworkIsEntityConcealed(ped) then
				Peds[#Peds + 1] = ped
				if ped ~= playerPed then
					local dist = #(playerPos - GetEntityCoords(ped))
					if NearestPed == 0 or dist < NearestPedDistance then
						NearestPedDistance = dist
						NearestPed = ped
					end
					if IsPedAPlayer(ped) then
						local player = NetworkGetPlayerIndexFromPed(ped)
						if not NetworkIsPlayerConcealed(player) then
							Players[#Players + 1] = GetPlayerServerId(player)
						end
					end
				end
				SetPedDropsWeaponsWhenDead(ped, false)
			end
		end
		
		-- Vehicles.
		Vehicles = {}

		local distances = {}

		for vehicle, _ in EnumerateVehicles() do
			if not NetworkIsEntityConcealed(vehicle) then
				Vehicles[#Vehicles + 1] = vehicle
				distances[vehicle] = #(playerPos - GetEntityCoords(vehicle))
			end
		end

		table.sort(Vehicles, function(a, b)
			return distances[a] < distances[b]
		end)

		-- Pickups.
		-- for pickup, _ in EnumeratePickups() do
		-- 	RemovePickup(pickup)
		-- end
	end
end)

--[[ Exports ]]--
exports("GetObjects", function()
	return Objects
end)

exports("GetPeds", function()
	return Peds
end)

exports("GetVehicles", function()
	return Vehicles
end)

exports("GetNearestVehicle", function(index)
	return Vehicles[index or 1]
end)

function GetNearestPed()
	return NearestPed
end
exports("GetNearestPed", GetNearestPed)

function GetNearbyPlayers()
	return Players
end
exports("GetNearbyPlayers", GetNearbyPlayers)

function GetInitialTransform(object)
	return Transforms[object] or { GetEntityCoords(object), GetEntityRotation(object) }
end
exports("GetInitialTransform", GetInitialTransform)

function GetNearestPlayer(maxDistance)
	local players = GetNearbyPlayers()
	local coords = GetEntityCoords(PlayerPedId())
	local nearestPlayer = nil
	local nearestDist = 0.0

	for k, player in pairs(players) do
		local playerId = GetPlayerFromServerId(player)
		local playerCoords = NetworkGetPlayerCoords(playerId)
		local dist = #(coords - playerCoords)
		
		if (not maxDistance or dist < maxDistance) and (not nearestPlayer or nearestDist > dist) then
			nearestPlayer = player
			nearestDist = dist
		end
	end

	return nearestPlayer or 0
end
exports("GetNearestPlayer", GetNearestPlayer)

function GetFacingVehicle(maxDist, minDot)
	local ped = PlayerPedId()
	local vehicles = exports.oldutils:GetVehicles()
	local coords = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local nearestVeh, nearestDist = nil, 0.0
	
	for _, vehicle in ipairs(vehicles) do
		local vehCoords = GetEntityCoords(vehicle)
		local vehDir = vehCoords - coords
		local dist = #vehDir
		local isNear = dist < (maxDist or 6.0)
		local dot = isNear and exports.misc:Dot(vehDir / dist, forward)
	
		if (isNear and dot > (minDot or 0.5)) and (nearestVeh == nil or dist < nearestDist) then
			nearestDist = dist
			nearestVeh = vehicle
		end
	end

	return nearestVeh or 0
end
exports("GetFacingVehicle", GetFacingVehicle)