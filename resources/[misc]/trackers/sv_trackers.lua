Groups = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for groupId, group in pairs(Groups) do
			for player, info in pairs(group.players) do
				-- Update the player in the group.
				UpdateInfo(groupId, player)

				-- Send the group to the player.
				if not info[1] then
					TriggerClientEvent("trackers:updateCoords", tonumber(player), groupId, group.coords)
				end
			end
		end
		Citizen.Wait(500)
	end
end)

--[[ Functions ]]--
function Set(source, groupId, key, value)
	local group = Groups[groupId]
	if group == nil then
		return
	end

	local _player = group.players[tostring(source)]
	if _player == nil then
		return
	end

	-- Remove the player.
	_player[key] = value

	-- Inform the group of the removal.
	for player, info in pairs(group.players) do
		if not info[1] then
			TriggerClientEvent("trackers:update", tonumber(player), groupId, source, key, value)
		end
	end
end
exports("Set", Set)

function AddToGroup(source, groupId, hidden, ...)
	-- Create the group as needed.
	local group = Groups[groupId]
	local wasHidden = false
	if group == nil then
		group = { players = {}, coords = {} }
		Groups[groupId] = group
	else
		wasHidden = group.players[source] and group.players[source][1]
	end

	info = { hidden or false, ... }
	
	-- Inform the group of the addition.
	for player, _info in pairs(group.players) do
		if not _info[1] then
			TriggerClientEvent("trackers:add", tonumber(player), groupId, source, info)
		end
	end

	-- Add the player to the group.
	group.players[tostring(source)] = info
	
	if hidden then
		if not wasHidden then
			TriggerClientEvent("trackers:leave", source, groupId)
		end
	else
		TriggerClientEvent("trackers:join", source, groupId, group)
	end
end
exports("AddToGroup", AddToGroup)

function RemoveFromGroup(source, groupId)
	local group = Groups[groupId]
	if group == nil then
		return
	end

	-- Remove the player.
	group.players[tostring(source)] = nil
	group.coords[tostring(source)] = nil

	-- Inform the group of the removal.
	for player, info in pairs(group.players) do
		if not info[1] then
			TriggerClientEvent("trackers:remove", tonumber(player), groupId, source)
		end
	end
	TriggerClientEvent("trackers:leave", source, groupId)
end
exports("RemoveFromGroup", RemoveFromGroup)

function IsInGroup(source, groupId)
	if Groups[groupId] == nil then
		return false
	end
	return Groups[groupId].players[tostring(source)] ~= nil
end
exports("IsInGroup", IsInGroup)

function UpdateInfo(groupId, source)
	local group = Groups[groupId]
	if group == nil then
		return
	end
	local ped = GetPlayerPed(source)

	if DoesEntityExist(ped) then
		group.coords[tostring(source)] = GetEntityCoords(ped)
	end
end

--[[ Events ]]--
AddEventHandler("playerDropped", function(reason)
	local source = source
	for groupId, group in pairs(Groups) do
		if group.players[tostring(source)] then
			RemoveFromGroup(source, groupId)
		end
	end
end)

-- Test.
-- Citizen.CreateThread(function()
-- 	for i = 0, GetNumPlayerIndices() - 1 do
-- 		local player = GetPlayerFromIndex(i)
-- 		AddToGroup(tonumber(player), "tracker")
-- 	end
-- end)