Voip.clients = {}
Voip.channels = {}

--[[ Functions: Voip ]]
function Voip:Init()
	-- Update convars.
	for name, value in pairs(Config.Convars) do
		SetConvarReplicated(name, value)
	end
end

--[[ Events ]]--
AddEventHandler("voip:start", function()
	Voip:Init()
end)

AddEventHandler("playerEnteredScope", function(data)
	local source = tonumber(data["player"])
	local target = tonumber(data["for"])

	if not source or not target then return end

	TriggerClientEvent("voip:addToScope", source, target)
end)

AddEventHandler("playerLeftScope", function(data)
	local source = tonumber(data["player"])
	local target = tonumber(data["for"])

	if not source or not target then return end

	TriggerClientEvent("voip:removeFromScope", source, target)
end)

--[[ Events: Net ]]--
RegisterNetEvent("voip:init", function()
	local source = source

	-- Check registered.
	if Voip.clients[source] then return end

	-- Register client.
	Client:Create(source)

	-- Inform client.
	TriggerClientEvent("voip:init", source)
end)

RegisterNetEvent("voip:joinChannel", function(id, _type)
	local source = source

	id = tostring(id)

	-- Check type.
	local __type = Config.Types[_type or false]
	if not __type then return end

	-- Get client.
	local client = Voip.clients[source]
	if not client then return end

	-- Join channel.
	if client:JoinChannel(id, __type) then
		exports.log:Add({
			source = source,
			verb = "joined",
			noun = "channel",
			extra = ("id: %s, type as: %s"):format(id, _type),
		})
	end
end)

RegisterNetEvent("voip:setTalking", function(value, filter)
	local source = source

	-- Check value.
	if type(value) ~= "boolean" then return end

	-- Check filter.
	if filter and type(filter) ~= "table" then return end

	-- Get client.
	local client = Voip.clients[source]
	if not client then return end

	-- Set client talking.
	client:SetTalking(value, filter)
end)

RegisterNetEvent("voip:leaveChannel", function(id)
	local source = source

	id = tostring(id)

	-- Get client.
	local client = Voip.clients[source]
	if not client then return end

	-- Join channel.
	if client:LeaveChannel(id) then
		exports.log:Add({
			source = source,
			verb = "left",
			noun = "channel",
			extra = id,
		})
	end
end)