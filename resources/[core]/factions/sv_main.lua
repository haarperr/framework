Main = {
	event = GetCurrentResourceName()..":",
	table = "factions",
	players = {},
	factions = {},
}

function Main:Init()
	-- Database.
	WaitForTable("characters")
	RunQuery("sql/factions.sql")

	-- Update players.
	for source in GetActivePlayers() do
		local characterId = exports.character:Get(source, "id")
		if characterId then
			self:LoadPlayer(source, characterId)
		end
	end

	-- Test.
	-- Citizen.SetTimeout(1000, function()
	-- 	print("JOIN", Main:JoinFaction(1, "test", "a"))
	-- 	print("JOIN", Main:JoinFaction(1, "test", "b"))
	-- 	print("JOIN", Main:JoinFaction(1, "test", "c"))

	-- 	print(json.encode(Main.players))
	-- 	print(json.encode(Main.factions))
	-- end)

	-- Citizen.SetTimeout(2000, function()
	-- 	print("LEAVE", Main:LeaveFaction(1, "test", "a"))

	-- 	print(json.encode(Main.players))
	-- 	print(json.encode(Main.factions))
	-- end)

	-- Citizen.SetTimeout(1500, function()
	-- 	print(self:Has(1, "test", "a"))
	-- end)
end

function Main:LoadPlayer(source, characterId)
	local factions = exports.GHMattiMySQL:QueryResult(([[
		SELECT
			`name`,
			`group`,
			`level`
		FROM %s
		WHERE `character_id`=@characterId
	]]):format(self.table), {
		["@characterId"] = characterId,
	})

	self.players[source] = {}

	for k, info in ipairs(factions) do
		local name = info.name
		if not name then return end

		local faction = self.factions[name]
		if not faction then
			faction = Faction:Create(name)
		end

		faction:AddPlayer(source, characterId, info.group, info.level)
	end

	TriggerClientEvent(self.event.."load", source, factions)
end

function Main:UnloadPlayer(source)
	local factions = self.players[source]
	if not factions then return end

	for name, _ in pairs(factions) do
		local faction = self.factions[name]
		if faction then
			faction:RemovePlayer(source)
		end
	end

	self.players[source] = nil
end

function Main:JoinFaction(source, name, group, level)
	if type(name) ~= "string" or (group ~= nil and type(group) ~= "string") then return false end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return false end

	local faction = self.factions[name]
	if not faction then
		faction = Faction:Create(name)
	end

	level = tonumber(level) or 0

	if faction:AddPlayer(source, characterId, group, level) then
		exports.GHMattiMySQL:QueryAsync(([[
			INSERT INTO %s
			SET
				`character_id`=@characterId,
				`name`=@name,
				`level`=@level,
				`group`=%s
		]]):format(
			self.table,
			group and group ~= "" and "@group" or "NULL"
		), {
			["@characterId"] = characterId,
			["@name"] = name,
			["@group"] = group,
			["@level"] = level or 0,
		})

		return true
	else
		return false
	end
end

function Main:LeaveFaction(source, name, group)
	if type(name) ~= "string" or (group ~= nil and type(group) ~= "string") then return false end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return false end

	local faction = self.factions[name]
	if not faction then return false end

	if faction:RemovePlayer(source, name, group) then
		exports.GHMattiMySQL:QueryAsync(([[
			DELETE FROM %s
			WHERE
				`character_id`=@characterId AND
				`name`=@name AND
				%s
		]]):format(
			self.table,
			group and group ~= "" and "`group`=@group" or "`group` IS NULL"
		), {
			["@characterId"] = characterId,
			["@name"] = name,
			["@group"] = group,
		})

		return true
	else
		return false
	end
end

function Main:Has(...)
	return self:Get(...) ~= nil
end

function Main:Get(source, name, groupName)
	groupName = groupName or ""

	local faction = self.factions[name]
	if not faction then return end

	local group = faction.groups[groupName]
	if not group then return end

	return group[source]
end

--[[ Exports ]]--
for k, v in pairs(Main) do
	if type(v) == "function" then
		exports(k, function(...)
			return Main[k](Main, ...)
		end)
	end
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Main:UnloadPlayer(source)
end)

AddEventHandler("character:selected", function(source, character, wasActive)
	if character then
		Main:LoadPlayer(source, character.id)
	else
		Main:UnloadPlayer(source)
	end
end)