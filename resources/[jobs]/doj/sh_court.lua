exports.jobs:Register("districtcourt", {
	Title = "Federal",
	Name = "Courthouse",
	Faction = "federal",
	Group = "doj",
	Pay = 130,
	Clocks = {
		{ Coords = vector3(-557.5701, -192.1732, 38.22698), Radius = 3.5 },
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = false,
		CanFine = true,
		CanImpound = false,
		CanJail = true,
		CheckIn = 2,
		ChopShop = false,
		DrugBonus = false,
		JailBreak = false,
		Robberies = false,
	},
	Ranks = {
		{ Name = "Secretary" },
		{ Name = "Head Secretary" },
		{ Name = "Clerk" },
		{
			Name = "Judge",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Court Manager",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Boating" },
		{ Name = "Medical" },
		{ Name = "Weapons" },
		{ Name = "Fishing" },
		{ Name = "Hunting" },
		{ Name = "Pilots" },
		{ Name = "Realtor" },
		{ Name = "Commercial-Hunting" },
	},
})