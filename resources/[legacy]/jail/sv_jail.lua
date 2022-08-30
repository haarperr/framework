Jailed = {}
AlarmTriggered = false

--[[ Threads ]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for player, jail in pairs(Jailed) do
			if jail then
				jail.time_left = math.floor((jail.end_time - os.time() * 1000)/1000)
				local characterId = exports.character:Get(player, "id")
				if not characterId then
					Jailed[player] = nil
					goto continue
				end

				exports.GHMattiMySQL:QueryAsync("UPDATE jail_active SET time_left=@time_left WHERE character_id=@character_id", {
					["@character_id"] = characterId,
					["@time_left"] = jail.time_left,
				})
				::continue::
			end
		end
	end
end)

--[[ Functions ]]--
function CanJail(source)
	if exports.jobs:IsInEmergency(source, "CanJail") then
		return true
	else
		TriggerClientEvent("chat:addMessage", source, "Invalid faction!")
		return false
	end
end
exports("CanJail", CanJail)

function Jail(source, target, minutes, _type)
	if not exports.character:GetCharacter(target) then return end

	if minutes < 0 then
		minutes = 2147483646
	end

	local time_left = minutes * 60

	local info = {
		["character_id"] = target,
		["sender_id"] = source,
		["type"] = _type,
		["start_time"] = os.time() * 1000,
		["end_time"] = os.time() * 1000 + minutes * 60000,
		["time_left"] = time_left
	}

	local targetId = exports.character:Get(target, "id")
	if not targetId then return end
	
	local sourceId = exports.character:Get(source, "id")
	if not sourceId then return end

	exports.GHMattiMySQL:QueryAsync("CALL jail_add(@target, @source, @minutes, @type, @time_left)", {
		["@target"] = targetId,
		["@source"] = sourceId,
		["@minutes"] = minutes,
		["@type"] = _type,
		["@time_left"] = time_left,
	})

	local skipSpawn = minutes >= 15 and exports.jobs:CountActiveDuty("Corrections") >= 2
	-- skipSpawn = true -- Debug.

	Jailed[target] = info
	TriggerClientEvent("jail:jailed", target, info, 0, skipSpawn)

	if skipSpawn then
		TriggerClientEvent("chat:addMessage", source, "They've been jailed, but need to be transported!", "emergency")
	end
end
exports("Jail", Jail)

function Unjail(source, keepPosition)
	local id = exports.character:Get(source, "id")
	if not id then return end

	exports.GHMattiMySQL:QueryAsync("UPDATE jail_active SET end_time=SYSDATE(),time_left=0 WHERE character_id=@character_id", {
		["@character_id"] = id
	})
	Jailed[source] = nil
	TriggerClientEvent("jail:leave", source, keepPosition)
end
exports("Unjail", Unjail)

function AddTime(source, minutes)
	local id = exports.character:Get(source, "id")
	if not id then return end
	
	local jail = Jailed[source]
	jail.end_time = jail.end_time + minutes * 60000
	local time_left = math.floor((jail.end_time - os.time() * 1000)/1000)

	exports.GHMattiMySQL:QueryAsync("UPDATE jail_active SET end_time=end_time + INTERVAL @minutes MINUTE, time_left=@time_left WHERE character_id=@character_id", {
		["@minutes"] = minutes,
		["@character_id"] = id,
		["@time_left"] = time_left,
	})

	TriggerClientEvent("jail:jailed", source, jail, os.time() * 1000 - jail.start_time, true)
end
exports("AddTime", AddTime)

--[[ Events ]]--
AddEventHandler("character:selected", function(source, character)
	if character then
		local jail = exports.GHMattiMySQL:QueryResult("SELECT * FROM jail_active WHERE character_id=@character_id LIMIT 1", {
			["@character_id"] = character.id
		})[1]

		local timeServed = 0

		if jail then
			--timeServed = os.time() * 1000 - jail.start_time
			if jail.time_left and jail.time_left > 0 then
				jail.end_time = (os.time() + jail.time_left) * 1000
				jail.start_time = os.time() * 1000

				exports.GHMattiMySQL:QueryAsync("UPDATE jail_active SET end_time=NOW() + INTERVAL @seconds SECOND WHERE character_id=@character_id", {
					["@character_id"] = character.id,
					["@seconds"] = jail.time_left,
				})
			end
		end

		Jailed[source] = jail
		TriggerClientEvent("jail:jailed", source, jail, timeServed)
		TriggerClientEvent("jail:setalarm", source, AlarmTriggered)
	end
end)

RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	local source = source
	Jailed[source] = nil
end)

AddEventHandler("playerDropped", function()
	local source = source
	Jailed[source] = nil
end)

RegisterNetEvent("interact:on_prison-alarm")
AddEventHandler("interact:on_prison-alarm", function()
	local source = source
	if not CanJail(source) then return end

	AlarmTriggered = not AlarmTriggered

	exports.log:Add({
		source = source,
		verb = "triggered",
		noun = "prison alarm",
		extra = ("state: %s"):format(AlarmTriggered),
	})

	TriggerClientEvent("jail:setalarm", -1, AlarmTriggered)
end)

RegisterNetEvent("jail:leave")
AddEventHandler("jail:leave", function(shouldUnjail)
	local source = source
	if not Jailed[source] then return end
	if shouldUnjail then
		Unjail(source, true)
		exports.log:Add({
			source = source,
			verb = "unjailed",
		})
	else
		Jailed[source] = nil
		exports.log:Add({
			source = source,
			verb = "left jail",
		})
	end
end)

RegisterNetEvent("jail:breakout")
AddEventHandler("jail:breakout", function()
	local source = source
	if not Jailed[source] then return end
	
	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped) then return end
	
	local presence = exports.jobs:CountActiveDuty("JailBreak")
	presence = 6

	if presence >= Config.Breakout.MinPresence then
		local name = exports.character:GetName(source)
		local license = exports.character:Get(source, "license_text")
		
		if not name or not license then return end
		local coords = GetEntityCoords(ped)

		exports.log:Add({
			source = source,
			verb = "broke out",
		})

		exports.dispatch:Add({
			coords = coords,
			group = "emergency",
			blip = { coords = coords },
			hasBlip = true,
			message = "10-98",
			messageType = 0,
			extra = ("%s - %s"):format(name, license),
		})
	end

	TriggerClientEvent("jail:breakout", source, presence)
end)

AddEventHandler("jail:start", function()
	if GetResourceState("cache") == "started" then
		Jailed = exports.cache:Get("Jailed") or {}
	end
end)

AddEventHandler("jail:stop", function()
	if GetResourceState("cache") == "started" then
		exports.cache:Set("Jailed", Jailed)
	end
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("jail", function(source, args, rawCommand)
	local target, minutes, _type = tonumber(args[1]), tonumber(args[2]), args[3]
	
	if not minutes or minutes < 0 then return end
	if not target or target <= 0 or not DoesEntityExist(GetPlayerPed(target)) then
		TriggerClientEvent("chat:addMessage", source, "Invalid target!")
		return
	end

	-- Check if already jailed.
	if Jailed[target] then return end

	-- Check if can jail.
	if not CanJail(source) then return end

	-- Types.
	if not _type then
		_type = "prison"
	elseif not Config.Types[_type] then
		return
	end

	exports.log:Add({
		source = source,
		target = target,
		verb = "jailed",
		extra = ("minutes: %s"):format(minutes),
	})

	Jail(source, target, minutes, _type)
end, {
	description = "Send somebody to (a) jail.",
	parameters = {
		{ name = "Target", description = "Who are you sending to jail?" },
		{ name = "Minutes", description = "How long they will be in jail, in minutes." },
		{ name = "Type", description = "What type of jail? Prison (default), parsons or cayo?" },
	}
}, -1)

exports.chat:RegisterCommand("jail:release", function(source, args, rawCommand)
	local target, keepPosition = tonumber(args[1]), args[2] ~= "true"
	
	if not target or target <= 0 or not DoesEntityExist(GetPlayerPed(target)) then
		TriggerClientEvent("chat:addMessage", source, "Invalid target!")
		return
	end

	-- Check if jailed.
	if not Jailed[target] then return end

	-- Check if can jail.
	if not CanJail(source) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "unjailed",
	})

	Unjail(target, keepPosition)
end, {
	description = "Free somebody from (a) jail.",
	parameters = {
		{ name = "Target", description = "Who are you sending to jail?" },
		{ name = "Teleport", description = "Teleport them to the front? [true/false]" },
	}
}, -1)

exports.chat:RegisterCommand("jail:checktime", function(source, args, rawCommand)
	local target = tonumber(args[1])
	
	if not target or target <= 0 or not DoesEntityExist(GetPlayerPed(target)) then
		TriggerClientEvent("chat:addMessage", source, "Invalid target!")
		return
	end

	-- Check if jailed.
	local jailed = Jailed[target]
	if not jailed then
		TriggerClientEvent("chat:addMessage", source, "They are not jailed!")
		return
	end
	
	-- Check if can jail.
	if not CanJail(source) then return end

	TriggerClientEvent("chat:addMessage", source, ("%s months left!"):format(math.ceil((jailed.end_time - os.time() * 1000) / 60000)))
end, {
	description = "Check somebody's time left in (a) jail.",
	parameters = {
		{ name = "Target", description = "Who's time are you checking?" },
	}
}, -1)

exports.chat:RegisterCommand("jail:addtime", function(source, args, rawCommand)
	local target, minutes = tonumber(args[1]), tonumber(args[2])
	
	if not minutes then return end
	if not target or target <= 0 or not DoesEntityExist(GetPlayerPed(target)) then
		TriggerClientEvent("chat:addMessage", source, "Invalid target!")
		return
	end

	-- Check if jailed.
	local jailed = Jailed[target]
	if not jailed then
		TriggerClientEvent("chat:addMessage", source, "They are not jailed!")
		return
	end
	
	-- Check if can jail.
	if not CanJail(source) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "added",
		noun = "time",
		extra = ("minutes: %s"):format(minutes),
	})

	AddTime(target, minutes)
	TriggerClientEvent("chat:addMessage", source, ("Modified sentance %s months!"):format(minutes))
end, {
	description = "Add time to someone's jail sentence.",
	parameters = {
		{ name = "Target", description = "Who's time are you changing?" },
		{ name = "Minutes", description = "How many minutes do you want to add (or subtract) to their time?" },
	}
}, -1)