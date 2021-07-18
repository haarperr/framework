AddQuest({
	id = "TERRITORY_DAILY_GRIFFIN",
	server = true,
	objectiveText = "Griffin is quite well known over at Richard's Majestic. His next film involves gold bars, but he refuses to work with the props. Bring him 2 of the real deal.",
	requirements = {
		items = {
			{ name = "Gold Bar", amount = 2 },
		},
	},
	rewards = {
		items = {
			{ name = "Bills", amount = 95285 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})