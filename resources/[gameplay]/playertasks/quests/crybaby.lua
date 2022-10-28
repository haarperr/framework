AddQuest({
	id = "TASKS_DAILY_CRYBABY",
	server = true,
	objectiveText = "There's a crybaby at the Pier that needs a bandage.",
	requirements = {
		items = {
			{ name = "Bandage", amount = 1 },
		},
	},
	rewards = {
		random = {
			{ name = "Bills", amount = 5000 },
		},
	},
})
