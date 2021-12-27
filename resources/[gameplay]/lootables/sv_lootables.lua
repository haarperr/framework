Main = {
	grids = {},
	containers = {},
}

--[[ Functions ]]--
function Main:Update()
	local clock = os.clock()
	for gridId, grid in pairs(self.grids) do
		for i = #grid, 1, -1 do
			local info = grid[i]
			if info.time and clock - info.time > Config.Cooldown then
				exports.inventory:DestroyContainer(info.containerId)

				self.containers[info.containerId] = nil
				table.remove(grid, i)
			end
		end

		if #grid == 0 then
			self.grids[gridId] = nil
		end
	end
end

function Main:FindLootable(coords)
	local grids = Grids:GetNearbyGrids(coords, Config.GridSize)
	for _, gridId in ipairs(grids) do
		local grid = self.grids[gridId]
		if grid then
			for index, info in ipairs(grid) do
				if #(info.coords - coords) < 2.0 then
					return info, gridId, index
				end
			end
		end
	end
end

function Main:Loot(source, model, coords)
	-- Get type.
	local modelType = Config.Models[model or false]
	local _type = Config.Types[modelType or false]
	if not _type then
		return false
	end
	
	-- Check already exists.
	if self:FindLootable(coords) then
		return false
	end

	-- Get or create grid.
	local gridId = Grids:GetGrid(coords, Config.GridSize)
	local grid = self.grids[gridId]
	if not grid then
		grid = {}
		self.grids[gridId] = grid
	end

	-- Log event.
	exports.log:Add({
		source = source,
		verb = "looted",
		extra = ("model: %s - type: %s"):format(model, modelType),
	})

	-- Generate loot table.
	local slots = {}
	for _, item in ipairs(_type.Loot) do
		if item.chance and GetRandomFloatInRange(0.0, 1.0) < item.chance then
			slots[#slots + 1] = {
				item = item.item,
				quantity = type(item.quantity) == "table" and GetRandomIntInRange(table.unpack(item.quantity)) or item.quantity,
			}
		end
	end

	-- Create container.
	local container = exports.inventory:RegisterContainer({
		temporary = true,
		protected = true,
		coords = coords,
		slots = slots,
		settings = _type.Container,
	})

	-- Subscribe to the container.
	exports.inventory:Subscribe(source, container.id, true)

	-- Cache info.
	local info = {
		source = source,
		coords = coords,
		containerId = container.id,
		time = os.clock(),
	}

	-- Cache container.
	self.containers[container.id] = info

	-- Insert into grid.
	table.insert(grid, info)

	return true
end

--[[ Events: Net ]]--
RegisterNetEvent("lootables:check", function(snowflake, coords)
	local source = source

	if type(snowflake) ~= "number" or type(coords) ~= "vector3" or not PlayerUtil:CheckCooldown(source, 1.0, true) then return end

	local lootable = Main:FindLootable(coords)

	TriggerClientEvent("lootables:check-"..snowflake, source, lootable ~= nil)

	if lootable then
		exports.inventory:Subscribe(source, lootable.containerId, true)
	end
end)

RegisterNetEvent("lootables:loot", function(model, coords)
	local source = source

	if type(model) ~= "number" or type(coords) ~= "vector3" or not PlayerUtil:CheckCooldown(source, 3.0, true) then return end

	Main:Loot(source, model, coords)
end)

--[[ Events ]]--
AddEventHandler("inventory:slotMoved", function(containerId, sourceSlot, targetContainerId, targetSlot)
	local info = Main.containers[containerId] or Main.containers[targetContainerId]
	if not info then return end

	info.time = os.clock()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(60000 * 5)
	end
end)