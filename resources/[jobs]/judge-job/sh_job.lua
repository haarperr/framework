exports.jobs:Register("Judge", {
	Ranks = {
		["Clerk"] = 0,
		["Judge"] = 5,
		["Justice"] = 10,
		["Chief Justice"] = 15,
	},
	Licenses = {
		{ Name = "Pilots", Level = 0 },
		{ Name = "Drivers", Level = 0 },
		{ Name = "Boating", Level = 0 },
		{ Name = "Weapons", Level = 0 },
		{ Name = "Fishing", Level = 0 },
		{ Name = "Hunting", Level = 0 },
	},
	Clocks = {
		vector3(239.40106201171875, -416.80908203125, 47.950679779052734),
	},
	ControlAt = 5,
	Group = "DOJ",
	Pay = 275,
	Emergency = {
		AccessMdt = "police",
		CanFine = true,
		CanJail = true,
	},
})