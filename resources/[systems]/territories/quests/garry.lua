AddQuest({
	id = "TERRITORY_DAILY_GARRY",
	server = true,
	objectiveText = "Garry wants a brick of weed. He's got his hands busy keeping the waves going.",
	requirements = {
		items = {
			{ name = "Weed Brick", amount = 1 },
		},
	},
	rewards = {
		items = {
			{ name = "Marked Bills", amount = 53320 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
