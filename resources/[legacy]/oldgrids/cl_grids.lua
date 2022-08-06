LastGrid = {}
LastNearby = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		for k, v in ipairs(Config.Sizes) do
			local grid = GetGrid(coords, v, true)
			local lastGrid = LastGrid[k]
			
			if lastGrid ~= grid then
				LastGrid[k] = grid
				local nearbyGrids = GetNearbyGrids(coords, v, true)
				
				if LastNearby[k] then
					TriggerEvent("grids:exit"..k, lastGrid, LastNearby[k] or {})
				end
				TriggerEvent("grids:enter"..k, grid, nearbyGrids)
				TriggerServerEvent("grids:enter"..k, grid)

				LastNearby[k] = nearbyGrids
			else
				break
			end
		end
	end
end)