AddQuest({
	id = "TASKS_DAILY_JULIA",
	server = true,
	objectiveText = "Julia over at Hookies is panicking because they've ran out of Queen Fish. Can you take her over 16 of them?",
	requirements = {
		items = {
			{ name = "Queenfish", amount = 16 },
		},
	},
	rewards = {
		random = {
			{ name = "Bills", amount = 25000 },
		},
	},
})