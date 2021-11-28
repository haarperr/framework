function Main:ToggleEngine(source, netId)
	local vehicle = self.vehicles[netId]
	if not vehicle then return end
	
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity then return end

	local value = not GetIsVehicleEngineRunning(entity)
	local hasKey = vehicle:Get("key")
	local starter = vehicle:Get("starter")

	local vin = vehicle:Get("vin") or ""
	if vin == "" then return end

	local success = false

	-- Get state.
	local state = (Entity(entity) or {}).state

	-- No key, check if player has one!
	if value and not hasKey then
		local playerContainer = exports.inventory:GetPlayerContainer(source, true)
		if not playerContainer then return end

		local slot = exports.inventory:ContainerFindFirst(playerContainer, "Vehicle Key", "return slot:GetField(1) == '"..vin.."'")
		if slot and exports.inventory:TakeItem(source, "Vehicle Key", 1, slot.slot_id) then
			success = true

			TriggerClientEvent("playSound", source, "keys", 0.5)
	
			vehicle:Set("key", true)
		end
	end

	-- Has key, take it!
	if not value and hasKey then
		exports.inventory:GiveItem(source, {
			item = "Vehicle Key",
			fields = { vin },
		})

		TriggerClientEvent("playSound", source, "keys", 0.5)

		vehicle:Set("key", false)

		success = true
	end

	-- Try hotwiring.
	if not success and state and state.hotwired then
		if value and not starter then
			local playerContainer = exports.inventory:GetPlayerContainer(source, true)
			if not playerContainer then return end

			local slot = exports.inventory:ContainerFindFirst(playerContainer, "Screwdriver")
			if slot and exports.inventory:TakeItem(source, "Screwdriver", 1, slot.slot_id) then
				vehicle:Set("starter", slot.durability or 1.0)

				success = true
			end
		end

		if not value and starter then
			exports.inventory:GiveItem(source, {
				item = "Screwdriver",
				durability = starter < 0.99 and starter or nil,
			})

			success = true

			vehicle:Set("starter", nil)
		end
	end

	if success then
		TriggerClientEvent("vehicles:toggleEngine", source, netId, value)
	end
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

	if PlayerUtil:CheckCooldown(source, 1.0) then
		PlayerUtil:UpdateCooldown(source)
		Main:ToggleEngine(source, netId)
	end
end)