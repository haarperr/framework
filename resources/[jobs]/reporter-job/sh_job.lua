exports.jobs:Register("Reporter", {
	Clocks = {
		vector3(-584.57891845703, -938.93981933594, 23.869621276855),
	},
	Ranks = {
		["Photographer"] = 0,
		["Camera Operator"] = 1,
		["Boom Operator"] = 2,
		["Anchor"] = 10,
		["Pilot"] = 20,
		["Manager"] = 40,
		["Boss"] = 50,
	},
	Master = { "Judge" },
	ControlAt = 50,
	UseGroup = true,
	DispatchDelay = 45.0,
	Group = "Emergency",
	Pay = 125,
	Blip = {
		id = 184,
		scale = 0.8,
		color = 5,
	}
})