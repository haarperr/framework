Vehicle = {}
Vehicle.__index = Vehicle

--[[ Functions: Vehicle ]]--
function Vehicle:Create(netId, info)
	-- Get entity from net id.
	local entity = Main:GetEntityFromNetworkId(netId)
	if not entity then return end

	-- Defualt info.
	if not info then
		info = {}
	end

	-- Load vin.
	if info.vin == nil then
		info.vin = Main:GetUniqueVin()
	end

	-- Load key.
	if info.key == nil then
		info.key = GetIsVehicleEngineRunning(entity) == 1
	end

	-- Create vehicle.
	local vehicle = setmetatable({
		info = info,
		netId = netId,
	}, Vehicle)

	-- Cache vehicle.
	Main.vehicles[netId] = vehicle

	-- Return vehicle.
	return vehicle
end

function Vehicle:Destroy()
	Main.vehicles[self.netId] = nil
end

function Vehicle:GetEntity()
	return Main:GetEntityFromNetworkId(self.netId)
end

function Vehicle:Set(key, value)
	print("set", self.netId, key, value)
	self.info[key] = value
end

function Vehicle:Get(key)
	return self.info[key]
end