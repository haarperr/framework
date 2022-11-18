Main.currentTrunk = nil
Main.currentGlovebox = nil

function Main:OpenTrunk(vehicle)
    SetVehicleDoorOpen(vehicle, 5, false, false)
    TriggerServerEvent("vehicles:openTrunk", VehToNet(vehicle))
end

function Main:OpenGlovebox(vehicle)
    TriggerServerEvent("vehicles:openGlovebox", VehToNet(vehicle))
end

function Main:GetTrunkInfo(vehicle, offset)
	if not DoesEntityExist(vehicle) then
		return { false }
	end

	local coords = nil
	local trunkBone = GetEntityBoneIndexByName(vehicle, "boot")
	local doorL = GetEntityBoneIndexByName(vehicle, "door_dside_r")
	local doorR = GetEntityBoneIndexByName(vehicle, "door_pside_r")
	local doorIndexes = {}
	local frunk = {
		"aventsvjr",
		"2017chiron",
		"2019chiron",
		"penetrator",
		"reaper",
		"ninef2",
		"911ts",
	}
	
	for i = 1, #frunk, 1 do
		if GetEntityModel(vehicle) == GetHashKey(frunk[i]) then
			trunkBone = GetEntityBoneIndexByName(vehicle, "bonnet")
			coords = GetWorldPositionOfEntityBone(vehicle, trunkBone)
			doorIndexes[4] = true
		end
	end

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

RegisterNetEvent("vehicles:inTrunk", function(entity, container)
	Main.currentTrunk = { entity = entity, container = container }
end)

RegisterNetEvent("vehicles:inGlovebox", function(entity, container)
	Main.currentGlovebox = { entity = entity, container = container }
end)

Citizen.CreateThread(function()
	while true do
		if Main.currentTrunk then
            local entity = NetworkGetEntityFromNetworkId(Main.currentTrunk.entity)
			local entityInfo = Main:GetTrunkInfo(entity, 1.0)
			local playerCoords = GetEntityCoords(PlayerPedId())

			if #(entityInfo[4] - playerCoords) > 1.0 then
                exports.inventory:Unsubscribe(Main.currentTrunk.container)
                Main.currentTrunk = nil
                SetVehicleDoorShut(entity, 5, false, false)
            end
		elseif Main.currentGlovebox then
			local entity = NetworkGetEntityFromNetworkId(Main.currentGlovebox.entity)
			if GetVehiclePedIsIn(PlayerPedId()) ~= entity then
                exports.inventory:Unsubscribe(Main.currentGlovebox.container)
                Main.currentGlovebox = nil
			end
		end
		::lull::
		Citizen.Wait(500)
	end
end)