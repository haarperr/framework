--[[ Opening the radio. ]]--
RegisterCommand("+nsrp_toggleRadio", function()
	if not IsDisabledControlPressed(0, Config.Controls.Modifier) then return end

	Radio:Toggle(not Radio.isOpen)
end)

RegisterKeyMapping("+nsrp_toggleRadio", "Radio - Open", "keyboard", "g")

--[[ Radio volume up. ]]--
RegisterCommand("+nsrp_volUp", function()
	if not IsDisabledControlPressed(0, Config.Controls.Modifier) then return end
	Radio:Commit("switchVolume", 1.0)
end)

RegisterKeyMapping("+nsrp_volUp", "Radio - Volume Up", "keyboard", "UP")

--[[ Radio volume down. ]]--
RegisterCommand("+nsrp_volDown", function()
	if not IsDisabledControlPressed(0, Config.Controls.Modifier) then return end
	Radio:Commit("switchVolume", -1.0)
end)

RegisterKeyMapping("+nsrp_volDown", "Radio - Volume Down", "keyboard", "DOWN")

--[[ Radio channel up. ]]--
RegisterCommand("+nsrp_chanUp", function()
	if not IsDisabledControlPressed(0, Config.Controls.Modifier) then return end
	Radio:Commit("switchChannel", 1.0)
end)

RegisterKeyMapping("+nsrp_chanUp", "Radio - Channel Up", "keyboard", "RIGHT")

--[[ Radio channel down. ]]--
RegisterCommand("+nsrp_chanDown", function()
	if not IsDisabledControlPressed(0, Config.Controls.Modifier) then return end
	Radio:Commit("switchChannel", -1.0)
end)

RegisterKeyMapping("+nsrp_chanDown", "Radio - Channel Down", "keyboard", "LEFT")

--[[ Using the radio. ]]--
RegisterCommand("+nsrp_useRadio", function()
	Radio:SetActive(true)
end)

RegisterCommand("-nsrp_useRadio", function()
	Radio:SetActive(false)
end)

RegisterKeyMapping("+nsrp_useRadio", "Radio - Use", "keyboard", "capital")

--[[ Changing clicks. ]]--
RegisterCommand("radio:clickvariant", function(source, args, command)
	local index = tonumber(args[1]) or 0

	if index < 1 or index > Config.Clicks.Variations then
		TriggerEvent("chat:addMessage", ("Click does not exist, pick a number between 1-%s!"):format(Config.Clicks.Variations))
		return
	end

	Radio.clickVariant = index

	SetResourceKvpInt(Config.Clicks.Key.."Variant", index)
	
	TriggerEvent("chat:addMessage", ("Radio click variant set to %s!"):format(index))
end)

RegisterCommand("radio:clickvolume", function(source, args, command)
	local volume = tonumber(args[1]) or -1

	if volume < 1 or volume > 100 then
		TriggerEvent("chat:addMessage", "Invalid range, enter a number between 1-100!")
		return
	end

	volume = volume / 100.0

	Radio.clickVolume = volume

	SetResourceKvpFloat(Config.Clicks.Key.."Volume", volume)

	TriggerEvent("chat:addMessage", "Radio click volume set to "..math.floor(volume * 100).."%!")
end)