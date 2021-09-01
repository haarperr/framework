--[[ Functions: Vehicle ]]--
function Vehicle:Create(entity, info)
	local vehicle = setmetatable({
		entity = entity,
		netId = NetworkGetNetworkIdFromEntity(entity),
		info = info or {
			key = true,
			hotwired = false,
		},
	}, Vehicle)

	Main.vehicles[entity] = vehicle

	return vehicle
end

function Vehicle:Destroy()
	Main.vehicles[self.entity] = nil
end