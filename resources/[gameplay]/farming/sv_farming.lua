Zones = {}
Players = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for zoneId, zone in pairs(Zones) do
			local zoneSettings = Config.Zones[zoneId]
			local removed = 0
			for _k, harvest in ipairs(zone.harvests) do
				if os.time() - harvest[3] > zoneSettings.CooldownTime * 60 then
					table.remove(zone.harvests, _k)
					removed = removed + 1
				end
			end
			if removed > 0 then
				for player, _ in pairs(zone.players) do
					TriggerClientEvent("farming:sync", player, zone.harvests)
				end
			end
			Citizen.Wait(1000)
		end
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
RegisterNetEvent("farming:harvest")
AddEventHandler("farming:harvest", function(coords)
	local source = source
	if type(coords) ~= "vector3" then return end
	local zoneId = Players[source]
	if not zoneId then return end

	local zone = Zones[zoneId]
	if not zone then return end

	
	-- Add harvest.
	local harvest = {source, coords, os.time()}
	table.insert(zone.harvests, harvest)
	
	-- Sync to players.
	for player, _ in pairs(zone.players) do
		TriggerClientEvent("farming:harvest", player, harvest)
	end

	-- Log.
	exports.log:Add({
		source = source,
		verb = "harvested",
		extra = ("zone: %s"):format(zoneId),
	})
	
	-- Give items.
	local zoneSettings = Config.Zones[zoneId]
	if not zoneSettings.Items then return end

	for k, v in ipairs(zoneSettings.Items) do
		local amount = v[2]
		if type(v[2]) == "table" then
			math.randomseed(os.clock() + k)
			amount = math.random(v[2][1], v[2][2] + 1)
		end
		exports.inventory:GiveItem(source, v[1], amount)
	end
end)

RegisterNetEvent("farming:subscribe")
AddEventHandler("farming:subscribe", function(zoneId)
	local source = source

	if Players[source] and Zones[Players[source]] then
		Zones[Players[source]].players[source] = nil
	end

	if not tonumber(zoneId) then return end

	local zone = Zones[zoneId]
	if zone then
		zone.players[source] = true
	else
		zone = {
			players = { [source] = true },
			harvests = {}
		}
		Zones[zoneId] = zone
	end
	Players[source] = zoneId
	TriggerClientEvent("farming:sync", source, zone.harvests)
end)

AddEventHandler("playerDropped", function()
	local source = source
	if Players[source] then
		if Zones[Players[source]] then
			Zones[Players[source]].players[source] = nil
		end
		Players[source] = nil
	end
end)