AddQuest({
	id = "TERRITORY_DAILY_MARCUS",
	server = true,
	objectiveText = "Marcus is well... a gun nut. He deals in that sort of thing. Bring him $30,000 and he might have something for you. He hangs out under the overpass crossing Elysian Fields Freeway and Palomino.",
	requirements = {
		items = {
			{ name = "Bills", amount = 30000 },
		},
	},
	rewards = {
		random = {
			{ name = "Assault Rifle", amount = 1 },
			{ name = "Carbine Rifle", amount = 1 },
			{ name = "Compact Rifle", amount = 1 },
			{ name = "Pump Shotgun", amount = 1 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})