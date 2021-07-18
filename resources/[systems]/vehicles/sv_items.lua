RegisterNetEvent("vehicles:repair")
AddEventHandler("vehicles:repair", function(slotId, componentId)
	local source = source

	-- Item decay.
	if not slotId then return end
	local slot = exports.inventory:GetSlot(source, slotId, true)
	if not slot then return end

	local itemName = exports.inventory:GetItem(slot[1]).name
	local deacy = 0.0
	if itemName == "Repair Kit" then
		decay = 0.03
	elseif itemName == "Advanced Repair Kit" then
		decay = 0.008
	else
		return
	end

	exports.inventory:DecayItem(source, slotId, decay, true)

	-- Advanced repairs.
	if not componentId then return end
	local component = Config.Repairing.Components[componentId]
	if not component then return end

	local part = Config.Repairing.Parts[component.Repair]
	if not part then return end

	if part.Item then
		exports.inventory:TakeItem(source, part.Item, 1)
	end
end)

RegisterNetEvent("vehicles:hotwiring")
AddEventHandler("vehicles:hotwiring", function(slotId)
	local source = source
	
	math.randomseed(math.floor(os.clock() * 1000))
	exports.inventory:DecayItem(source, slotId, math.random() * 0.05, true)
end)

RegisterNetEvent("vehicles:upgrade")
AddEventHandler("vehicles:upgrade", function(slotId)
	local source = source

	local slot = exports.inventory:GetSlot(source, slotId, true)
	if not slot then return end

	local item = exports.inventory:GetItem(slot[1])
	if not item then return end

	exports.log:Add({
		source = source,
		verb = "upgraded",
		noun = "vehicle",
		extra = ("item: %s"):format(item.name),
	})
	
	exports.inventory:TakeItem(source, item, 1, slotId)
end)