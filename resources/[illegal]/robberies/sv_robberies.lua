Cooldowns = {}
Players = {}
Sites = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for siteId, site in pairs(Sites) do
			if site.lastAction and os.time() - site.lastAction > Config.ResetTime * 60 then
				site.lastAction = nil
				site.beingRobbed = nil
				site.robbables = {}
				
				local siteSettings = Config.Robberies.Sites[siteId]
				if siteSettings and siteSettings.OnReset then
					pcall(function()
						siteSettings.OnReset(site)
					end)
				end
				
				Inform(siteId)

				print("[ROBBERIES] Resetting site: "..siteId)
			end
		end
	end
end)

--[[ Functions ]]--
function Inform(siteId)
	local site = Sites[siteId]
	if not site then return end

	for player, _ in pairs(site.players) do
		TriggerClientEvent("robberies:sync", player, siteId, site)
	end
end

function BeginRobbery(source, siteId, robbableId, robbable, slotId)
	local site = Sites[siteId]
	if not site then return false end
	
	local siteSettings = Config.Robberies.Sites[siteId]
	if not siteSettings then return false end
	
	local typeSettings = Config.Robberies.Types[siteSettings.Type]
	if not typeSettings then return false end
	
	local categorySettings = Config.Robberies.Categories[typeSettings.Category]
	if not categorySettings then return false end

	if not robbableId then return false end
	local robbableSettings = Config.Robbables[robbableId]
	if not robbableSettings then return false end

	robbable = siteSettings.Robbables[robbable]
	if not robbable then return false end
	
	-- Checks.
	if not site.beingRobbed then
		-- Cop check.
		if typeSettings.MinPresence and not Config.EnableDebug then
			local presence = exports.jobs:CountActiveDuty("Robberies")
			if presence < typeSettings.MinPresence then
				return false, Config.Messages.InsufficientPresence:format(presence, typeSettings.MinPresence)
			end
		end

		-- Cooldown check.
		local cooldown = Cooldowns[typeSettings.Category]
		if cooldown then
			local timer = categorySettings.Cooldown * 60 - (os.time() - cooldown)
			if timer > 0 then
				return false, Config.Messages.Cooldown:format(math.ceil(timer / 60.0))
			end
		end
	end

	-- Extra checks.
	if robbable.Condition then
		if not robbable.Condition(source, robbable, site) then
			return
		end
	end

	-- Item check and take.
	if robbableSettings.Items or robbable.Items then
		-- Get player container id.
		local containerId = exports.inventory:GetPlayerContainer(source, true)
		if not containerId then return end

		-- Get item in slot.
		local item = exports.inventory:ContainerInvokeSlot(containerId, slotId.slot_id, "GetItem")
		if not item then return end

		local isItemValid = false

		for _, validItem in ipairs(robbableSettings.Items or robbable.Items) do
			if validItem == item.name then
				isItemValid = true
				break
			end
		end

		if not isItemValid then return false end
		exports.inventory:TakeItem(source, item.name, 1)
	end

	-- Finalize the robbery.
	if not site.beingRobbed then
		exports.dispatch:Add({
			coords = siteSettings.Center,
			group = "emergency",
			hasBlip = true,
			message = "10-90",
			messageType = 0,
			source = source
		})

		site.beingRobbed = true
	end
	
	exports.log:Add({
		source = source,
		verb = "triggered",
		noun = robbableId or "?",
		extra = ("site: %s - type: %s"):format(siteSettings.Name or "?", siteSettings.Type or "?"),
	})

	site.lastAction = os.time()

	Cooldowns[typeSettings.Category] = os.time()

	-- Final callback.
	if robbable.OnBegin then
		pcall(function()
			robbable.OnBegin(robbable, site, robbableSettings, siteSettings)
		end)
	end

	return true
end

function CheckRobbable(siteId, coords)
	local site = Sites[siteId]
	if not site then return false end

	for _, robbableCoords in ipairs(site.robbables) do
		if #(robbableCoords - coords) < 0.1 then
			return false
		end
	end
	return true
end

--[[ Events ]]--
RegisterNetEvent("robberies:begin")
AddEventHandler("robberies:begin", function(cookie, robbableId, robbable, slotId)
	local source = source

	local siteId = Players[source]
	if not siteId then return end

	local site = Sites[siteId]
	if not site then return end

	local success, message = BeginRobbery(source, siteId, robbableId, robbable, slotId)
	if success then
		TriggerClientEvent("robberies:begin", source, cookie)
	else
		TriggerClientEvent("robberies:failed", source, message)
	end
end)

RegisterNetEvent("robberies:finish")
AddEventHandler("robberies:finish", function(robbableType, robbableId, coords)
	local source = source
	local siteId = Players[source]
	if not siteId then return end
	if not robbableType then return end

	local site = Sites[siteId]
	if not site then return end
	
	local siteSettings = Config.Robberies.Sites[siteId]
	if not siteSettings then return end

	local robbable = siteSettings.Robbables[robbableId]
	if not robbable then return end

	local typeSettings = Config.Robberies.Types[siteSettings.Type]
	if not typeSettings then return end
	
	local categorySettings = Config.Robberies.Categories[typeSettings.Category]
	if not categorySettings then return end

	local robbableSettings = Config.Robbables[robbableType]
	if not robbableSettings then return end

	if not CheckRobbable(siteId, coords) then return end

	exports.log:Add({
		source = source,
		verb = "robbed",
		noun = robbableType or "?",
		extra = ("site: %s - type: %s"):format(siteSettings.Name or "?", siteSettings.Type or "?"),
	})

	table.insert(site.robbables, coords)

	-- Generic items.
	if robbable.Output or robbableSettings.Output then
		local seed = math.floor(os.clock() * 1000)
		for k, output in ipairs(robbable.Output or robbableSettings.Output) do
			math.randomseed(seed + k)
			if not output.Chance or math.random() <= output.Chance then
				local amount = output.Amount
				if type(amount) == "table" then
					amount = math.random(amount[1], amount[2])
				end
				if output.Name == "Bills" then
					exports.inventory:GiveMoney(source, amount)
				else
					exports.inventory:GiveItem(source, output.Name, amount)
				end
			end
		end
	end

	-- Unlock doors.
	if robbable.Unlocks then
		for _, door in ipairs(robbable.Unlocks) do
			TriggerEvent("doors:subscribe", DoorGroups[siteSettings.Name])
			TriggerEvent("doors:toggle", DoorGroups[siteSettings.Name], door, false)
		end
	end

	-- Final callback.
	if robbable.OnFinish then
		pcall(function()
			robbable.OnFinish(robbable, site, robbableSettings, siteSettings, coords)
		end)
	end

	Inform(siteId)
end)

RegisterNetEvent("robberies:subscribe")
AddEventHandler("robberies:subscribe", function(siteId)
	local source = source
	local lastSiteId = Players[source]
	if lastSiteId then
		local lastSite = Sites[lastSiteId]
		if lastSite then
			lastSite.players[source] = nil
		end
	end

	if siteId == nil or type(siteId) ~= "number" then return end
	local site = Sites[siteId]
	if site then
		site.players[source] = true
	else
		site = {
			players = {
				[source] = true
			},
			robbables = {},
			stage = 0,
		}
		
		Sites[siteId] = site
	end
	Players[source] = siteId

	TriggerClientEvent("robberies:sync", source, siteId, site)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	local lastSiteId = Players[source]
	if lastSiteId then
		local lastSite = Sites[lastSiteId]
		if lastSite then
			lastSite.players[source] = nil
		end
		Players[source] = nil
	end
end)