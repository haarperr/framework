Racing = {}

--[[ Functions ]]--
function LeaveRace(source, target, finish)
	local race = Racing[target]
	local isLeader = source == target
	
	if not race or (not isLeader and not race.players[source]) then return end

	local isEnding = isLeader and not finish

	if isEnding then
		exports.log:Add({
			source = source,
			verb = "ended",
			noun = "race",
			channel = "misc",
		})
	elseif finish then
		exports.log:Add({
			source = source,
			target = target,
			verb = "finished",
			noun = "race",
			channel = "misc",
		})

		race.winners = (race.winners or 0) + 1
		race.players[source] = false
	else
		exports.log:Add({
			source = source,
			target = target,
			verb = "left",
			noun = "race",
			channel = "misc",
		})

		race.players[source] = nil
	end

	local hasPlayers = false
	for player, inRace in pairs(race.players) do
		TriggerClientEvent("phone:finishedRace", player, source, isEnding, race.winners)

		if inRace and not isEnding then
			hasPlayers = true
		end
	end

	if not isLeader then
		Racing[source] = nil
	elseif not hasPlayers or isEnding then
		Racing[target] = nil
	end
end

--[[ Events ]]--
RegisterNetEvent("phone:startRace")
AddEventHandler("phone:startRace", function(data)
	local source = source
	
	-- Check if they already started a race.
	if Racing[source] then
		TriggerClientEvent("notify:sendAlert", source, "error", "You already started a race!", 8000)
		return
	end
	
	-- Check the data.
	if type(data) ~= "table" then
		print(("[%s] no table"):format(source))
		return
	end
	
	local dataCount = #data
	if dataCount < 2 or dataCount > 256 then
		print(("[%s] bad data count: %s"):format(source, dataCount))
		return
	end
	
	local laps = data[1]
	if type(laps) ~= "number" then
		print(("[%s] missing laps"):format(source))
		return
	end

	-- Setup the track.
	local track = { laps }

	for i = 2, dataCount do
		local position = data[i]
		if type(position) == "table" and type(position.x) == "number" and type(position.y) == "number" and type(position.z) == "number" then
			track[i] = vector3(position.x, position.y, position.z)
		else
			print(("[%s] invalid vector at: %s"):format(source, i))
			return
		end
	end

	local checkpointsCount = #track - 1
	local startCoords = track[2]

	exports.log:Add({
		source = source,
		verb = "started",
		noun = "race",
		extra = ("checkpoints: %s - laps: %s"):format(checkpointsCount, laps),
		channel = "misc",
	})

	-- Cache the track.
	local race = {
		players = {},
		started = false,
		track = track,
	}

	Racing[source] = race

	-- Inform players.
	TriggerClientEvent("phone:informRace", -1, source, startCoords)

	-- Create thread.
	Citizen.CreateThread(function()
		Citizen.Wait(math.floor(1000 * Races.JoinTime))

		local hasPlayers = false
		for player, inRace in pairs(race.players) do
			TriggerClientEvent("phone:startRace", player, track)
			if inRace then
				hasPlayers = true
			end
		end

		if hasPlayers then
			race.started = true
		else
			TriggerClientEvent("notify:sendAlert", source, "error", "Canceling race... Nobody joined!", 8000)
			Racing[source] = nil
		end
	end)
end)

RegisterNetEvent("phone:joinRace")
AddEventHandler("phone:joinRace", function(target)
	local source = source
	if Racing[source] and source ~= target then return end
	
	local race = Racing[target]
	if not race or race.players[source] then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "joined",
		noun = "race",
		channel = "misc",
	})

	race.players[source] = true

	if source ~= target then
		Racing[source] = target
	end
	
	for player, _ in pairs(race.players) do
		TriggerClientEvent("phone:joinedRace", player, source)
	end
end)

RegisterNetEvent("phone:leaveRace")
AddEventHandler("phone:leaveRace", function(target, finish)
	local source = source
	LeaveRace(source, target, finish)
end)