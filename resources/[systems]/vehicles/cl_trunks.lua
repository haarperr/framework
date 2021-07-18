--[[ Functions ]]--
-- local retval, trunkCoords, doorIndexes, trunkOffsetCoords = table.unpack(exports.vehicles:GetTrunkInfo(vehicle, offset))
function GetTrunkInfo(vehicle, offset)
	if not DoesEntityExist(vehicle) then
		return { false }
	end

	local coords = nil
	local trunkBone = GetEntityBoneIndexByName(vehicle, "boot")
	local doorL = GetEntityBoneIndexByName(vehicle, "door_dside_r")
	local doorR = GetEntityBoneIndexByName(vehicle, "door_pside_r")
	local doorIndexes = {}
	
	if trunkBone ~= -1 then
		coords = GetWorldPositionOfEntityBone(vehicle, trunkBone)
		doorIndexes[5] = true
	else
		if doorL ~= -1 and doorR ~= -1 then
			coords = (GetWorldPositionOfEntityBone(vehicle, doorL) + GetWorldPositionOfEntityBone(vehicle, doorR)) * 0.5
			doorIndexes[2] = true
			doorIndexes[3] = true
		elseif doorL ~= -1 then
			coords = GetWorldPositionOfEntityBone(vehicle, doorL)
			doorIndexes[2] = true
		elseif doorR ~= -1 then
			coords = GetWorldPositionOfEntityBone(vehicle, doorR)
			doorIndexes[3] = true
		end
	end

	if coords == nil then
		return { false }
	end

	local offsetCoords = nil
	local canReach = true
	if offset then
		local forward = GetEntityForwardVector(vehicle)
		local trunkDir = coords - GetEntityCoords(vehicle)
		local dot = exports.misc:Dot(forward, trunkDir)

		if dot < 0.0 then
			forward = forward * -1
		end

		offsetCoords = coords + forward * offset
	end

	return { true, coords, doorIndexes, offsetCoords }
end
exports("GetTrunkInfo", GetTrunkInfo)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		local vehicle = exports.oldutils:GetNearestVehicle()
-- 		local retval, trunkCoords, doorIndexes, trunkOffsetCoords = table.unpack(GetTrunkInfo(vehicle, 1.0))

-- 		if trunkCoords then
-- 			exports.oldutils:Draw3DText(trunkCoords, "Trunk", 4, 0.4, 1)
-- 			exports.oldutils:Draw3DText(trunkOffsetCoords, "Trunk", 4, 0.4, 1)
-- 		end

-- 		Citizen.Wait(0)
-- 	end
-- end)