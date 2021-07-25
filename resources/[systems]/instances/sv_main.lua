Instances = {
	players = {},
	rooms = {},
}

--[[ Functions ]]--
function Instances:Create(id)

end

function Instances:Destroy(id)

end

function Instances:Join(source, id)
	id = tonumber(id) or math.abs(GetHashKey(id))

	SetPlayerRoutingBucket(source, id)

	if id ~= 0 then
		SetRoutingBucketPopulationEnabled(id, false)
	end
	
	print("setting routing bucket", id)
end

function Instances:Leave(source)
	SetPlayerRoutingBucket(source, 0)
end

function Instances:Get(source)
	return self.players[source]
end

--[[ Exports ]]--
for k, v in pairs(Instances) do
	if type(v) == "function" then
		exports(k, function(...)
			return Instances[k](Instances, ...)
		end)
	end
end

--[[ Events ]]--
RegisterNetEvent("instances:join", function(id)
	local source = source
	if type(id) ~= "string" then return end
	Instances:Join(source, id)
end)

RegisterNetEvent("instances:leave", function()
	local source = source
	Instances:Leave(source)
end)

AddEventHandler("playerDropped", function()
	local source = source
	Instances:Leave(source)
end)