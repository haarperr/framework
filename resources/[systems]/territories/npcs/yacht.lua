AddNpc({
	name = "Boat Staff",
	id = "TERRITORY_YACHT_GREATER",
	coords = vector4(-1363.681396484375, 6736.9228515625, 2.4458858966827393, 294.65911865234375),
	model = "mp_m_boatstaff_01",
	stages = {
		["INIT"] = {
			text = "Welcome aboard! Feel free to explore. I highly recommend stopping by the bar...",
		},
	},
})

AddNpc({
	name = "Bar Tender",
	id = "TERRITORY_YACHT_BARTENDER",
	coords = vector4(-1440.7269287109375, 6757.89208984375, 8.980452537536621, 183.9722900390625),
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