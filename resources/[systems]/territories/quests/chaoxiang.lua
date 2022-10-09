AddQuest({
	id = "TERRITORY_DAILY_CHAOXIANG",
	server = true,
	objectiveText = "Chaoxiang runs some... business down at the docks. Rumor has it that he needs something for his organization back east. Bring him a brick of Heroin.",
	requirements = {
		items = {
			{ name = "Purple Kush Weed", amount = 256 },
		},
	},
	rewards = {
		items = {
			{ name = "One Hundred Dollars", amount = 81 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
