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
			{ name = "One Hundred Dollars", amount = 93 },
		},
		custom = function(self, source)
			if source then
				GiveReputation(source, 5.0)
			end
		end,
	},
})
