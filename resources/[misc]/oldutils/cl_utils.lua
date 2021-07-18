--[[ Players ]]--
Players = {}

function _SetPlayerInvisibleLocally(toggle)
	Players.Invisible = toggle
	Players.Visible = not toggle
end
exports("SetPlayerInvisibleLocally", _SetPlayerInvisibleLocally)

function _SetPlayerVisibleLocally(toggle)
	Players.Visible = toggle
	Players.Invisible = not toggle
end
exports("SetPlayerVisibleLocally", _SetPlayerVisibleLocally)

function RequestAccess(entity)
	local timeout = GetGameTimer() + 8000
	while not NetworkHasControlOfEntity(entity) and GetGameTimer() < timeout do
		NetworkRequestControlOfEntity(entity)
		Citizen.Wait(20)
	end
	return NetworkHasControlOfEntity(entity)
end
exports("RequestAccess", RequestAccess)

function Delete(entity)
	Citizen.CreateThread(function()
		local entityType = GetEntityType(entity)
		if entityType == 0 then return end
		
		if entityType == 2 then
			for i = -1, GetVehicleModelNumberOfSeats(GetEntityModel(entity)) do
				local ped = GetPedInVehicleSeat(entity, i)
				if DoesEntityExist(ped) then
					TaskLeaveVehicle(ped, entity, 16)
				end
			end
			Citizen.Wait(0)
		end
		local isNetworked = NetworkGetEntityIsNetworked(entity)
		if not isNetworked or RequestAccess(entity) then
			if entityType == 2 and IsEntityAMissionEntity(entity) then
				DeleteVehicle(entity)
			elseif entityType == 3 then
				DeleteObject(entity)
			else
				DeleteEntity(entity)
			end
		end
	end)
end
exports("Delete", Delete)

function Raycast(ignore)
	local camCoords = GetFinalRenderedCamCoord()
	local camRot = GetFinalRenderedCamRot(0)
	local camForward = exports.misc:FromRotation(camRot + vector3(0, 0, 90))
	local rayTarget = camCoords + camForward * 1000.0
	local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, rayTarget.x, rayTarget.y, rayTarget.z, -1, ignore or PlayerPedId(), 0)
	return {GetShapeTestResultIncludingMaterial(rayHandle)}
	-- retval, didHit, hitCoords, surfaceNormal, materialHash, entity
end
exports("Raycast", Raycast)

function GetStreetText(coords, noZone)
	if type(coords) ~= "vector3" then return "" end

	local streetText = ""
	local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	local zone = GetNameOfZone(coords.x, coords.y, coords.z)

	if streetName ~= 0 then
		streetText = GetStreetNameFromHashKey(streetName)
		if crossingRoad ~= 0 then
			streetText = streetText.." & "..GetStreetNameFromHashKey(crossingRoad)
		end
	end

	if noZone then
		return streetText
	end

	return streetText..", "..GetLabelText(zone)
end
exports("GetStreetText", GetStreetText)

exports("RequestModel", function(model)
	if not IsModelValid(model) then
		return false
	end
	RequestModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(20)
	end
	return true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local player = PlayerId()
		if Players.Invisible then
			SetPlayerInvisibleLocally(player, Players.Invisible)
		end
		if Players.Visible then
			SetPlayerVisibleLocally(player, Players.Visible)
		end
	end
end)