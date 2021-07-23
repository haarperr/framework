Weapons = {
	queue = {},
}

--[[ Functions: Weapons ]]--
function Weapons:UpdateQueue()
	for source, buffer in pairs(self.queue) do
		self:UpdateBuffer(source, buffer.slotId, buffer.count)
		self.queue[source] = nil
	end
end

function Weapons:UpdateBuffer(source, slotId, count)
	-- Get player container id.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get item in slot.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item or item.usable ~= "Weapon" then return end

	-- Take throwables.
	if item.category == "Throwable" then
		exports.inventory:ContainerInvokeSlot(containerId, slotId, "Destroy")
		return
	end

	-- Decay slot (1 / shots).
	exports.inventory:ContainerInvokeSlot(containerId, slotId, "Decay", (1.0 / 1000) * count)
end

function Weapons:Shoot(source, didHit, coords, hitCoords, entity, weapon, slotId)
	-- Check slot.
	if type(slotId) ~= "number" then return end

	-- Add to queue.
	local queue = self.queue[source]
	if not queue then
		queue = {
			slotId = slotId,
			count = 0,
		}
		self.queue[source] = queue
	end

	queue.count = queue.count + 1
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Weapons:UpdateQueue()
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
RegisterNetEvent("shoot", function(...)
	local source = source
	Weapons:Shoot(source, ...)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Weapons.queue[source] = nil
end)

AddEventHandler("inventory:use", function(source, item, slot)
	if item.ammo and item.count and item.usable == "Magazine" then
		-- Get player container id.
		local containerId = exports.inventory:GetPlayerContainer(source, true)
		if not containerId then return end

		-- Get fields.
		local fields = slot.fields
		if not fields then
			fields = {}
		end

		-- Get ammo.
		local ammoName = item.ammo
		local ammo = fields[1] or 0

		local bullets = math.min(exports.inventory:ContainerCountItem(containerId, ammoName), item.count - ammo)
		if bullets == 0 then return end

		ammo = ammo + bullets

		-- Take bullets.
		if not exports.inventory:TakeItem(source, ammoName, bullets) then return end

		-- Set fields.
		exports.inventory:ContainerInvokeSlot(containerId, slot.slot_id, "SetField", 1, ammo)
	end
end)