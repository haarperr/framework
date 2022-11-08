exports.jobs:Register("opr", {
	Title = "Federal",
	Name = "Office of Professional Responsibility",
	Faction = "federal",
	Pay = 110,
	Group = "opr",
	Clocks = {
		{ Coords = vector3(-528.0028, -186.3415, 38.22709), Radius = 3.5 },
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
		{ Name = "Investigator" },
		{ Name = "Senior Investigator" },
		{
			Name = "Assistant Director",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Director",
			Flags = Jobs.Permissions.ALL()
		},
	},
})