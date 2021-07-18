exports.jobs:Register("MRPD-Staff", {
	Clocks = {
		vector3(444.4481506347656, -979.8267211914064, 30.68958473205566),
	},
	Ranks = {
		["Janitor"] = 0,
		["Receptionist"] = 10,
		["Dispatcher"] = 20,
		["Administration"] = 30,
	},
	Master = { "Judge" },
	ControlAt = 30,
	UseGroup = true,
	Group = "Emergency",
	Pay = 125,
	Licenses = {
		{ Name = "Drivers", Level = 10 },
		{ Name = "Boating", Level = 10 },
		{ Name = "Weapons", Level = 10 },
		{ Name = "Fishing", Level = 10 },
		{ Name = "Hunting", Level = 10 },
	},
	Emergency = {
		AccessMdt = "police",
		CanFine = true,
		CanImpound = true,
	},
})