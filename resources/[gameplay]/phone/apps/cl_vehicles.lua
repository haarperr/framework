AppHooks["vehicles"] = function(content)
	local vehicles = exports.character:Get("vehicles")
	local payload = { vehicles = {} }

	for k, v in pairs(vehicles) do
		local model = GetLabelText(v.model)
		
		local garage = exports.garages:GetGarage(v.garage_id)
		if not garage then goto continue end

		local garageName, canTrack

		if garage.name then
			local coords = garage.inCoords
			local streetText = ""
			local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
			local zone = GetNameOfZone(coords.x, coords.y, coords.z)

			if streetName ~= 0 then
				streetText = GetStreetNameFromHashKey(streetName)
				if crossingRoad ~= 0 then
					streetText = streetText.." & "..GetStreetNameFromHashKey(crossingRoad)
				end
			end

			garageName = streetText..", "..GetLabelText(zone)
			canTrack = true
		elseif garage.property_id then
			garageName = "Property "..tostring(garage.property_id)
			canTrack = true
		elseif garage.type then
			garageName = garage.type
			canTrack = false
		end

		payload.vehicles[#payload.vehicles + 1] = {
			canTrack = canTrack,
			garage = garageName,
			garageId = v.garage_id,
			name = ("%s (%s)"):format(model, k),
		}

		::continue::
	end

	table.sort(payload.vehicles, function(a, b)
		return a.name > b.name
	end)
	
	return payload
end

RegisterNUICallback("trackVehicle", function(data)
	local garage = exports.garages:GetGarage(data.id)
	if not garage then return end

	local coords = garage.inCoords
	if not coords then return end

	SetNewWaypoint(coords.x, coords.y)
end)