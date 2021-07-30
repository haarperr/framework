Decoration = {}
Decoration.__index = Decoration

function Decoration:Create(data)
	-- Get item.
	local item = exports.inventory:GetItem(data.item_id)
	if not item then return end

	-- Get settings.
	local settings = Config.Decorations[item.name]
	if not settings then return end
	
	-- Debug.
	Debug("Created decoration: %s", item.name)

	-- Create instance.
	local decoration = setmetatable(data, Decoration)

	decoration.settings = settings
	decoration:CreateModel()

	-- Cache instance.
	Main.decorations[data.id] = decoration
	
	-- Add to grid.
	local grid = Main.grids[data.grid]
	if not grid then
		grid = {}
		Main.grids[data.grid] = grid
	end

	grid[data.id] = decoration

	-- Return instance.
	return decoration
end

function Decoration:Destroy()
	Debug("Destroyed decoration: %s", self.id)

	-- Delete entity.
	local entity = self.entity
	if entity and DoesEntityExist(entity) then
		DeleteEntity(entity)
	end

	-- Uncache instance.
	Main.decorations[self.id] = nil

	-- Remove from grid.
	local grid = Main.grids[self.grid]
	if grid then
		grid[self.id] = nil
	end

	-- Clean grid.
	local next = next
	if next(grid) == nil then
		Main.grids[self.grid] = nil
	end
end

function Decoration:CreateModel()
	local settings = self.settings
	if not settings then return end

	-- Get coords.
	local coords = self.coords
	local rotation = self.rotation

	-- Get model.
	local model = Main:GetModel(settings, self.variant)

	if type(model) == "table" then
		model = model.Name
	end

	-- Request model.
	if not WaitForRequestModel(model) then
		return
	end

	-- Create object.
	local entity = CreateObject(model, coords.x, coords.y, coords.z, false, true)

	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityRotation(entity, rotation.x, rotation.y, rotation.z)
	SetEntityDynamic(entity, false)
	SetEntityInvincible(entity, true)
	FreezeEntityPosition(entity, true)
	SetEntityLodDist(entity, 200)

	SetModelAsNoLongerNeeded(model)

	self.entity = entity
end