AddNpc({
	name = "Shady Trader",
	id = "TERRITORY_YACHT_BARTENDER",
	coords = vector4(242.8297119140625, 370.8819885253906, 105.73822784423828, 289.7137451171875),
	model = "a_m_o_ktown_01",
	stages = {
		["INIT"] = {
			text = "What can I get you?",
			responses = {
				{
					text = "Do you have anything... special?",
					dialogue = "I have a little something for people that are established.",
				},
			}
		},
	},
})
