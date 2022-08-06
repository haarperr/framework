function GetWidth(size)
	return math.ceil(Config.Size.x / size)
end

function Round(number)
	if number % 1.0 >= 0.5 then
		return math.ceil(number)
	else
		return math.floor(number)
	end
end

function GetGrid(coords, size, keepSize)
	coords = vector3(math.min(math.max(coords.x + Config.Offset.x, 0), Config.Size.x), math.min(math.max(coords.y + Config.Offset.y, 0), Config.Size.y), coords.z)
	if not keepSize then
		size = Config.Sizes[size]
	end
	local width = GetWidth(size)
	return math.floor(coords.x / size) + math.floor(coords.y / size) * width
end
exports("GetGrid", GetGrid)

function GetPos(grid, size, keepSize)
	if not keepSize then
		size = Config.Sizes[size]
	end
	local width = GetWidth(size)
	return vector3(Round(grid % width) * size - Config.Offset.x, Round(grid / width) * size - Config.Offset.y, 0)
end
exports("GetPos", GetPos)

function GetNearbyGrids(coords, size, keepSize)
	if not size then return {} end
	if not keepSize then
		size = Config.Sizes[size]
	end

	local width = GetWidth(size)
	if type(coords) == "vector3" then
		coords = GetGrid(coords, size, true)
	end

	local grid = coords
	
	return {
		grid,
		grid - 1,
		grid + 1,
		grid - width,
		grid - width - 1,
		grid - width + 1,
		grid + width,
		grid + width - 1,
		grid + width + 1
	}
end
exports("GetNearbyGrids", GetNearbyGrids)