exports.jobs:Register("opr", {
	Title = "Federal",
	Name = "Office of Professional Responsibility",
	Faction = "federal",
	Pay = 110,
	Group = "opr",
	Clocks = {
		{ Coords = vector3(-537.8631, -192.0788, 43.36591), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "opr",
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