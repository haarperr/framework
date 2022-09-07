AddQuest({
	id = "TERRITORY_DAILY_BILLY",
	server = true,
	objectiveText = "This guy, Billy, he loves hotel parties. Billy thinks he's eating raw energy powder, but it's actually cocaine. He tries to change the subject whenever somebody tries to tell him, but whatever. Bring him a brick of the best cut you can find.",
	completedText = "Thanks!",
	requirements = {
		items = {
			{ name = "Cocaine Brick Compact", amount = 1 },
		},
	},
	rewards = {
		items = {
			{ name = "Marked Bills", amount = 119830 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
