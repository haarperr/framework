Groups = {}
Players = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local activePlayers = {}
		for groupId, group in pairs(Groups) do
			for player, info in pairs(group.players) do
				local coords = group.coords[player]
				if coords ~= nil then
					local cache = Players[player] or {}
					local blip = cache.blip
					if blip == nil or not DoesBlipExist(blip) then
						blip = AddBlipForCoord(coords.x, coords.y, coords.z)

						cache.blip = blip
						cache.group = groupId
						
						local tracker = Config.Trackers[groupId] or Config.Trackers["tracker"]
						local key, value
						
						if info[2] == "job" then
							local job, playerName = info[3], info[4]
							local jobInfo = exports.jobs:GetJob(job)

							key = "JobTracker"..tostring(playerName)
							value = "~c~"..tostring(jobInfo.Name).." -~s~ "..tostring(playerName)

							if jobInfo and jobInfo.Tracker then
								for k, v in pairs(jobInfo.Tracker) do
									tracker[k] = v
								end
							end
							
							if info[5] then
								tracker.Color = 49
							end

							tracker.Scale = 0.8
							tracker.Sprite = -1
							tracker.Crew = true
						elseif info[2] == "player" then
							local name = info[3]
							key = "PlayerTracker"..tostring(name)
							value = ("~y~Player - %s [%s]"):format(name, player)
						end
						
						SetBlipAlpha(blip, tracker.Alpha or 255)
						SetBlipAsFriendly(blip, tracker.Friendly or false)
						SetBlipAsShortRange(blip, tracker.ShortRange or false)
						SetBlipBright(blip, tracker.Bright or false)
						SetBlipCategory(blip, tracker.Category or 1)
						SetBlipColour(blip, tracker.Color or 0)
						SetBlipDisplay(blip, tracker.Display or 2)
						SetBlipFlashes(blip, tracker.Flashes or false)
						SetBlipFlashesAlternate(blip, tracker.FlashesAlternate or false)
						SetBlipFlashInterval(blip, tracker.FlashInterval or 0)
						SetBlipFlashTimer(blip, tracker.FlashTimer or 0)
						SetBlipHiddenOnLegend(blip, tracker.HiddenOnLegend or false)
						SetBlipHighDetail(blip, tracker.HighDetail or false)
						SetBlipPriority(blip, tracker.Priority or 10)
						SetBlipScale(blip, tracker.Scale or 1.0)
						SetBlipSecondaryColour(blip, GetHudColour(tracker.SecondaryColor or 3))
						SetBlipShowCone(blip, tracker.ShowCone or false)
						SetBlipShrink(blip, tracker.Shrink or false)
						SetBlipSprite(blip, tracker.Sprite or 1)
						ShowCrewIndicatorOnBlip(blip, tracker.Crew or false)

						if key and value then
							AddTextEntry(key, value)
							BeginTextCommandSetBlipName(key)
						end

						EndTextCommandSetBlipName(blip)
					else
						SetBlipCoords(blip, coords.x, coords.y, coords.z)
						if info[2] == "job" and info[5] ~= cache.lastStatus then
							RemoveBlip(blip)
							cache.lastStatus = info[5]
						end
					end
					Players[player] = cache
					activePlayers[player] = true
				end
			end
		end

		for player, cache in pairs(Players) do
			local blip = cache.blip
			if blip and not activePlayers[player] or (cache.group and not Groups[cache.group]) then
				if DoesBlipExist(blip) then
					RemoveBlip(blip)
				end
				Players[player] = nil
			end
		end

		Citizen.Wait(500)
	end
end)

--[[ Events ]]--
RegisterNetEvent("trackers:add")
AddEventHandler("trackers:add", function(groupId, player, info)
	if Groups[groupId] == nil then
		Groups[groupId] = { players = {}, coords = {} }
	end
	-- print("add player", groupId, player, json.encode(info))
	Groups[groupId].players[tostring(player)] = info
end)

RegisterNetEvent("trackers:remove")
AddEventHandler("trackers:remove", function(groupId, player)
	if Groups[groupId] == nil then
		return
	end
	-- print("remove", groupId, player)
	Groups[groupId].players[tostring(player)] = nil
	Groups[groupId].coords[tostring(player)] = nil
end)

RegisterNetEvent("trackers:join")
AddEventHandler("trackers:join", function(groupId, group)
	Groups[groupId] = group
end)

RegisterNetEvent("trackers:leave")
AddEventHandler("trackers:leave", function(groupId)
	-- print("leave", tostring(groupId))
	Groups[groupId] = nil
end)

RegisterNetEvent("trackers:updateCoords")
AddEventHandler("trackers:updateCoords", function(groupId, coords)
	if Groups[groupId] == nil then
		return
	end
	Groups[groupId].coords = coords
end)

RegisterNetEvent("trackers:update")
AddEventHandler("trackers:update", function(groupId, player, key, value)
	local group = Groups[groupId]
	if group == nil then return end
	
	local _player = group.players[tostring(player)]
	if _player == nil then return end
	
	_player[key] = value
end)