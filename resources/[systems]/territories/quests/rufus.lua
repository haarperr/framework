AddQuest({
	id = "TERRITORY_DAILY_RUFUS",
	server = true,
	objectiveText = "Rufus is looking for some high quality pharmaceuticals. Bring him a package of Oxycodone if you stumble upon some.",
	requirements = {
		items = {
			{ name = "Packaged Oxycodone", amount = 1 },
		},
	},
	rewards = {
		items = {
			{ name = "Bills", amount = 100309 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})