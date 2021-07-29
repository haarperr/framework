Decoration = {}
Decoration.__index = Decoration

function Decoration:Create(data)
	local instance = setmetatable(data, Decoration)
	return instance
end