AddQuest({
	id = "TERRITORY_DAILY_MERC",
	server = true,
	objectiveText = "Mercenaries get things done, and it doesn't matter how to them. But they need guns. We're in touch with some over at Humane Labs. They have the parts but need the schematics. Bring them 3 large, 6 small, weapon blueprints, or a combination of them both.",
	requirements = {
		minScore = 6,
		items = {
			{ name = "Advanced Rifle Blueprint", amount = 1, score = 2, sum = true },
			{ name = "AP Pistol Blueprint", amount = 1, score = 1, sum = true },
			{ name = "Assault Rifle Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Assault SMG Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Bullpup Shotgun Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Carbine Rifle Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Combat PDW Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Combat Pistol Blueprint", amount = 1, score = 1, sum = true },
			{ name = "Double Barrel Shotgun Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Gusenberg Sweeper Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Heavy Pistol Blueprint", amount = 1, score = 1, sum = true },
			{ name = "Heavy Shotgun Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Machine Pistol Blueprint", amount = 1, score = 1, sum = true },
			{ name = "Micro SMG Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Mini SMG Blueprint", amount = 1, score = 1, sum = true },
			{ name = "Pistol 50 Blueprint", amount = 1, score = 1, sum = true },
			{ name = "SMG Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Special Carbine Blueprint", amount = 1, score = 2, sum = true },
			{ name = "Sweeper Shotgun Blueprint", amount = 1, score = 2, sum = true },
		},
	},
	rewards = {
		items = {
			{ name = "Bills", amount = 25321 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})