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

function GetClosestDoor(coords, vehicle)
	local nearestDoor = nil
	local nearestDist = 0.0

	for index = 0, GetNumberOfVehicleDoors(vehicle) - 1 do
		local doorCoords = GetEntryPositionOfDoor(vehicle, index)
		local dist = doorCoords and #doorCoords > 0.001 and #(doorCoords - coords)

		if dist and (not nearestDoor or dist < nearestDist) then
			nearestDoor = index
			nearestDist = dist
		end
	end

	return nearestDoor, nearestDist
end

function GetClosestSeat(coords, vehicle, mustBeEmpty)
	local nearestDoor = nil
	local nearestDist = 0.0
	local model = GetEntityModel(vehicle)

	for boneName, seatIndex in pairs(Config.Seats) do
		local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
		if boneIndex ~= -1 then
			local ped = mustBeEmpty and GetPedInVehicleSeat(vehicle, seatIndex)
			if not mustBeEmpty or not ped or not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then
				local doorCoords = GetEntityBonePosition_2(vehicle, boneIndex)
				local dist = doorCoords and #doorCoords > 0.001 and #(doorCoords - coords)
				
				if dist and (not nearestDoor or dist < nearestDist) then
					nearestDoor = seatIndex
					nearestDist = dist
				end
			end
		end
	end

	return nearestDoor, nearestDist
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