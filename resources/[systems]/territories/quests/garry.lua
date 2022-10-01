AddQuest({
	id = "TERRITORY_DAILY_GARRY",
	server = true,
	objectiveText = "Garry wants a shipment of some mad ass Girl Scout Cookies. He's got his hands busy keeping the waves going.",
	requirements = {
		items = {
			{ name = "Girl Scout Cookies Weed", amount = 256 },
		},
	},
	rewards = {
		items = {
			{ name = "Marked Bills", amount = 9320 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
