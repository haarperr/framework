local Calls = {}
local Channels = {}
local PlayerChannels = {}

--[[ Functions ]]--
function Call(source, target)
	if Calls[source] or Calls[target] then
		SendPayload(source, "phone-call", {
			target = "phone-call",
			hangup = true,
		}, true)
		
		return
	end

	local sourceCharacterId = exports.character:Get(source, "id")
	if sourceCharacterId == nil then return end

	local targetCharacterId = exports.character:Get(target, "id")
	if targetCharacterId == nil then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "called",
		extra = ("source: %s - target: %s"):format(sourceCharacterId, targetCharacterId),
	})

	Calls[source] = target
	Calls[target] = source

	local contacts = exports.character:Get(target, "phone_contacts") or {}
	local number = PhoneCache.Players[source]
	local contactName = contacts[number] or "Unknown Number"

	SendPayload(target, "phone-call", {
		state = "Incoming Call",
		number = PhoneCache.Players[source],
		name = contactName,
	}, true)
end

function Answer(source, target)
	local number = PhoneCache.Players[source]
	if not number then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "answered",
	})

	TriggerClientEvent("phone:answer", source, PhoneCache.Players[target], number)
	TriggerClientEvent("phone:answer", target, number)

	PlayerChannels[source] = number
	PlayerChannels[target] = number
	Channels[number] = true
end

function HangUp(source, target)
	TriggerClientEvent("phone:hangup", source)
	TriggerClientEvent("phone:hangup", target)
	
	exports.log:Add({
		source = source,
		target = target,
		verb = "hung up",
	})

	Calls[source] = nil
	Calls[target] = nil

	local channel = PlayerChannels[source] or PlayerChannels[target]
	if channel then
		Channels[channel] = nil
	end

	PlayerChannels[source] = nil
	PlayerChannels[target] = nil
end

--[[ Events ]]--
RegisterNetEvent("phone:call")
AddEventHandler("phone:call", function(target)
	local source = source
	if not target then return end

	target = GetSource(target)
	if not target then return end
	
	Call(source, target)
end)

RegisterNetEvent("phone:answer")
AddEventHandler("phone:answer", function()
	local source = source
	local target = Calls[source]
	if not target or not Calls[target] or Calls[target] ~= source then return end

	Answer(source, target)
end)

RegisterNetEvent("phone:hangup")
AddEventHandler("phone:hangup", function()
	local source = source
	local target = Calls[source]
	if not target then
		TriggerClientEvent("phone:hangup", source)
		return
	end
	
	HangUp(source, target)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	local target = Calls[source]
	if target then
		HangUp(source, target)
	end
end)

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(3000)
-- 	Call(1,1)
-- end)