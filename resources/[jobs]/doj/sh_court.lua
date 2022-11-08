exports.jobs:Register("districtcourt", {
	Title = "District Court",
	Name = "District Court",
	Faction = "federal",
	Group = "districtcourt",
	Pay = 110,
	Clocks = {
		{ Coords = vector3(-557.5701, -192.1732, 38.22698), Radius = 3.5 },
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = false,
		CanFine = true,
		CanImpound = false,
		CanJail = true,
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
			Name = "District Court Judge",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "District Court Manager",
			Flags = Jobs.Permissions.ALL()
		},
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
		{ Name = "Medical" },
		{ Name = "Weapons" },
		{ Name = "Fishing" },
		{ Name = "Hunting" },
		{ Name = "Pilots" },
		{ Name = "Realtor" },
		{ Name = "Commercial-Hunting" },
	},
})