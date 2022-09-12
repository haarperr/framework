exports.jobs:Register("opa", {
	Title = "Federal",
	Name = "Office of Public Administration",
	Faction = "federal",
	Pay = 100,
	Group = "opa",
	Clocks = {
		{ Coords = vector3(23.35812, -933.2761, 33.90338), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "opa",
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = 2,
		ChopShop = false,
		DrugBonus = false,
		JailBreak = false,
		Robberies = false,
	},
	Ranks = {
		{ Name = "Administrator" },
		{ Name = "Senior Administrator" },
		{ Name = "Support Manager" },
		{
			Name = "Specialist",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Deputy Director",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Director",
			Flags = Jobs.Permissions.ALL()
		},
	},
})