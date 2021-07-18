exports.jobs:Register("DOC", {
	Clocks = {
		vector3(1841.8013916015625, 2573.731201171875, 46.01435470581055),
		vector3(1772.8507080078125, 2571.79833984375, 45.72985076904297),
	},
	Vehicles = {
		{
			Rank = 0,
			In = vector3(1840.2677001953127, 2529.259033203125, 45.67201614379883),
			Model = "pbus",
			Coords = {
				vector4(1845.020751953125, 2529.9638671875, 46.47146987915039, 358.4324951171875)
			},
		},
	},
	Ranks = {
		["Probationary Corrections Officer"] = 0,
		["Corrections Officer I"] = 10,
		["Corrections Officer II"] = 20,
		["Corporal"] = 30,
		["Sergeant"] = 40,
		["Lieutenant"] = 50,
		["Captain"] = 60,
		["Deputy Warden"] = 90,
		["Warden"] = 100,
	},
	Master = { "Judge" },
	ControlAt = 40,
	UseGroup = true,
	Group = "Emergency",
	Pay = 200,
	Max = 15,
	Tracker = {
		Group = "emergency",
		Color = 8,
		SecondaryColor = 34,
	},
	Emergency = {
		AccessMdt = "police",
		CanJail = true,
		CanImpound = true,
		CanFine = true,
		CheckIn = 2,
		JailBreak = true,
	},
})