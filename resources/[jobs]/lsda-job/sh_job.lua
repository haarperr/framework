exports.jobs:Register("LSDA", {
	Clocks = {
		vector3(-552.15185546875, -186.1952362060547, 38.22307968139648),
	},
	Ranks = {
		["Paralegal"] = 0,
		["State Attorney"] = 5,
		["Probationary Investigator"] = 10,
		["Investigator"] = 15,
		["Chief Investigator"] = 20,
		["Assistant District Attorney"] = 25,
		["District Attorney"] = 30,
	},
	Master = { "Judge" },
	ControlAt = 20,
	UseGroup = true,
	Group = "Emergency",
	Pay = 200,
	Max = 8,
	Tracker = {
		Group = "emergency",
		Color = 51,
		SecondaryColor = 9,
	},
	Emergency = {
		AccessMdt = "police",
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = 2,
	},
})