--[[ Debug ]]--
exports.chat:RegisterCommand("a:animations", function(source, args, command)
	Animations:ToggleMenu()
end, {
	description = "Open an animation menu for testing purposes.",
	powerLevel = 5,
})

exports.chat:RegisterCommand("a:playanim", function(source, args, command)
	
end, {
	description = "Play any animation.",
	powerLevel = 5,
	parameters = {
		{ name = "Dict", description = "Animation's dictionary." },
		{ name = "Name", description = "Animation's name." },
		{ name = "Flag", description = "Flag to play on the animation" },
	},
})

--[[ Emotes ]]--
exports.chat:RegisterCommand("e", function(source, args, command)
	local name  = tostring(args[1]):lower()

	if name == "c" or name == "cancel" then
		Main:CancelEmote()
		return
	end

	if not Main.emotes[name] then
		TriggerEvent("chat:notify", {
			text = "That emote doesn't exist!",
			class = "error",
		})
		return
	end
	
	Main:PerformEmote(name)
end, {
	description = "Play an emote.",
	parameters = {
		{ name = "Name", description = "Which emote to play." },
	},
})

--[[ Walkstyles ]]--
exports.chat:RegisterCommand("walkstyle", function(source, args, command)
	local name  = tostring(args[1]):lower()

	if not name or not Config.Walkstyles[name] then
		TriggerEvent("chat:notify", {
			text = "That walkstyle doesn't exist!",
			class = "error",
		})
		return
	end

	Main:SetWalkstyle(name)
end, {
	description = "Play an emote.",
	parameters = {
		{ name = "Name", description = "Which emote to play." },
	},
})