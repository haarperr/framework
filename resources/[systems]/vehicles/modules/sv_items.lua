RegisterNetEvent("vehicles:useItem", function(netId, partId, slotId)
	print(netId, partId, slotId)

	-- Check parameters.
	if type(netId) ~= "number" or type(partId) ~= "number" or type(slotId) ~= "number" then return end

	-- Check entity exists.
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(entity) then return end

	-- Get part.
	local part = Main.parts[partId]
	if not part then
		return
	end

	-- Get player container.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get slot.
	local slot = exports.inventory:ContainerGetSlot(containerId, slotId)
	if not slot then return end

	-- Get item.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item or (item.repair or item.name) ~= part.Name then return end

	-- Get or create vehicle.
	local vehicle = Main.vehicles[netId or false]
	if not vehicle then
		vehicle = Vehicle:Create(netId)
	end

	print("WOW GREAT JOB CHANGE YOUR PART OUT NOW", item.name)

	-- Get durabilities.
	math.randomseed(math.ceil(os.clock() * 1000.0))

	local oldDurability = (vehicle.info.damage[partId] or 1.0) - math.random() * 0.01
	local newDurability = slot.durability or 1.0

	-- Take item.
	local didTake, tookAmount = table.unpack(exports.inventory:TakeItem(source, item.name, 1, slotId))
	if not didTake then return end

	-- Give item.
	if oldDurability > 0.01 then
		exports.inventory:GiveItem(source, {
			item = item.name,
			durability = oldDurability < 0.99 and oldDurability or nil,
			quantity = 1,
		})
	end

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "switched",
		noun = "part",
		extra = ("vin: %s - part: %s"):format(vehicle:Get("vin"), item.name),
	})

	-- Set damage.
	vehicle.info.damage[partId] = newDurability
	vehicle:Set("damage", vehicle.info.damage)
end)