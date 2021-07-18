RegisterCommand("voip:channelhud", function()
	Voip.hideFrequencies = not Voip.hideFrequencies

	TriggerEvent("chat:addMessage", ("You will now %ssee channels on the HUD."):format(Voip.hideFrequencies and "NOT " or ""))
	
	SendNUIMessage({ channels = channels })

	SetResourceKvpInt(Config.ChannelHudKey, Voip.hideFrequencies and 1 or 0)
end)

RegisterCommand("voip:reset", function()
	Voip:Init()
end)

RegisterCommand("+nsrp_voipRange", function()
	if Voip.amplified then return end

	local range = (Voip.range or 2) + 1
	if range > Config.CycleRanges then
		range = 1
	end
	
	Voip:SetRange(range)
end)

RegisterKeyMapping("+nsrp_voipRange", "Voip - Change Range", "keyboard", "z")

--[[ Debug ]]--
RegisterCommand("voip:debug", function(source, args, command)
	if (exports.user:GetUser(source).power_level or 0) < 50 then return end

	Voip.debug = not Voip.debug

	print("Voip debug set: "..tostring(Voip.debug))
end)

RegisterCommand("voip:joinchannel", function(source, args, command)
	if not Voip.debug then
		print("Debug must be active!")
		return
	end

	local channel = args[1]
	if not channel then
		print("Invalid channel!")
		return
	end

	local _type = args[2]
	if not _type then
		print("Invalid type!", json.encode(Config.Types))
		return
	end

	Voip:JoinChannel(channel, _type)

	print("Attempting to join channel: "..channel.." (".._type..")")
end)

RegisterCommand("voip:leavechannel", function(source, args, command)
	if not Voip.debug then
		print("Debug must be active!")
		return
	end

	local channel = args[1]
	if not channel then
		print("Invalid channel!")
		return
	end

	Voip:LeaveChannel(channel)

	print("Attempting to leave channel: "..channel)
end)