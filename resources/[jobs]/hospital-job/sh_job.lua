exports.jobs:Register("Hospital", {
	Clocks = {
		vector3(299.7810363769531, -600.0584106445312, 43.28410339355469),
	},
	Ranks = {
		["Receptionist"] = 0,
		["Security"] = 5,
		["Administration"] = 10,
		["Head of Personnel"] = 15,
	},
	Master = { "Judge" },
	ControlAt = 10,
	UseGroup = false,
	Group = "Emergency",
	Pay = 125,
	Emergency = {
		CanImpound = true,
		CheckIn = true,
	},
})