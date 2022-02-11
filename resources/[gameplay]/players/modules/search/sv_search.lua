Search = {
	players = {},
}

function Search:Update()
	for source, target in pairs(self.players) do
		if not self:CheckPair(source, target) then
			self.players[source] = nil

			local containerId = exports.inventory:GetPlayerContainer(target, true)
			if containerId then
				exports.inventory:Subscribe(source, containerId, false)
			end
		end
	end
end

function Search:CheckPair(source, target)
	-- Get/check peds.
	local sourcePed = GetPlayerPed(source)
	local targetPed = GetPlayerPed(target)

	if not DoesEntityExist(sourcePed) or not DoesEntityExist(targetPed) then
		return false
	end

	-- Check coords.
	local sourceCoords = GetEntityCoords(sourcePed)
	local targetCoords = GetEntityCoords(targetPed)

	if #(targetCoords - sourceCoords) > Config.MaxDist then
		return false
	end

	-- Success.
	return true
end

--[[ Events: Net ]]--
RegisterNetEvent("players:search", function(target, isFrisk)
	local source = source
	
	isFrisk = isFrisk == true

	if (
		type(target) ~= "number" or
		not Main.players[target] or
		not PlayerUtil:CheckCooldown(source, 5000, true, "search")
	) then
		return
	end

	-- Get container id.
	local containerId = exports.inventory:GetPlayerContainer(target, true)
	if not containerId then
		print(("searching player without container %s->%s"):format(source, target))
		return
	end

	-- Subscribe player.
	if exports.inventory:Subscribe(source, containerId, true, isFrisk) then
		-- Open inventory.
		TriggerClientEvent("inventory:toggle", source, true)

		-- Add to cache.
		Search.players[source] = target
		
		-- Log it.
		exports.log:Add({
			source = source,
			target = target,
			verb = isFrisk and "frisked" or "searched",
		})
	end
end)

RegisterNetEvent("inventory:subscribe", function(id, value)
	local source = source
	if not value then return end

	local target = Search.players[source]
	if not target then return end

	local containerId = exports.inventory:GetPlayerContainer(target, true)
	if id == containerId then
		Search.players[source] = nil
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Search:Update()
		Citizen.Wait(0)
	end
end)