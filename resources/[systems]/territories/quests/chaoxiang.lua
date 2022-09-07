AddQuest({
	id = "TERRITORY_DAILY_CHAOXIANG",
	server = true,
	objectiveText = "Chaoxiang runs some... business down at the docks. Rumor has it that he needs something for his organization back east. Bring him a brick of Heroin.",
	requirements = {
		items = {
			{ name = "Heroin Brick", amount = 1 },
		},
	},
	rewards = {
		items = {
			{ name = "Marked Bills", amount = 88130 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
