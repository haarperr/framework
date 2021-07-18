AddQuest({
	id = "TERRITORY_DAILY_JOHNNY",
	server = true,
	objectiveText = "Johnny recently put in an order for steel for some giant building project and it fell through. Bring him 80 steel ingots.",
	requirements = {
		items = {
			{ name = "Steel Ingots", amount = 80 },
		},
	},
	rewards = {
		items = {
			{ name = "Bills", amount = 11365 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})