Room = {}
Room.__index = Room

function Room:Create(id)
	local room = setmetatable({
		id = id,
		players = {},
	}, Room)

	return room
end

function Room:AddPlayer(source)
	if self.players[source] then return end

	self.players[source] = true
end

function Room:RemovePlayer(source)
	if not self.players[source] then return end

	self.players[source] = nil

	-- Cleanup room.
	local next = next
	if next(self.players) == nil then
		self:Destroy()
		return
	end

	-- Inform players.
end

function Room:Destroy()
	for source, _ in pairs(self.players) do
		
	end
end

function Room:InformAll(payload)
	for source, _ in pairs(self.players) do
		TriggerClientEvent("instances:inform", payload)
	end
end