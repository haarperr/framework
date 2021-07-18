-- Thread: Players.
Citizen.CreateThread(function()
	local lastUpdate = os.clock()
	local shots = {}

	while true do
		local delta = os.clock() - lastUpdate

		for source, player in pairs(Players) do
			local zone = player.zone
			if not zone then goto continue end

			local faction = player.faction or ""

			local zoneSettings = Config.Zones[zone]
			if not zoneSettings then goto continue end

			local isCommunity = zoneSettings.Type == "Community"
			local isGang = zoneSettings.Type == "Gang"

			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)

			local addReputation = 0.0

			local isAggressor = false

			if player.shooting then
				-- Get/set the first shots.
				local shot = shots[zone]
				if not shot then
					shot = {}
					shots[zone] = shot
				end
				local firstShot = shot[faction]
				if not firstShot or os.clock() - firstShot > 300.0 then
					firstShot = os.clock()
					shot[faction] = firstShot
				end
				-- Determine the aggressor.
				isAggressor = true
				for _faction, _firstShot in pairs(shot) do
					if _faction ~= faction and _firstShot < firstShot then
						isAggressor = false
						break
					end
				end
				-- Take reputation as aggressor.
				if isAggressor then
					addReputation = addReputation - 0.03
				end
			end

			-- Weapon reputation.
			if player.weaponGroup then
				local weaponRating = Config.Weapons[player.weaponGroup]
				if weaponRating == 1 and (isAggressor or (not isAggressor and player.aiming)) then
					addReputation = addReputation - 0.01
				elseif weaponRating == 2 and (isAggressor or isCommunity or (isGang and not isAggressor and player.aiming)) then
					addReputation = addReputation - 0.02
				end
			end

			-- Passive reputation.
			if addReputation > -0.000001 and not isAggressor then
				addReputation = addReputation + 0.0005
			end
			
			-- Finally, add reputation.
			if math.abs(addReputation) > 0.000001 then
				AddReputation(zone, faction, addReputation)
			end

			::continue::
		end

		lastUpdate = os.clock()

		Citizen.Wait(1000)
	end
end)

-- Thread: Reputation.
Citizen.CreateThread(function()
	local lastUpdate = os.clock()
	local interval = 60.0 * 60.0
	while true do
		local delta = (os.clock() - lastUpdate) / interval
		for zoneId, factions in pairs(Zones) do
			for faction, reputation in pairs(factions) do
				if reputation > 1.0 then
					reputation = math.max(reputation - delta * 0.5, 1.0)
					
					factions[faction] = reputation
					UpdatedZones[zoneId] = true
				elseif reputation < 0.0 then
					reputation = math.min(reputation + delta * 0.25, 0.0)
					
					factions[faction] = reputation
					UpdatedZones[zoneId] = true
				end
				if math.abs(reputation) < 0.0000001 then
					factions[faction] = nil
					UpdatedZones[zoneId] = true
				end
			end
		end
		lastUpdate = os.clock()
		Citizen.Wait(60000)
	end
end)

-- Thread: Saving.
Citizen.CreateThread(function()
	while true do
		for zoneId, _ in pairs(UpdatedZones) do
			Save(zoneId)
		end
		UpdatedZones = {}
		Citizen.Wait(15000)
	end
end)

-- Thread: Decorations.
Citizen.CreateThread(function()
	while true do
		for _, player in ipairs(GetPlayers()) do
			local source = tonumber(player)

			TriggerClientEvent("territories:update", source, GetPrimaryControl(source))
		end

		Citizen.Wait(3000)
	end
end)