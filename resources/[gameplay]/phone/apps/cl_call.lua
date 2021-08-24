InCall = false
CallChannel = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local emote = exports.emotes:GetCurrentEmote()
		if InCall then
			if not emote or not emote.IsCall then
				exports.emotes:Play(Config.Call.Anim)
			end
		else
			if emote and emote.IsCall then
				exports.emotes:Stop()
			end
			Citizen.Wait(500)
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
AppHooks["phone-call"] = function(content)
	Call(content.number)
end

function Call(target)
	TriggerServerEvent("phone:call", target)
	LoadApp("phone-call", {
		state = "Calling",
		number = target,
		name = exports.character:Get("phone_contacts")[target] or "Unknown Number",
	})
end

--[[ Events ]]--
RegisterNetEvent("phone:answer")
AddEventHandler("phone:answer", function(number, channel)
	CallChannel = channel or number
	InCall = true
	
	exports.voip:JoinChannel(CallChannel, "Automatic", "phone", 0.4)

	LoadApp("phone-call", {
		state = "In Call",
		number = number,
		name = exports.character:Get("phone_contacts")[number] or "Unknown Number",
	})
end)

RegisterNetEvent("phone:hangup")
AddEventHandler("phone:hangup", function()
	exports.voip:LeaveChannel(CallChannel)
	InCall = false

	LoadApp("phone-call", {
		hangup = true,
	})
end)

--[[ Callbacks ]]--
RegisterNUICallback("call", function(data)
	Call(data.number)
end)

RegisterNUICallback("hangup", function(data)
	TriggerServerEvent("phone:hangup")
end)

RegisterNUICallback("answer", function(data)
	TriggerServerEvent("phone:answer")
end)