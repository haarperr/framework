local Handle = -1
local Cache = {}
local MeParts = {
	["pelvis"] = 0x2E28,
	["lthigh"] = 0xE39F,
	["lcalf"] = 0xF9BB,
	["lfoot"] = 0x3779,
	["rthigh"] = 0xCA72,
	["rcalf"] = 0x9000,
	["rfoot"] = 0xCC4D,
	["spine0"] = 0x5C01,
	["spine1"] = 0x60F0,
	["spine2"] = 0x60F1,
	["spine3"] = 0x60F2,
	["lclavicle"] = 0xFCD9,
	["lupperarm"] = 0xB1C5,
	["lforearm"] = 0xEEEB,
	["lhand"] = 0x49D9,
	["rclavicle"] = 0x29D2,
	["rupperarm"] = 0x9D4D,
	["rforearm"] = 0x6E5C,
	["rhand"] = 0xDEAD,
	["neck"] = 0x9995,
	["head"] = 0x796E,
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local selfCoords = GetEntityCoords(PlayerPedId())
		for serverId, messages in pairs(Cache) do
			local player = GetPlayerFromServerId(serverId)
			if player == -1 or not NetworkIsPlayerActive(player) then goto skipPlayer end

			local ped = GetPlayerPed(player)
			if not DoesEntityExist(ped) then goto skipPlayer end

			local messageCache = {}
			local coords = GetEntityCoords(ped)
			local dist = #(coords - selfCoords)
			
			if dist > 20.0 then
				goto skipPlayer
			end
			
			for k, message in pairs(messages) do
				if dist > 5 * (message.range or 3) then
					goto skipMessage
				end
				if message.coords then
					coords = message.coords
				elseif message.bone then
					coords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, message.bone))
				end
				messageCache[message.bone or 0] = (messageCache[message.bone or 0] or 0) + 1
				
				local yPos = 0.03 * (messageCache[message.bone or 0] - 1)
				exports.oldutils:Draw3DText(coords, message.text, 4, 0.4, 1, 1, vector2(0.0, yPos))
				if GetGameTimer() > message.time then
					messages[k] = nil
				end
				::skipMessage::
			end
			::skipPlayer::
		end
	end
end)

--[[ Function ]]--
function _AddMessage(player, message, bone, timeOffset, range)
	local coords = nil

	if type(player) == "vector3" then
		coords = player
		player = Handle
	end

	local cache = Cache[player]
	
	if not cache then
		cache = {}
		Cache[player] = cache
	end

	message = { text = message, bone = bone, time = GetGameTimer() + 10000 + (timeOffset or 0.0), coords = coords, range = range }

	if not cache then
		cache = { message }
		Cache[player] = cache
	else
		cache[#cache + 1] = message
	end
end

function AddMessage(player, message, timeOffset, range)
	if type(player) == "vector3" then
		Handle = Handle - 1
	end

	local bodyPart
	local firstSpace = message:find(" ")
	if firstSpace then
		bodyPart = MeParts[message:sub(1, firstSpace - 1):lower()]
		if bodyPart then
			message = message:sub(firstSpace)
		end
	end
	
	local rawMessage = message
	local lineLength = 0
	local lines = 1
	message = ""
	for i = 1, rawMessage:len() do
		local char = rawMessage:sub(i, i)
		if lineLength > 48 and char == " " then
			_AddMessage(player, message, bodyPart, rawMessage:len() * 50 + (timeOffset or 0), range)
			message = ""
			lines = lines + 1
			lineLength = 0
		end
		message = message..char
		lineLength = lineLength + 1
	end
	if message:gsub("%s+", "") ~= "" then
		_AddMessage(player, message, bodyPart, rawMessage:len() * 50 + (timeOffset or 0), range)
	end

	return Handle
end
exports("AddMessage", AddMessage)

function RemoveMessage(handle)
	Cache[handle] = nil
end
exports("RemoveMessage", RemoveMessage)

--[[ Events ]]--
RegisterNetEvent("interaction:me")
AddEventHandler("interaction:me", function(player, message, range)
	AddMessage(player, message, 0, range)
end)

--[[ Commands ]]--
RegisterCommand("me", function(source, args, rawCommand)
	local text = rawCommand:sub(4)
	if not text then return end

	TriggerServerEvent("interaction:me", text, exports.voip:GetVoiceRange())
end)
