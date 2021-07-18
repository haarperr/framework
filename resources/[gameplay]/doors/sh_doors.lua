Doors = Doors or {}
Doors.groups = {}
Doors.models = {}

--[[ Functions ]]--
function Doors:Initialize()
	-- Models.
	for model, info in pairs(Config.Doors) do
		local key
		if type(model) == "number" then
			key = model
		else
			key = GetHashKey(model)
		end

		if self.models[key] then
			print(("WARNING: Door model key collision: %s, %s and %s"):format(key, model, self.models[key]))
		else
			self.models[key] = model
		end
	end

	-- Groups.
	for k, group in ipairs(Groups) do
		group.id = "group-"..k

		self:RegisterGroup(group)
	end
end

function Doors:RegisterGroup(data)
	Debug("register group", data.id)

	if data.id == nil then return end

	-- Setup overrides.
	if data.overrides then
		local overrides = {}
		for _, override in ipairs(data.overrides) do
			local hash = GetCoordsHash(override.coords)
			local _override = {}
			for k, v in pairs(override) do
				if k ~= "coords" then
					_override[k] = v
				end
			end
			overrides[hash] = _override
		end
		data.overrides = overrides
	end

	-- Empty tables.
	data.players = {}
	data.doors = {}

	self.groups[data.id] = data
end

function Doors:GetModel(model)
	return Config.Models[self.models[model]]
end

function GetCoordsHash(coords)
	if type(coords) ~= "vector3" then return end
	
	local x = Round(coords.x * 3.0)
	local y = Round(coords.y * 3.0)
	local z = Round(coords.z * 3.0)

	return GetHashKey(x.." "..y.." "..z)
end

function Debug(...)
	if not Config.Debug then return end

	print(...)
end

function Round(val)
	if val % 1.0 > 0.5 then
		return math.ceil(val)
	else
		return math.floor(val)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	Doors:Initialize()
end)

--[[ Exports ]]--
exports("RegisterGroup", function(data)
	Doors:RegisterGroup(data)
end)

exports("GetGroupFromCoords", function(coords)
	for groupId, group in pairs(Doors.groups) do
		local dist = #(group.coords - coords)
		if dist < group.radius then
			return groupId
		end
	end
	return nil
end)

--[[ Commands ]]--
RegisterCommand("doors:debug", function(source, args, command)
	for k, v in pairs(Doors) do
		if type(v) == "table" then
			Citizen.Trace("\n"..k.."\n")
			for _k, _v in pairs(v) do
				Citizen.Trace(json.encode(_v).."\n")
			end
		end
	end
end, true)