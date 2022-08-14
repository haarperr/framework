exports.jobs:Register("lsda", {
	Title = "Federal",
	Name = "Los Santos District Attorney",
	Faction = "federal",
	Pay = 110,
	Group = "lsda",
	Clocks = {
		{ Coords = vector3(20.6156, -924.1031, 29.90268), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "federal",
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanJail = true,
		CheckIn = 2,
		ChopShop = false,
		DrugBonus = false,
		JailBreak = false,
		Robberies = false,
	},
	Ranks = {
		{ Name = "Paralegal" },
		{ Name = "State Attorney" },
		{ Name = "Probationary Investigator" },
		{ Name = "Investigator" },
		{ Name = "Chief Investigator" },
		{
			Name = "Assistant District Attorney",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "District Attorney",
			Flags = Jobs.Permissions.ALL()
		},
	},
})