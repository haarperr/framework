AddQuest({
	id = "TASKS_DAILY_GARRY",
	server = true,
	objectiveText = "Decided to start a computer repair shop. Pretty cool right? If you bring Garry over at Mirror Park some scrap electornics we'll pay you well.",
	requirements = {
		items = {
			{ name = "Scrap Electornics", amount = 64 },
		},
	},
	rewards = {
		random = {
			{ name = "Bills", amount = 12000 },
		},
	},
})