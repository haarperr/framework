Faction = {}
Faction.__index = Faction

function Faction:Create(name)
	if not name then
		error("creating faction without name")
	end

	self = setmetatable({
		name = name,
		groups = {},
	}, Faction)

	Main.factions[name] = self

	return self
end

function Faction:Destroy()
	Main.factions[self.name] = nil
end

function Faction:AddPlayer(source, characterId, groupName, level)
	groupName = groupName or ""
	level = level or 0

	-- Get player.
	local player = Main.players[source]
	if not player then return false end

	-- Get/create group.
	local group = self.groups[groupName]
	if not group then
		group = {}
		self.groups[groupName] = group
	end

	-- Check already in group.
	if group[source] then return false end

	-- Cache player.
	local playerFaction = player[self.name]
	if not playerFaction then
		playerFaction = {}
		player[self.name] = playerFaction
	end

	playerFaction[groupName] = level
	
	-- Cache group.
	group[source] = level

	return true
end

function Faction:RemovePlayer(source, characterId, groupName)
	groupName = groupName or ""

	-- Get player.
	local player = Main.players[source]
	if not player then return false end

	-- Get group.
	local group = self.groups[groupName]
	if not group then return false end

	-- Check player in group.
	if not group[source] then return false end

	-- Remove from player.
	local playerFaction = player[self.name]
	if playerFaction then
		playerFaction[groupName] = nil

		local next = next
		if next(playerFaction) == nil then
			player[self.name] = nil
		end
	end

	-- Remove from group.
	group[source] = nil

	-- Clear empty factions.
	local next = next
	if next(group) == nil then
		self.groups[groupName] = nil

		if next(self.groups) == nil then
			self:Destroy()
		end
	end

	return true
end