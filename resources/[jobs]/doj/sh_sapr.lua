exports.jobs:Register("sapr", {
	Title = "Federal",
	Name = "San Andreas Park Rangers",
	Faction = "federal",
	Pay = 90,
	Group = "sapr",
	Clocks = {
		{ Coords = vector3(381.5987, 794.0215, 190.4905), Radius = 3.5 },
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
		{ Name = "Ranger" },
		{ Name = "Senior Ranger" },
		{ Name = "Sergeant" },
		{
			Name = "Superintendent",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Game Warden",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Boating" },
		{ Name = "Weapons" },
		{ Name = "Fishing" },
		{ Name = "Hunting" },
		{ Name = "Pilots" },
	},
})