Cooldowns = {}
Players = {}
Times = {}
UpdatedZones = {}
Zones = {}
Totals = nil
LastTotal = 0

--[[ Functions ]]--
function Initialize()
	local startTime = os.clock()

	-- Create the table if necessary.
	exports.GHMattiMySQL:Query([[
		CREATE TABLE IF NOT EXISTS `territories` (
			`zone` VARCHAR(16) NOT NULL COLLATE 'utf8_general_ci',
			`factions` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
			PRIMARY KEY (`zone`) USING BTREE,
			UNIQUE INDEX `terrirtories_zone_UQ` (`zone`) USING BTREE
		)
		COLLATE='utf8_general_ci'
		ENGINE=InnoDB
		;
	]])

	-- Create the territories.
	local transactions = {}
	local count = 0

	for zone, settings in pairs(Config.Zones) do
		if not settings.Fallback then
			count = count + 1
			transactions[#transactions + 1] = "INSERT IGNORE INTO `territories` SET `zone`='"..zone.."'"
		end
	end

	exports.GHMattiMySQL:Transaction(transactions)

	-- Load the territories.
	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `territories`")

	for k, row in ipairs(result) do
		local value
		if row.factions then
			value = json.decode(row.factions)
		else
			value = {}
		end
		Zones[row.zone] = value
	end

	-- Create instances.
	for _, location in ipairs(Config.Labs.Locations) do
		local typeSettings = Config.Labs.Types[location.Type]
		exports.instances:CreateInstance(location.Instance, {
			outCoords = location.Coords,
			inCoords = typeSettings.Coords,
		})
	end

	for _, instance in ipairs(Config.Instances) do
		exports.instances:CreateInstance(instance.id, instance)
	end

	-- Finish.
	print("[TERRITORIES] Loaded "..count.." territories in "..math.floor((os.clock() - startTime) * 1000).." milliseconds...")
end

function GetPlayer(source)
	return Players[source]
end

function GiveReputation(source, amount)
	local faction, name = GetGangFaction(source)
	if not name then return end

	local zoneId = GetPrimary(name)
	if not zoneId then return end

	AddReputation(zoneId, name, amount)
end
exports("GiveReputation", GiveReputation)

function AddReputation(zoneId, faction, amount)
	if faction == "" then return end

	local zone = Zones[zoneId]
	if not zone then return end

	if amount > 0.0 then
		-- Check current ownership.
		for _zoneId, factions in pairs(Zones) do
			if _zoneId ~= zoneId then
				local reputation = factions[faction]
				if reputation and reputation >= 0.2 then
					-- print("territory already owned", faction, zoneId, _zoneId)
					return
				end
			end
		end
	end

	local value = zone[faction] or 0.0
	value = math.min(math.max(value + amount, -100.0), 100.0)

	SetReputation(zoneId, faction, value)
end
exports("AddReputation", AddReputation)

function SetReputation(zoneId, faction, value)
	local zone = Zones[zoneId]
	if not zone then return end

	if type(value) ~= "number" then
		error("Reputation value must be a number!")
	end

	if math.abs(value) < 0.001 then
		value = nil
	end

	-- local oldValue = Zones[zoneId][faction] or 0.0

	-- print(("%s's Reputation: %s += %s (%s)"):format(faction, value - oldValue, value, zoneId))
	
	Zones[zoneId][faction] = value
	UpdatedZones[zoneId] = true
end
exports("SetReputation", SetReputation)

function SetPrimary(faction, zoneId)
	for _zoneId, factions in pairs(Zones) do
		local reputation = factions[faction]
		if not reputation or reputation > 0.0 then
			if zoneId == _zoneId then
				-- Set new reputation.
				reputation = 1.0
			else
				-- Reset old reputation.
				reputation = 0.0
			end
			SetReputation(_zoneId, faction, reputation)
		end
	end
end

function GetPrimary(faction)
	for zoneId, factions in pairs(Zones) do
		local reputation = factions[faction]
		if reputation and reputation > 0.0 then
			return zoneId
		end
	end
end

function Save(zoneId)
	local zone = Zones[zoneId]
	if not zone then return end
	
	-- print("saving", zoneId)
	
	exports.GHMattiMySQL:QueryAsync("UPDATE `territories` SET factions=@factions WHERE zone=@zone", {
		["@factions"] = json.encode(zone),
		["@zone"] = zoneId
	})
end

function GetCurrentZoneId(source)
	local player = GetPlayer(source)
	if not player then return end
	
	return player.zone
end
exports("GetCurrentZoneId", GetCurrentZoneId)

function GetControl(zoneId)
	local zone = Zones[zoneId]
	if not zone then return end

	local highestFaction, highestAmount = nil, 0.0
	local totals = GetTotals()

	for faction, value in pairs(zone) do
		if value > 0.2 and totals[faction] > Config.Reputation.Infamy and (not highestFaction or value > highestAmount) then
			highestAmount = value
			highestFaction = faction
		end
	end

	return highestFaction
end
exports("GetControl", GetControl)

function HasControl(source, zoneId)
	local player = GetPlayer(source)
	if not player then return false end

	return player.faction == GetControl(zoneId)
end
exports("HasControl", HasControl)

function HasControlOverCurrentZone(source)
	return HasControl(source, GetCurrentZoneId(source))
end
exports("HasControlOverCurrentZone", HasControlOverCurrentZone)

function GetPrimaryControl(name)
	local faction
	if type(name) == "number" then
		faction, name = GetGangFaction(name)
	end

	if not name then return end

	for zoneId, factions in pairs(Zones) do
		if GetControl(zoneId) == name then
			return zoneId
		end
	end
end
exports("GetPrimaryControl", GetPrimaryControl)

function GetTotals()
	if os.clock() - LastTotal < 5.0 and Totals then
		return Totals
	end
	local totals = {}
	for zoneId, factions in pairs(Zones) do
		for faction, value in pairs(factions) do
			totals[faction] = (totals[faction] or 0.0) + value
		end
	end
	LastTotal = os.clock()
	Totals = totals
	return totals
end
exports("GetTotals", GetTotals)

--[[ Events ]]--
AddEventHandler("territories:start", function()
	Initialize()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	if not source then return end

	Players[source] = nil
end)

AddEventHandler("drugs:sold", function(source, drug, amount, price)
	local player = Players[source]
	if not player then return end

	local zoneSettings = Config.Zones[player.zone]
	if zoneSettings.Type == "Community" then return end

	-- TODO: change.
	-- AddReputation(player.zone, player.faction, amount * 0.001)
end)

RegisterNetEvent("territories:update")
AddEventHandler("territories:update", function(zoneId, data)
	local source = source

	-- Type check.
	if type(zoneId) ~= "string" then return end

	-- Get ped.
	local ped = GetPlayerPed(source)
	if not ped or not DoesEntityExist(ped) then return end

	-- Cache player.
	local player = Players[source]
	if not player then
		player = {}
		Players[source] = player
	end

	-- Get faction.
	local faction, name = GetGangFaction(source)
	
	-- Set faction.
	player.faction = name

	-- Find zone.
	local zoneSettings = Config.Zones[zoneId]
	if zoneSettings then
		if zoneSettings.Fallback then
			player.zone = zoneSettings.Fallback
		else
			player.zone = zoneId
		end
	else
		Players[source] = nil
		return
	end

	-- Weapon settings.
	if data == nil then
		data = {}
	end

	player.aiming = data.aiming == true
	player.shooting = data.shooting == true
	player.weaponGroup = tonumber(data.weaponGroup)
end)

RegisterNetEvent("territories:register")
AddEventHandler("territories:register", function(name)
	local source = source
	
	if type(name) ~= "string" then return end
	if IsInGang(source) then return end

	local isNameValid, name = CheckName(name)
	if not isNameValid then return end

	local doesGangExist = exports.GHMattiMySQL:QueryScalar("SELECT 1 FROM factions WHERE `name`='gang' AND JSON_VALUE(`extra`, '$.name')=@name", {
		["@name"] = name
	})

	if doesGangExist == 1 then
		TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
			{ "GotoStage", "REGISTER_FINISH" },
			{ "InvokeDialogue" },
			{ "Say", "Somebody is already using that name." },
		})
		return
	end

	local playerContainer = exports.inventory:GetPlayerContainer(source)
	if not playerContainer then return end

	for item, amount in pairs(Config.Quests.Register.Items) do
		if exports.inventory:CountItem(playerContainer, item) < amount then
			return
		end
	end

	exports.log:Add({
		source = source,
		verb = "registered",
		extra = name,
	})

	exports.inventory:TakeItem(source, "Voucher", 1)
	
	exports.character:JoinFaction(source, "gang", { name = name })
	exports.character:UpdateFaction(source, "gang", { level = 100 })

	TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
		{ "GotoStage", "INIT" },
		{ "InvokeDialogue" },
		{ "Say", "I'll make sure you're known as "..name.."." },
	})
end)

RegisterNetEvent("territories:invite")
AddEventHandler("territories:invite", function(target)
	local source = source
	
	if type(target) ~= "number" or target <= 0 or GetPlayerEndpoint(target) == nil then return end
	if IsInGang(target) then return end

	local faction = GetGangFaction(source)
	if not faction or faction.level < 100 then return end

	local name = (faction.extra or {}).name
	if not name then return end

	TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
		{ "GotoStage", "INIT" },
		{ "InvokeDialogue" },
		{ "Say", "I'll see what they think." },
	})

	exports.interaction:SendConfirm(source, target, "You are being invited to join "..name, function(response)
		if not response then return end

		exports.log:Add({
			source = source,
			target = target,
			verb = "added",
			extra = name,
		})
		
		exports.character:JoinFaction(target, "gang", { name = name })

		TriggerClientEvent("notify:sendAlert", target, "inform", "You've joined "..name..".", 8000)
		TriggerClientEvent("notify:sendAlert", source, "inform", "Added ["..tostring(target).."] to "..name..".", 8000)
	end)
end)

RegisterNetEvent("territories:kick")
AddEventHandler("territories:kick", function(targetId)
	local source = source

	if type(targetId) ~= "number" then return end
	local sourceId = exports.character:Get(source, "id")
	if not sourceId or sourceId == targetId then return end

	local faction = GetGangFaction(source)
	if not faction or faction.level < 100 then return end

	local name = (faction.extra or {}).name
	if not name then return end

	local target = exports.character:GetCharacterById(targetId)
	local result
	if target then
		local targetFaction = GetGangFaction(target)
		if not targetFaction then return end

		local targetName = (targetFaction.extra or {}).name
		if not targetName or name ~= targetName then return end

		exports.character:LeaveFaction(target, "gang")

		result = 1
	else
		result = exports.GHMattiMySQL:QueryScalar([[
			DELETE FROM `factions` WHERE `character_id`=@targetId AND `name`='gang' AND JSON_VALUE(`extra`, '$.name')=@name;
			SELECT ROW_COUNT();
		]], {
			["@name"] = name,
			["@targetId"] = targetId,
		})
	end
	
	if result == 1 then
		exports.log:Add({
			source = source,
			verb = "kicked",
			extra = ("%s - character id: %s"):format(name, targetId),
		})
		
		TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
			{ "Say", "Consider ("..tostring(targetId)..") gone." },
			{ "GotoStage", "REMOVE_MEMBER" }
		})
	else
		TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
			{ "Say", "I don't know who they are..." },
			{ "GotoStage", "REMOVE_MEMBER" },
		})
	end
end)

RegisterNetEvent("territories:leave")
AddEventHandler("territories:leave", function()
	local source = source
	
	if not IsInGang(source) then return end
	local faction = GetGangFaction(source)
	if not faction then return end

	if faction.level >= 100 then
		local name = (faction.extra or {}).name
		if not name then return end

		exports.log:Add({
			source = source,
			verb = "disbanded",
			extra = name,
		})
		
		local result = exports.GHMattiMySQL:QueryResult([[
			SELECT `character_id`
			FROM `factions`
			WHERE `name`='gang' AND JSON_VALUE(`extra`, '$.name')=@name
		]], {
			["@name"] = name
		})
			
		for k, v in ipairs(result) do
			local target = exports.character:GetCharacterById(v.character_id)
			if target and DoesEntityExist(GetPlayerPed(target)) then
				exports.character:LeaveFaction(target, "gang")
			else
				exports.GHMattiMySQL:QueryAsync("DELETE FROM `factions` WHERE `character_id`=@targetId AND `name`='gang'", {
					["@targetId"] = v.character_id
				})
			end
		end

		TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
			{ "GotoStage", "INIT" },
			{ "InvokeDialogue" },
			{ "Say", "Consider yourselves disbanded." },
		})

		return
	end

	exports.log:Add({
		source = source,
		verb = "left",
		extra = name,
	})
	
	exports.character:LeaveFaction(source, "gang")

	TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
		{ "GotoStage", "INIT" },
		{ "InvokeDialogue" },
		{ "Say", "Consider yourself out." },
	})
end)

RegisterNetEvent("territories:changePrimary")
AddEventHandler("territories:changePrimary", function(zoneId)
	local source = source

	if Cooldowns[source] and os.clock() < Cooldowns[source] then
		TriggerClientEvent("npcs:invoke", source, "TERRITORY", "Say", "Slow down there, buddy.")
		return
	else
		Cooldowns[source] = os.clock() + 30.0
	end

	local zone = Zones[zoneId]
	if not zone then return end

	local faction = GetGangFaction(source)
	if not faction or faction.level < 100 then return end

	local name = (faction.extra or {}).name
	if not name then return end

	SetPrimary(name, zoneId)

	TriggerClientEvent("npcs:invoke", source, "TERRITORY", {
		{ "GotoStage", "INIT" },
		{ "InvokeDialogue" },
		{ "Say", "I'll spread the word." },
	})
end)

RegisterNetEvent("territories:requestStatus")
AddEventHandler("territories:requestStatus", function(input)
	local source = source

	local faction, name = GetGangFaction(source)
	if not name then return end

	local data = nil

	if input == "infamy" then
		local totals = GetTotals()
		data = {}
		for faction, total in pairs(totals) do
			if total < Config.Reputation.Infamy then
				data[faction] = total
			end
		end
	elseif input == "dailies" then
		local characterId = exports.character:Get(source, "id")
		if not characterId then return end

		data = {
			faction = Dailies:GetFaction(name),
			character = Dailies:GetCharacter(characterId),
		}

		if (data.faction == nil or data.faction < 4) and data.character == nil then
			data.character = Dailies:Random()

			local characters = Dailies.characters
			if not characters then
				characters = {}
				Dailies.characters = characters
			end
			characters[characterId] = data.character
		end
	elseif type(input) == "string" then
		local zone = Zones[input]
		if not zone then return end
		
		data = { id = input, zone = zone }
	else
		data = { faction = name }

		if faction.level >= 100 then
			data.members = exports.GHMattiMySQL:QueryResult([[
				SELECT
					`character_id`,
					(
						SELECT CONCAT(first_name, ' ', last_name)
						FROM `characters`
						WHERE `id`=`character_id`
					) AS `name`
				FROM `factions`
				WHERE `name`='gang' AND JSON_VALUE(`extra`, '$.name')=@name
			]], {
				["@name"] = name
			})
		end
	end

	TriggerClientEvent("territories:receiveStatus", source, data)
end)

RegisterNetEvent("territories:startDaily")
AddEventHandler("territories:startDaily", function()
	local source = source

	-- Get the gang faction/name.
	local faction, name = GetGangFaction(source)
	if not name then return end

	-- Get the character id.
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	-- Get the daily.
	local dailyFaction = Dailies:GetFaction(name) or 0
	local dailyCharacter = Dailies:GetCharacter(characterId)

	-- Check the daily.
	if dailyCharacter == nil or dailyFaction >= 4 then return end

	-- Get the quest.
	local quest = exports.quests:Get((Quests[dailyCharacter] or {}).id)
	if not quest then return end
	
	-- Check the quest.
	local hasQuest = quest:Has(source)
	if hasQuest then return end

	-- Start the quest.
	quest:Start(source)

	-- Increment the faction's daily.
	dailyFaction = dailyFaction + 1

	if not Dailies.factions then Dailies.factions = {} end
	Dailies.factions[name] = dailyFaction

	TriggerClientEvent("npcs:invoke", source, "TERRITORY_JEROME", {
		{ "GotoStage", "INIT" },
		{ "InvokeDialogue" },
		{ "Say", "Good luck." },
	})
end)

local tempRevived = {}

RegisterNetEvent("territories:revive")
AddEventHandler("territories:revive", function(target, site)
	local source = source

	if tempRevived[source] then
		exports.sv_test:Report(source, "mass revival spam", true)
		
		return
	end

	if type(site) ~= "number" then return end
	
	local price = 500
	if target then
		price = 750
	end

	if not exports.inventory:CanAfford(source, price, 0, false) then
		return
	end

	if target then
		exports.log:Add({
			source = source,
			target = target,
			verb = "checked in",
		})
	else
		exports.log:Add({
			source = source,
			target = target,
			verb = "healed",
		})
	end

	exports.inventory:TakeBills(source, price, 0, false)

	TriggerClientEvent("territories:revive", target or source, site)
	
	Citizen.CreateThread(function()
		tempRevived[source] = true

		Citizen.Wait(1000)

		tempRevived[source] = nil
	end)
end)