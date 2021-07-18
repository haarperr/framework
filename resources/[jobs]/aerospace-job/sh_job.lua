exports.jobs:Register("Aerospace", {
	--Clocks = {
	--},
	Vehicles = {
		{ -- LS Airport.
			Rank = 10,
			In = vector3(-1267.7779541015625, -3401.575927734375, 13.94015502929687),
			Model = "hondajet",
			Coords = {
				vector4(-1271.29638671875, -3380.456298828125, 13.94014644622802, 330.07568359375)
			},
		},
	},
	Ranks = {
		["Crew Member"] = 0,
		["Pilot"] = 10,
		["Flight Instructor"] = 20,
		["Senior Flight Instructor"] = 30,
		["Management"] = 40,
		["Owner"] = 50,
	},
	Licenses = {
		{ Name = "Pilots", Level = 20 },
	},
	Master = { "Judge" },
	ControlAt = 40,
	UseGroup = true,
	Pay = 20,
	Tracker = {
		Group = "aerospace",
		Color = 73,
		SecondaryColor = 11,
	},
})