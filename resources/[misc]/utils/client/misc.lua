-- local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast()
function Raycast(ignore)
	local camCoords = GetFinalRenderedCamCoord()
	local camRot = GetFinalRenderedCamRot(0)
	local camForward = FromRotation(camRot + vector3(0, 0, 90))
	local rayTarget = camCoords + camForward * 1000.0
	local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, rayTarget.x, rayTarget.y, rayTarget.z, -1, ignore or PlayerPedId(), 0)

	return GetShapeTestResultIncludingMaterial(rayHandle)
end

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

function WaitForRequestModel(model)
	if not IsModelValid(model) then
		return false
	end

	RequestModel(model)

	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(20)
	end

	return true
end

function Delete(entity)
	Citizen.CreateThread(function()
		while DoesEntityExist(entity) do
			NetworkRequestControlOfEntity(entity)
			DeleteEntity(entity)

			Citizen.Wait(50)
		end
	end)
end