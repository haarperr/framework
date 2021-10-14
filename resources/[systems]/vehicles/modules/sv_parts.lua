RegisterNetEvent("vehicles:setDamage", function(netId, info)
	local source = source
	
	if type(info) ~= "table" then return end

	-- Get entity from net id.
	local entity = Main:GetEntityFromNetworkId(netId)
	if not entity then return end

	-- Get vehicle.
	local vehicle = Main.vehicles[netId]
	if not vehicle then return end

	-- Check info.
	local count = 0
	for k, v in pairs(info) do
		count = count + 1
		if count > 32 or type(k) ~= "number" or type(v) ~= "number" then
			return
		else
			info[k] = math.ceil(v * 1000.0) / 1000.0
		end
	end

	-- Update vehicle.
	vehicle:Set("damage", info)
end)