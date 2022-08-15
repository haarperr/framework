Grids = {}
PlayerCache = {}

--[[ Events ]]--
RegisterNetEvent("scrapping:pickUp")
AddEventHandler("scrapping:pickUp", function(pos, index)
	local source = source
	if not pos then return end
	
	local grid = exports.grids:GetGrid(pos, Config.GridSize)
	if not grid then return end

	if not Grids[grid] then
		Grids[grid] = { viewers = {}, contents = {} }
	end

	table.insert(Grids[grid].contents, { index = index, pos = pos, time = os.time() })
	InformNearby(grid)
end)

RegisterNetEvent("scrapping:scrap")
AddEventHandler("scrapping:scrap", function(index)
	local source = source
	if not index then return end
	local prop = Config.Scrapping.Props[index]
	if not index then return end
	if not prop.Items then return end

	exports.log:Add({
		source = source,
		verb = "scrapped",
		extra = ("id: %s"):format(index),
		channel = "misc",
	})

	for k, item in ipairs(prop.Items) do
		math.randomseed(os.time() + k)
		exports.inventory:GiveItem(source, item[1], math.random(item[2], (item[3] or item[2]) + 1))
	end
end)

RegisterNetEvent("scrapping:subscribe")
AddEventHandler("scrapping:subscribe", function(grid)
	if type(grid) ~= "number" then return end
	local source = source
	local lastGrid = PlayerCache[source]

	if lastGrid and Grids[lastGrid] then
		for k, v in ipairs(Grids[lastGrid].viewers) do
			if v == source then
				table.remove(Grids[lastGrid].viewers, k)
				break
			end
		end
		CheckGrid(lastGrid)
	end

	if not Grids[grid] then
		Grids[grid] = { viewers = { source }, contents = {} }
	else
		table.insert(Grids[grid].viewers, source)
	end

	PlayerCache[source] = grid
	InformNearby(grid, source)
end)

--[[ Functions ]]--
function CheckGrid(grid)
	if not Grids[grid] then return end
	if #Grids[grid].viewers == 0 and #Grids[grid].contents == 0 then
		Grids[grid] = nil
	end
end

function InformNearby(grid, source)
	local gridData = Grids[grid]
	if not gridData then return end

	local nearbyGrids = exports.grids:GetNearbyGrids(grid, Config.GridSize)

	for _, nearbyGrid in ipairs(nearbyGrids) do
		local nearbyData = Grids[nearbyGrid]
		if nearbyData then
			if source then
				TriggerClientEvent("scrapping:receiveGrids", source, grid, gridData.contents)
			else
				for _, viewer in ipairs(nearbyData.viewers) do
					TriggerClientEvent("scrapping:receiveGrids", viewer, grid, gridData.contents)
				end
			end
		end
	end

	-- if type(grids) ~= "table" or #grids > 9 then return end
	-- local output = {}
	-- for k, grid in pairs(grids) then
	-- 	local data = Grids[grid]
	-- 	if data then
	-- 		output[#output + 1] = data
	-- 	end
	-- end
	-- return output
end