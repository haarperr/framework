Doors = Doors or {}
Doors.players = {}

--[[ Functions ]]--
function Doors:Register()

end

function Doors:SetState(groupId, hash, state)
	local group = self.groups[groupId]
	if not group then return end

	if state == nil then
		state = not group.doors[hash]
	end

	group.doors[hash] = { state = state, update = os.clock() }

	self:Inform(groupId, hash)
end

function Doors:GetPlayer(source, create)
	-- Get player.
	local player = self.players[source]

	-- Return player.
	if player then
		return player
	elseif not create then
		return
	end

	-- Create player.
	Debug("create player", source)

	player = {
		lastToggle = 0.0,
	}

	-- Cache player.
	self.players[source] = player
	
	-- Return player.
	return player
end

function Doors:Toggle(source, hash, state)
	Debug("toggle", source, hash, state)

	-- Get player.
	local player = self:GetPlayer(source)
	if not player then return end

	-- Check cooldown.
	if os.clock() - player.lastToggle < Config.Locking.Anim.Duration / 1000.0 then
		return
	end
	
	player.lastToggle = os.clock()

	-- Get group.
	local groupId = player.group
	if not groupId then return end

	local group = self.groups[groupId]
	if not group then return end

	-- Log the event.
	exports.log:Add({
		source = source,
		verb = "toggled",
		noun = "lock",
		extra = hash,
	})

	-- Toggle the door.
	self:SetState(groupId, hash, state)
end

function Doors:Subscribe(source, id)
	Debug("subscribe", source, id)

	local player = self:GetPlayer(source, true)

	-- Unregister old group.
	if player.group then
		self.groups[player.group].players[source] = nil
		player.group = nil
	end

	-- Register to group.
	if not id then return end

	local group = self.groups[id]
	if not group then return end

	player.group = id
	group.players[source] = true

	self:Inform(id, false, source)
end

function Doors:Inform(groupId, hash, source)
	local group = self.groups[groupId]
	if not group then return end

	local doors
	if hash then
		doors = { [hash] = group.doors[hash] or { state = false, update = os.clock() } }
	else
		doors = group.doors
	end

	if source then
		TriggerClientEvent("doors:inform", source, doors)
	else
		for player, _ in pairs(group.players) do
			TriggerClientEvent("doors:inform", player, doors)
		end
	end
end

--[[ Exports ]]--
exports("SetState", function(groupId, coords, state)
	local hash = GetCoordsHash(coords)
	
	Doors:SetState(groupId, hash, state)
end)

--[[ Events ]]--
RegisterNetEvent("doors:toggle")
AddEventHandler("doors:toggle", function(hash, state, item)
	local source = source

	if type(hash) ~= "number" then return end
	if type(state) ~= "boolean" and type(state) ~= "number" then return end

	if type(item) == "string" and not exports.inventory:TakeItem(source, item, 1) then
		return
	end

	Doors:Toggle(source, hash, state)
end)

RegisterNetEvent("doors:subscribe")
AddEventHandler("doors:subscribe", function(groupId)
	local source = source
	
	if groupId ~= nil and type(groupId) ~= "string" then return end

	Doors:Subscribe(source, groupId)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	if Doors.players[source] then
		Doors:Subscribe(source)
		Doors.players[source] = nil
	end
end)