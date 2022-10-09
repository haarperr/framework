AddQuest({
	id = "TERRITORY_DAILY_BERT",
	server = true,
	objectiveText = "Bert fucked up and lost the bosses wifes favorite ring. There are only a limited amount in the world. I need you to find one and take it to him before we all end up at the bottom of the ocean.",
	requirements = {
		items = {
			{ name = "Barma Ruby Ring", amount = 1 },
		},
	},
	rewards = {
		random = {
			{ name = "Marked Bills", amount = 31630 },
			{ name = "Golden USB", amount = 1 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
