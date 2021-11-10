Main = {
	gridIndexes = {},
	grids = {},
	players = {},
	playerGrids = {},
}

--[[ Functions ]]--
function Main:Init()
	for trackIndex, track in pairs(Tracks) do
		for nodeIndex, node in pairs(track) do
			local gridIndex = Grids:GetGrid(node, Config.GridSize)
			local grid = self.grids[gridIndex]
			if not grid then
				grid = {}
				self.grids[gridIndex] = grid
				table.insert(self.gridIndexes, gridIndex)
			end

			grid[#grid + 1] = node
		end
	end
end

function Main:GetRandomNode(retries)
	if retries and retries > 16 then return end

	local gridIndex = self.gridIndexes[GetRandomIntInRange(1, #self.gridIndexes + 1)]
	print(gridIndex)

	for _, nearbyGrid in ipairs(Grids:GetNearbyGrids(gridIndex, Config.GridSize)) do
		if self.playerGrids[nearbyGrid] then
			return self:GetRandomNode((retries or 0) + 1)
		end
	end

	local grid = self.grids[gridIndex]
	local node = grid[GetRandomIntInRange(1, #grid + 1)]

	return node
end

--[[ Events ]]--
AddEventHandler("trains:start", function()
	Main:Init()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	local grid = Main.players[source]
	if grid then
		local amount = Main.playerGrids[grid]
		Main.playerGrids[grid] = amount > 1 and amount - 1 or nil
		Main.players[source] = nil
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("grids:enter"..Config.GridSize, function(gridIndex)
	local source = source
	
	if type(gridIndex) ~= "number" then return end

	local lastGrid = Main.players[source]
	if lastGrid then
		local lastAmount = Main.playerGrids[lastGrid]
		Main.playerGrids[lastGrid] = lastAmount > 1 and lastAmount - 1 or nil
	end

	Main.players[source] = gridIndex
	Main.playerGrids[gridIndex] = (Main.playerGrids[gridIndex] or 0) + 1
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		print("FIND")
		print(Main:GetRandomNode())
		Citizen.Wait(500)
	end
end)