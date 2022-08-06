--[[ Player Caching ]]--
local Cache = {}
local Grids = {}

RegisterNetEvent("grids:enter"..Config.PlayerGridSize)
AddEventHandler("grids:enter"..Config.PlayerGridSize, function(grid)
	if type(grid) ~= "number" then return end

	local source = source
	local lastGrid = Cache[source]

	if lastGrid then
		local count = Grids[lastGrid].count - 1
		Grids[lastGrid].sources[source] = nil
		Grids[lastGrid].count = count
		
		if count <= 0 then
			Grids[lastGrid] = nil
		end
	end

	Cache[source] = grid

	if Grids[grid] then
		Grids[grid].sources[source] = true
		Grids[grid].count = Grids[grid].count + 1
	else
		Grids[grid] = { sources = { [source] = true }, count = 1 }
	end

	TriggerClientEvent("grids:setPlayerGrids", source, GetNearbyPlayers(source, true))
end)

function GetNearbyPlayers(source, excludeSource)
	local grid = Cache[source]
	if not grid then return {} end

	local grids = GetNearbyGrids(grid, Config.PlayerGridSize)
	local players = {}
	for _, _grid in ipairs(grids) do
		local __grid = Grids[_grid]
		if __grid then
			for _source, _ in pairs(__grid.sources) do
				if not excludeSource or _source ~= source then
					players[#players + 1] = _source
				end
			end
		end
	end
	return players
end
exports("GetNearbyPlayers", GetNearbyPlayers)