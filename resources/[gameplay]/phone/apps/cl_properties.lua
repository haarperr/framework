AppHooks["properties"] = function(content)
	local properties = exports.character:Get("properties")
	local keys = exports.character:Get("keys")
	local payments = exports.character:Get("payments")
	local paymentsCache = {}

	for k, v in ipairs(payments) do
		if v.property_id and v.expired ~= 1 then
			paymentsCache[v.property_id] = v
		end
	end

	for k, v in ipairs(keys) do
		local property = exports.properties:GetProperty(v.property_id)
		if property then
			property.isKey = true
			properties[#properties + 1] = property
		end
	end

	for k, v in ipairs(properties) do
		local coords = vector3(v.x, v.y, v.z)
		local streetText = ""
		local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
		local zone = GetNameOfZone(coords.x, coords.y, coords.z)

		if streetName ~= 0 then
			streetText = GetStreetNameFromHashKey(streetName)
			if crossingRoad ~= 0 then
				streetText = streetText.." & "..GetStreetNameFromHashKey(crossingRoad)
			end
		end

		v.address = streetText..", "..GetLabelText(zone)
		v.payment = paymentsCache[v.id]

		local settings = exports.properties:GetSettings(v.type)
		if settings then
			v.name = settings.Name
		end
	end
	
	local payload = {
		properties = properties,
		payments = payments,
	}
	
	return payload
end

RegisterNUICallback("trackProperty", function(data)
	local property = exports.properties:GetProperty(data.id)
	if not property then return end

	SetNewWaypoint(property.x, property.y)
end)

RegisterNUICallback("payProperty", function(data)
	local property = exports.properties:GetProperty(data.id)
	if not property then return end

	TriggerServerEvent("properties:pay", data.id)
end)