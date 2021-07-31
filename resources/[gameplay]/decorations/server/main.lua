Main.players = {}
Main.queue = {}

--[[ Functions ]]--
function Main:Init()
	-- Load tables.
	self:LoadDatabase()

	-- Load decorations.
	self:LoadDecorations()
	
	-- Load players.
	self:LoadPlayers()
end

function Main:LoadDatabase()
	WaitForTable("characters")
	WaitForTable("items")

	RunQuery("sql/decorations.sql")
end

function Main:LoadPlayers()
	for i = 1, GetNumPlayerIndices() do
		local player = tonumber(GetPlayerFromIndex(i - 1))
		local ped = GetPlayerPed(player)

		if ped and DoesEntityExist(ped) then
			local gridId = exports.instances:Get(player) or Grids:GetGrid(GetEntityCoords(ped), Config.GridSize)
			self:SetGrid(player, gridId)
		end
	end
end

function Main:LoadDecorations()
	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `decorations`")

	for _, data in ipairs(result) do
		data.coords = vector3(data.pos_x, data.pos_y, data.pos_z)
		data.rotation = vector3(data.rot_x, data.rot_y, data.rot_z)

		data.pos_x = nil
		data.pos_y = nil
		data.pos_z = nil

		data.rot_x = nil
		data.rot_y = nil
		data.rot_z = nil

		local decoration = Decoration:Create(data)
	end
end

function Main:SetGrid(source, gridId)
	local player = self.players[source]
	if not player then
		player = {}
		self.players[source] = player
	elseif player.grid == gridId then
		return
	elseif player.grid then
		local lastGrid = self.grids[player.grid]
		if lastGrid then
			lastGrid:RemovePlayer(source)
		end
	end
	
	local grid = self.grids[gridId]
	if not grid then
		grid = Grid:Create(gridId)
	end
	
	grid:AddPlayer(source)

	player.time = os.clock()
	player.grid = gridId

	local payload = {}

	if type(grid.id) == "string" then
		payload[grid.id] = grid.decorations
	else
		local nearbyGrids = Grids:GetNearbyGrids(grid.id, Config.GridSize)
		for k, gridId in ipairs(nearbyGrids) do
			local grid = self.grids[gridId]
			if grid and grid.decorations then
				payload[grid.id] = grid.decorations
			end
		end
	end

	Debug("Sending payload to: [%s] in %s", source, grid.id)

	TriggerClientEvent(self.event.."sync", source, payload)
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	local player = Main.players[source]
	if not player then return end
	
	local lastGrid = self.grids[player.grid]
	if lastGrid then
		lastGrid:RemovePlayer(source)
	end
	
	Main.players[source] = nil
end)

AddEventHandler("instances:join", function(source, id)
	Main:SetGrid(source, id)
end)

AddEventHandler("instances:leave", function(source, id)
	local ped = GetPlayerPed(source)
	local gridId = Grids:GetGrid(GetEntityCoords(ped), Config.GridSize)

	Main:SetGrid(source, gridId)
end)

--[[ Events: Net ]]--
RegisterNetEvent("grids:enter"..Config.GridSize, function(gridId)
	local source = source
	
	if type(gridId) ~= "number" or exports.instances:IsInstanced(source) then return end

	Main:SetGrid(source, gridId)
end)

RegisterNetEvent(Main.event.."place", function(item, variant, coords, rotation)
	local source = source

	-- Get settings.
	local settings = Config.Decorations[item or false]
	if not settings then
		print("no settings")
		return
	end

	-- Get player.
	local player = Main.players[source]
	if not player then
		player = {}
		Main.players[source] = player
	end

	-- Update cooldowns.
	if player.lastPlaced and os.clock() - player.lastPlaced < 1.0 then return end
	player.lastPlaced = os.clock()

	-- Check input.
	if type(coords) ~= "vector3" or type(rotation) ~= "vector3" or (variant and type(variant) ~= "number") then
		print("invalid input type")
		return
	end

	-- Get character id.
	local character = exports.character:Get(source, "id")
	if not character then return end

	-- Get instance.
	local instance = exports.instances:Get(source)

	-- Create decoration.
	local decoration = Decoration:Create({
		item = item,
		coords = coords,
		rotation = rotation,
		variant = variant,
		instance = instance,
		character_id = character,
	})
end)

--[[ Commands ]]--
RegisterCommand("decorations:debug", function(source, args, command)
	if source ~= 0 then return end
	
	for gridId, grid in pairs(Main.grids) do
		print("Grid "..gridId)

		print("\tDecorations")

		for id, decoration in pairs(grid.decorations) do
			print("\t\t"..id, json.encode(decoration))
		end

		print("Players")
		for source, _ in pairs(grid.players) do
			print("\t\t"..source)
		end
	end
end, true)