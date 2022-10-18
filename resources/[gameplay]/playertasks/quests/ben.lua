AddQuest({
	id = "TASKS_DAILY_BEN",
	server = true,
	objectiveText = "Ben is crying out over at Bilgeco after he lost a shipment of 64 copper ingots. If you can replace them, he'll really pay well.",
	requirements = {
		items = {
			{ name = "Copper Ingot", amount = 48 },
		},
	},
	rewards = {
		random = {
			{ name = "Bills", amount = 28000 },
		},
	},
})