Decoration = {}
Decoration.__index = Decoration

function Decoration:Create(data)
	if type(data.item) == "string" then
		local item = exports.inventory:GetItem(data.item)
		if not item then return false end
		
		data.item_id = item.id
		data.item = nil
	end

	if not data.id then
		local setters = "pos_x=@pos_x,pos_y=@pos_y,pos_z=@pos_z,rot_x=@rot_x,rot_y=@rot_y,rot_z=@rot_z"
		local values = {
			["@pos_x"] = data.coords.x,
			["@pos_y"] = data.coords.y,
			["@pos_z"] = data.coords.z,
			["@rot_x"] = data.rotation.x,
			["@rot_y"] = data.rotation.y,
			["@rot_z"] = data.rotation.z,
		}

		for _, key in pairs(Server.Properties) do
			local value = data[key]
			if value then
				if setters ~= "" then
					setters = setters..","
				end
				setters = setters..key.."=@"..key
				values["@"..key] = value
			end
		end

		data.id = exports.GHMattiMySQL:QueryScalar(([[
			INSERT INTO `decorations` SET %s;
			SELECT LAST_INSERT_ID();
		]]):format(setters), values)
	end

	local decoration = setmetatable(data, Decoration)

	decoration:UpdateGrid()

	Main.decorations[decoration.id] = decoration

	return decoration
end

function Decoration:Destroy()
	-- Remove from grid.
	local grid = self:GetGrid()
	if grid then
		grid:RemoveDecoration(self.id)
	end

	-- Uncache decoration.
	Main.decorations[self.id] = nil

	-- Remove from database.
	exports.GHMattiMySQL:QueryAsync("DELETE FROM `decorations` WHERE id=@id", {
		["@id"] = self.id
	})
end

function Decoration:UpdateGrid()
	local lastGrid = self:GetGrid()
	if lastGrid then
		lastGrid:RemoveDecoration(self.id)
	end

	self.grid = Grids:GetGrid(self.coords, Config.GridSize)
	
	local grid = self:GetGrid()
	if not grid then
		grid = Grid:Create(self.instance or self.grid)
	end
	
	grid:AddDecoration(self)
end

function Decoration:GetGrid()
	if not self.grid then return end
	return Main.grids[self.instance or self.grid]
end