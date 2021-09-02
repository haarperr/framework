Parking = {
	grids = {},
	gridSize = 4,
}

function Parking:Init()
	for k, v in ipairs(CarGen) do
		local gridId = Grids:GetGrid(v.coords, self.gridSize)
		local grid = self.grids[gridId]
		if not grid then
			grid = {}
			self.grids[gridId] = grid
		end
		grid[#grid + 1] = v
	end
end

function Parking:Update()
	local coords = GetFinalRenderedCamCoord()
	local grids = Grids:GetImmediateGrids(coords, self.gridSize)
	local scale = 4.0
	
	for _, gridId in ipairs(grids) do
		local grid = self.grids[gridId]
		if grid then
			for __, parking in ipairs(grid) do
				local coords = parking.coords
				local retval, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)

				DrawMarker(
					36,
					coords.x, coords.y, groundZ + 1.0,
					0.0, 0.0, 0.0,
					0.0, 0.0, 0.0,
					scale, scale, scale,
					255, 255, 0, 255,
					false, true,
					2,
					false, nil, nil, false
				)
			end
		end
	end
end

--[[ Listeners ]]--
AddEventHandler("vehicles:clientStart", function()
	Parking:Init()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Parking:Update()
		Citizen.Wait(0)
	end
end)