Decoration = {}
Decoration.__index = Decoration

function Decoration:Create(data)
	-- Get item.
	local item = exports.inventory:GetItem(data.item_id)
	if not item then return end

	-- Get settings.
	local settings = Decorations[item.name]
	if not settings then return end

	-- Cache grid id.
	local gridId = data.instance or data.grid
	
	-- Debug.
	Debug("Created decoration: %s in %s", item.name, gridId)

	-- Create instance.
	local decoration = setmetatable(data, Decoration)

	decoration.settings = settings
	decoration:CreateModel()

	-- Cache instance.
	Main.decorations[data.id] = decoration
	
	-- Add to grid.
	local grid = Main.grids[gridId]
	if not grid then
		grid = {}
		Main.grids[gridId] = grid
	end

	grid[data.id] = decoration

	-- Return instance.
	return decoration
end

function Decoration:Destroy()
	local gridId = self.instance or self.grid

	Debug("Destroyed decoration: %s in %s", self.id, gridId)

	-- Delete entity.
	local entity = self.entity
	if entity and DoesEntityExist(entity) then
		DeleteEntity(entity)
	end

	-- Uncache instance.
	Main.decorations[self.id] = nil

	-- Remove from grid.
	local grid = Main.grids[gridId]
	if grid then
		grid[self.id] = nil
	end

	-- Clean grid.
	local next = next
	if next(grid) == nil then
		Main.grids[gridId] = nil
	end
end

function Decoration:Update()

end

function Decoration:OnSelect()
	-- SetEntityAlpha(self.entity, 128)
	SetEntityDrawOutline(self.entity, true)

	exports.interact:AddOption({
		id = "decoration",
		text = "Decoration",
		icon = "chair",
		sub = {
			{
				id = "pickup",
				text = "Pickup",
				icon = "gavel",
			},
			{
				id = "move",
				text = "Move",
				icon = "carpenter",
			},
			{
				id = "crafting",
				text = "Crafting",
				icon = "construction",
			},
		},
	})
end

function Decoration:OnDeselect()
	-- SetEntityAlpha(self.entity, 255)
	SetEntityDrawOutline(self.entity, false)

	exports.interact:RemoveOption("decoration")
end

function Decoration:CreateModel()
	local settings = self.settings
	if not settings then return end

	-- Remove old entity.
	if self.entity then
		if DoesEntityExist(self.entity) then
			DeleteEntity(self.entity)
		end
		Main.entities[self.entity] = nil
	end

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
	Main.entities[entity] = self
end