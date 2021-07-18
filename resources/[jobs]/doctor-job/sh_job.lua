exports.jobs:Register("Doctor", {
	Clocks = {
		vector3(355.2673034667969, -596.1283569335938, 43.28409957885742),
	},
	Ranks = {
		["Nurse"] = 0,
		["Doctor"] = 5,
		["Dean"] = 10,
	},
	Master = { "Judge" },
	ControlAt = 10,
	UseGroup = false,
	Group = "Emergency",
	Pay = 250,
	Max = 10,
	Tracker = {
		Group = "emergency",
		Color = 76,
		SecondaryColor = 76,
	},
	Emergency = {
		AccessMdt = "police",
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Panic = "Doctor",
	},
})