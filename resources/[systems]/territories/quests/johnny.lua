AddQuest({
	id = "TERRITORY_DAILY_JOHNNY",
	server = true,
	objectiveText = "Johnny recently put in an order for steel for some giant building project and it fell through. Bring him 80 steel ingots.",
	requirements = {
		items = {
			{ name = "Steel Ingot", amount = 80 },
		},
	},
	rewards = {
		items = {
			{ name = "One Hundred Dollars", amount = 66 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 10.0)
			end
		end,
	},
})
