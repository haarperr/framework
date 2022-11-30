exports.jobs:Register("saag", {
	Title = "Federal",
	Name = "San Andreas Attorney General",
	Faction = "federal",
	Pay = 140,
	Group = "saag",
	Clocks = {
		{ Coords = vector3(19.60668, -928.3267, 33.90338), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "federal",
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		ChopShop = false,
		DrugBonus = false,
		JailBreak = false,
		Robberies = false,
	},
	Ranks = {
		{ Name = "Paralegal" },
		{ Name = "Secretary" },
		{
			Name = "Administrator",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Deputy Attorney General",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Attorney General",
			Flags = Jobs.Permissions.ALL()
		},
	},
})