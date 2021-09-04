Vehicle = {}
Vehicle.__index = Vehicle

--[[ Functions: Vehicle ]]--
function Vehicle:Create(netId, info)
	local vehicle = setmetatable({
		netId = netId,
		info = info or {
			key = true,
			hotwired = false,
			vin = Main:GetUniqueVin(),
		},
	}, Vehicle)

	print(vehicle.info.vin)

	Main.vehicles[netId] = vehicle

	return vehicle
end

function Vehicle:Destroy()
	Main.vehicles[self.netId] = nil
end

function Vehicle:Set(key, value)
	print("set", self.netId, key, value)
	self.info[key] = value
end

function Vehicle:Get(key)
	return self.info[key]
end