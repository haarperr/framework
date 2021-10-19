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

SeatNames = {
	[-1] = "Driver",
	[0] = "Front Passenger",
	[1] = "Back Left",
	[2] = "Back Right",
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

-- Windows = {
-- 	["window_lf"] = 2,
-- 	["window_lm"] = 6,
-- 	["window_lr"] = 4,
-- 	["window_rf"] = 3,
-- 	["window_rm"] = 7,
-- 	["window_rr"] = 5,
-- }

-- WindowNames = {
-- 	[0] = "Front Window",
-- 	[1] = "Back Window",
-- 	[2] = "Front Left",
-- 	[3] = "Front Right",
-- 	[4] = "Back Left",
-- 	[5] = "Back Right",
-- 	[6] = "Middle Left",
-- 	[7] = "Middle Right",
-- }

function FindSeatPedIsIn(ped)
	if not IsPedInAnyVehicle(ped) then return end

	local vehicle = GetVehiclePedIsIn(ped)
	if not vehicle or not DoesEntityExist(vehicle) then return end

	local model = GetEntityModel(vehicle)
	for i = -1, GetVehicleModelNumberOfSeats(model) - 2 do
		if GetPedInVehicleSeat(vehicle, i) == ped then
			return i
		end
	end
end

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

function DoesVehicleHaveBone(vehicle, boneName)
	return GetEntityBoneIndexByName(vehicle, boneName) ~= -1
end

function DoesVehicleHaveEngine(vehicle)
	for _, boneName in ipairs({ "engine", "engine_l", "engine_r" }) do
		if DoesVehicleHaveBone(vehicle, boneName) then
			return true
		end
	end
	return false
end

function GetVehicleEngineDoor(vehicle)
	-- Get and check engine.
	local engineIndex = GetEntityBoneIndexByName(vehicle, "engine")
	if engineIndex == -1 then return end
	
	-- Get hood and trunk.
	local hoodIndex = GetEntityBoneIndexByName(vehicle, "bonnet")
	local trunkIndex = GetEntityBoneIndexByName(vehicle, "boot")

	-- Get engine coords.
	local engineOffset = GetOffsetFromEntityGivenWorldCoords(vehicle, GetEntityBonePosition_2(vehicle, engineIndex))
	local engineSign = engineOffset.y > 0.0 and 1 or -1

	-- Check hood.
	if hoodIndex ~= -1 then
		local hoodOffset = GetOffsetFromEntityGivenWorldCoords(vehicle, GetEntityBonePosition_2(vehicle, hoodIndex))
		local hoodSign = hoodOffset.y > 0.0 and 1 or -1

		if engineSign == hoodSign then
			return "bonnet"
		end
	end

	-- Check trunk.
	if trunkIndex ~= -1 then
		local trunkOffset = GetOffsetFromEntityGivenWorldCoords(vehicle, GetEntityBonePosition_2(vehicle, trunkIndex))
		local trunkSign = trunkOffset.y > 0.0 and 1 or -1

		if engineSign == trunkSign then
			return "boot"
		end
	end
end

function IsVehicleEngineVisible(vehicle)
	local engineDoor  = GetVehicleEngineDoor(vehicle)
	if not engineDoor then return false end
	
	return GetVehicleDoorAngleRatio(vehicle, engineDoor == "boot" and 5 or 4) > 0.5, engineDoor
end