Seats = {
	["seat_f"] = -1,
	["seat_r"] = 0,
	["seat_dside_f"] = -1,
	["seat_pside_f"] = 0,
	["seat_dside_r"] = 1,
	["seat_pside_r"] = 2,
	["seat_dside_r1"] = 3,
	["seat_pside_r1"] = 4,
	["seat_dside_r2"] = 5,
	["seat_pside_r2"] = 6,
	["seat_dside_r3"] = 7,
	["seat_pside_r3"] = 8,
	["seat_dside_r4"] = 9,
	["seat_pside_r4"] = 10,
	["seat_dside_r5"] = 11,
	["seat_pside_r5"] = 12,
	["seat_dside_r6"] = 13,
	["seat_pside_r6"] = 14,
	["seat_dside_r7"] = 15,
	["seat_pside_r7"] = 16,
}

Doors = {
	["bonnet"] = 4,
	["boot"] = 5,
	["door_dside_f"] = 0,
	["door_dside_r"] = 2,
	["door_hatch_l"] = 0,
	["door_hatch_r"] = 1,
	["door_pside_f"] = 1,
	["door_pside_r"] = 3,
}

function GetNearestVehicle(coords, maxDist)
	local nearestVehicle = nil
	local nearestDist = 0.0

	for vehicle, _ in EnumerateVehicles() do
		local dist = #(coords - GetEntityCoords(vehicle))
		if (not maxDist or dist < maxDist) and (not nearestVehicle or dist < nearestDist) then
			nearestVehicle = vehicle
			nearestDist = dist
		end
	end

	return nearestVehicle, nearestDist
end

function GetClosestDoor(coords, vehicle, enterable)
	local nearestDoor = nil
	local nearestDist = 0.0

	for boneName, doorIndex in pairs(Doors) do
		local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
		if boneIndex ~= -1 then
			if not enterable or doorIndex < 4 then
				local target = GetEntityBonePosition_2(vehicle, boneIndex)
				local dist = target and #target > 0.001 and #(target - coords)
				
				if dist and (not nearestDoor or dist < nearestDist) then
					nearestDoor = doorIndex
					nearestDist = dist
				end
			end
		end
	end

	return nearestDoor, nearestDist
end

function GetClosestSeat(coords, vehicle, mustBeEmpty)
	local nearestSeat = nil
	local nearestDist = 0.0

	for boneName, seatIndex in pairs(Seats) do
		local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
		if boneIndex ~= -1 then
			local ped = mustBeEmpty and GetPedInVehicleSeat(vehicle, seatIndex)
			if not mustBeEmpty or not ped or not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then
				local target = GetEntityBonePosition_2(vehicle, boneIndex)
				local dist = target and #target > 0.001 and #(target - coords)
				
				if dist and (not nearestSeat or dist < nearestDist) then
					nearestSeat = seatIndex
					nearestDist = dist
				end
			end
		end
	end

	return nearestSeat, nearestDist
end

function DoesVehicleHaveEngine(vehicle)
	for _, boneName in ipairs({ "engine", "engine_l", "engine_r" }) do
		local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
		if boneIndex ~= -1 then
			return true
		end
	end
	return false
end