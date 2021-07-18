AddQuest({
	id = "TERRITORY_DAILY_GARRY",
	server = true,
	objectiveText = "Garry works at Walker on Elysian Island. They have a lot of wealthy customers always looking for a little grass on the side. Bring him a brick of weed.",
	requirements = {
		items = {
			{ name = "Weed Brick", amount = 1 },
		},
	},
	rewards = {
		items = {
			{ name = "Bills", amount = 56320 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})