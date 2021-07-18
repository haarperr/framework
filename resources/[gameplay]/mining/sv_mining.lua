RegisterNetEvent("mining:mine")
AddEventHandler("mining:mine", function(siteId, slotId)
	local source = source

	local site = Config.Sites[siteId]
	if not site then return end

	local slot = exports.inventory:GetSlot(source, slotId, true)
	if not slot or exports.inventory:GetItem(slot[1]).name ~= "Pickaxe" then return end

	exports.inventory:DecayItem(source, slotId, 0.02, true)

	exports.log:Add({
		source = source,
		verb = "mined",
		extra = ("site: %s"):format(siteId),
		channel = "misc",
	})

	local seed = math.floor(os.clock() * 1000.0)
	local gave = false
	local couldGive = false
	for _, item in ipairs(site.Items) do
		math.randomseed(seed + _)
		if math.random() < item[3] then
			local amount = item[2]
			if type(amount) == "table" then
				amount = math.random(amount[1], amount[2])
			end
			couldGive = exports.inventory:GiveItem(source, item[1], amount)
			gave = true
		end
	end
	-- Didn't give.
	if not gave then
		couldGive = exports.inventory:GiveItem(source, site.Items[1][1], site.Items[1][2][1])
	end
	-- Couldn't give.
	if not couldGive then
		TriggerClientEvent("notify:sendAlert", source, "error", "Can't hold any more...", 7000)
	end
end)