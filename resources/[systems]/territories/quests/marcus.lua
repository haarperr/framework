AddQuest({
	id = "TERRITORY_DAILY_MARCUS",
	server = true,
	objectiveText = "Marcus is well... a gun nut. He deals in that sort of thing. Bring him $30,000 in distinctive bills and he might have something for you. He hangs out near Elysian Fields Freeway and the Oil Field.",
	requirements = {
		items = {
			{ name = "Marked Bills", amount = 30000 },
		},
	},
	rewards = {
		random = {
			{ name = "AP Pistol", amount = 1 },
			{ name = "Combat Pistol", amount = 1 },
			{ name = "Pump Shotgun", amount = 1 },
			{ name = "Double Barrel Shotgun", amount = 1 },
			{ name = "Assault SMG", amount = 1 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 10.0)
			end
		end,
	},
})
