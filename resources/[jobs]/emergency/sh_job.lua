exports.jobs:Register("lspd", {
	Title = "Police",
	Name = "LSPD",
	Faction = "pd",
	Group = "lspd",
	Clocks = {
		{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
		{ Coords = vector3(453.5949, -980.6509, 30.57985), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "pd",
	},
	Ranks = {
		"Recruit",
		"Chief",
	},
})

exports.jobs:Register("bcso", {
	Title = "Police",
	Name = "BCSO",
	Faction = "pd",
	Group = "bcso",
	Clocks = {
		{ Coords = vector3(1848.291, 3686.824, 34.27011), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "pd",
	},
	Ranks ={
		"Recruit",
		"Sheriff",
	},
})

exports.jobs:Register("sasp", {
	Title = "Police",
	Name = "SASP",
	Faction = "pd",
	Group = "sasp",
	Clocks = {
		{ Coords = vector3(1543.839, 828.1853, 77.66039), Radius = 3.0 },
		{ Coords = vector3(1546.448, 826.5332, 77.65541), Radius = 3.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "pd",
	},
})

exports.jobs:Register("paramedic", {
	Name = "Paramedic",
	Faction = "ems",
	Group = "paramedic",
	Clocks = {
		{ Coords = vector3(305.0252, -600.062, 43.28405), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "ems",
	},
})