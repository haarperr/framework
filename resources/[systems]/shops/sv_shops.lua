--[[ Functions: Main ]]--
function Main:_Init()
	self:LoadDatabase()
end

function Main:LoadDatabase()
	WaitForTable("decorations")

	for _, path in ipairs({
		"sql/shops.sql",
	}) do
		RunQuery(path)
	end
end

--[[ Functions: Shop ]]--
function Shop:Load()
	-- Load decorations.
	if self.info.Decorations then
		self.decorations = {}

		for k, info in ipairs(self.info.Decorations) do
			info.temporary = true

			local decoration = exports.decorations:Register(info)
			if decoration then
				self.decorations[k] = decoration.id
			end
		end
	end

	-- Load containers.
	if self.info.Containers then
		self.containers = {}

		for k, info in ipairs(self.info.Containers) do
			info.temporary = true
			info.type = "drop"
			info.name = info.text
			info.width = info.width or 3
			info.height = info.height or 2
			info.persistent = true

			local container = exports.inventory:RegisterContainer(info)
			if container then
				self.containers[k] = container.id
			end
		end
	end
end

function Shop:GetContainer()
	-- Get cached container.
	local containerId = self.storage

	-- Return cached container.
	if containerId then
		return containerId
	end

	-- Get storage settings.
	local settings = self.info.Storage
	if not settings then return end

	-- Create or load the container.
	local container = exports.inventory:LoadContainer({
		sid = "s"..self.id,
		type = "shop",
		protected = true,
		coords = settings.Coords,
		filters = settings.Filters,
	}, true)

	-- Check container.
	if not container then
		print("failed to load container", self.id)
		return
	end

	-- Cache container.
	containerId = container.id
	self.storage = containerId

	-- Return container.
	return containerId
end

function Shop:AccessStorage(source)
	-- Verify player can access container.
	if not self:CanAccessStorage(source) then
		exports.user:TriggerTrap(source, false, ("accessing protected storage (shop: %s)"):format(self.id))
		return false
	end

	-- Get container id.
	local containerId = self:GetContainer()
	if not containerId then return end

	-- Add player to container.
	exports.inventory:Subscribe(source, containerId, true)

	TriggerClientEvent("inventory:toggle", source, true)

	return true
end

function Shop:CanAccessStorage(source)
	return exports.user:IsAdmin(source)
end

function Shop:StockContainer()
	local settings = self.info.Storage
	if not settings then return false end

	local containerId = self:GetContainer()
	if not containerId then return false end

	local filters = settings.Filters
	if filters and filters.item then
		for name, _ in pairs(filters.item) do
			local item = exports.inventory:GetItem(name)
			if not exports.inventory:ContainerAddItem(containerId, name, item.stack or 1) then
				break
			end
		end
	end

	return true
end

function Shop:GetStock()
	-- Get container id.
	local containerId = self:GetContainer()
	if not containerId then return end

	-- Check cache.
	local snowflake = exports.inventory:ContainerGet(containerId, "snowflake")
	if self.stock and self.snowflake == snowflake then
		return self.stock
	end

	-- Get container.
	local container = exports.inventory:GetContainer(containerId)
	if not container then return end

	-- Update stock.
	local stock = {}
	for slotId, slot in pairs(container.slots) do
		if (slot.durability or 1.0) > 0.25 then
			stock[slot.item_id] = (stock[slot.item_id] or 0) + (slot.quantity or 0)
		end
	end

	-- Cache stock.
	self.stock = stock
	self.snowflake = snowflake

	return stock
end

function Shop:Interact(npc, source)
	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, true) then return end
	
	-- Inform client.
	TriggerClientEvent("shops:loadShop", source, self.id, self:GetStock())
end

function Shop:Purchase(source, cart)
	return true
end

--[[ Events: Net ]]--
RegisterNetEvent("shops:openStorage", function(id)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, true) then return end

	-- Get shop.
	local shop = Main.shops[id or false]
	if not shop then return end

	-- Open storage.
	if shop:AccessStorage(source) then
		exports.log:Add({
			source = source,
			verb = "accessed",
			noun = "storage",
			extra = id,
		})
	end
end)

RegisterNetEvent("shops:purchase", function(id, cart)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, true) then return end

	-- Check input.
	if type(cart) ~= "table" then return end

	-- Get shop.
	local shop = Main.shops[id or false]
	if not shop then return end

	-- Make purchase.
	if shop:Purchase(source, cart) then
		exports.log:Add({
			source = source,
			verb = "made",
			noun = "purchase",
			extra = id,
		})
	end
end)

--[[ Events ]]--
AddEventHandler("shops:start", function()
	Main:Init()
end)