RegisterNetEvent("gathering:gather", function(siteId, slotId, gatherType)
	local source = source

	if type(siteId) ~= "number" or type(slotId) ~= "number" or type(gatherType) ~= "string" then return end

	-- Get site.
	local site = Config[gatherType].Sites[siteId]
	if not site then return end

	-- Get player container id.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get item in slot.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item or not isConfiguredItem(item.name) then return end

	-- Decay item.
	if not exports.inventory:ContainerInvokeSlot(containerId, slotId, "Decay", Config[gatherType].Decay) then
		return
	end

	-- Give stuff.
	local seed = math.floor(os.clock() * 1000.0)
	local gave = false
	local couldGive = false
	for _, configItem in ipairs(site.Items) do
		math.randomseed(seed + _)
		if math.random() < configItem[3] then
			local amount = configItem[2]
			if type(amount) == "table" then
				amount = math.random(amount[1], amount[2])
			end
			couldGive, reason = table.unpack(exports.inventory:GiveItem(source, configItem[1], amount))
			gave = true
		end
	end

	if not gave then
		couldGive, reason = table.unpack(exports.inventory:GiveItem(source, site.Items[1][1], site.Items[1][2][1]))
	end
	
	-- Logging
	if couldGive then
		-- Log it.
		exports.log:Add({
			source = source,
			verb = Config[gatherType].Messages.Logging,
			extra = ("site: %s"):format(siteId),
			channel = "misc",
		})
	else
		-- Notify player.
		TriggerClientEvent("chat:notify", source, "You couldn't hold anymore!", "error")
	end
end)

function isConfiguredItem(item)
	for gatherType, settings in pairs(Config) do
		if item == settings.Item then return gatherType end
	end
	return false
end