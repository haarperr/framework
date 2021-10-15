function Main:ToggleEngine(source, netId)
	local vehicle = self.vehicles[netId]
	if not vehicle then return end
	
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity then return end

	local value = not GetIsVehicleEngineRunning(entity)
	local hasKey = vehicle:Get("key")

	local vin = vehicle:Get("vin") or ""
	if vin == "" then return end

	-- No key, check if player has one!
	if value and not hasKey then
		local playerContainer = exports.inventory:GetPlayerContainer(source, true)
		if not playerContainer then return end

		local slot = exports.inventory:ContainerFindFirst(playerContainer, "Vehicle Key", "return slot:GetField(1) == '"..vin.."'")
		if not slot then return end

		if not exports.inventory:TakeItem(source, "Vehicle Key", 1, slot.slot_id) then
			return
		end
		
		TriggerClientEvent("playSound", source, "keys", 0.5)

		vehicle:Set("key", true)
	end

	-- Has key, take it!
	if not value and hasKey then
		exports.inventory:GiveItem(source, {
			item = "Vehicle Key",
			fields = { vin },
		})

		TriggerClientEvent("playSound", source, "keys", 0.5)

		vehicle:Set("key", false)
	end

	TriggerClientEvent("vehicles:toggleEngine", source, netId, value)
end

function Main:GiveKey(source, netId)
	local vehicle = self.vehicles[netId]
	if not vehicle then return false end

	local vin = vehicle:Get("vin") or ""
	if vin == "" then return false end

	return table.unpack(exports.inventory:GiveItem(source, {
		item = "Vehicle Key",
		fields = { vin },
	}))
end

RegisterNetEvent("vehicles:toggleEnigne", function(netId)
	local source = source
	Main:ToggleEngine(source, netId)
end)