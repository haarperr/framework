AddQuest({
	id = "TERRITORY_DAILY_MARCUS",
	server = true,
	objectiveText = "Marcus is well... a gun nut. He deals in that sort of thing. Bring him $1,500 in crisp hundreds and he might have something for you. He hangs out near Elysian Fields Freeway and the Oil Field.",
	requirements = {
		items = {
			{ name = "One Hundred Dollars", amount = 15 },
		},
	},
	rewards = {
		random = {
			{ name = "Combat Pistol", amount = 1 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 10.0)
			end
		end,
	},
})
