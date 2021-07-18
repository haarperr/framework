exports.jobs:Register("Parole", {
	Clocks = {
		vector3(1792.0245361328125, 2543.010009765625, 45.79745483398437),
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
		["Parole Officer"] = 0,
		["Supervisor"] = 10,
	},
	Master = { "Judge" },
	ControlAt = 10,
	UseGroup = true,
	Group = "Emergency",
	Pay = 200,
	Max = 6,
	Tracker = {
		Group = "emergency",
		Color = 56,
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