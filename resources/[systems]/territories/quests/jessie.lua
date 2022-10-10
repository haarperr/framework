AddQuest({
	id = "TERRITORY_DAILY_JESSIE",
	server = true,
	objectiveText = "This guy, Jessie, he loves blazing it up. Bring him a shit load of the best puff you can find.",
	completedText = "Thanks!",
	requirements = {
		items = {
			{ name = "Weed", amount = 256 },
		},
	},
	rewards = {
		items = {
			{ name = "One Hundred Dollars", amount = 68 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
