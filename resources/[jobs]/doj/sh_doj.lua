exports.jobs:Register("doj", {
	Title = "Federal",
	Name = "Department of Justice",
	Faction = "federal",
	Pay = 130,
	Group = "doj",
	Clocks = {
		{ Coords = vector3(-548.3115, -187.7004, 38.22693), Radius = 3.5 },
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
		CheckIn = 2,
		ChopShop = false,
		DrugBonus = false,
		JailBreak = false,
		Robberies = false,
	},
	Ranks = {
		{ Name = "Judge"},
		{ Name = "Court Manager" },
		{
			Name = "Justice",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief Justice",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Boating" },
		{ Name = "Weapons" },
		{ Name = "Medical" },
		{ Name = "Fishing" },
		{ Name = "Hunting" },
		{ Name = "Pilots" },
		{ Name = "Realtor" },
		{ Name = "Commercial-Hunting" },
		{ Name = "Business" },
	},
})