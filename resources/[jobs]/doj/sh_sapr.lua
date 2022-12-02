exports.jobs:Register("sapr", {
	Title = "Federal",
	Name = "San Andreas Park Rangers",
	Faction = "federal",
	Pay = 130,
	Group = "sapr",
	Clocks = {
		{ Coords = vector3(381.5987, 794.0215, 190.4905), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "sapr",
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		ChopShop = true,
		DrugBonus = true,
		JailBreak = true,
		Robberies = true,
	},
	Ranks = {
		{ Name = "Ranger" },
		{ Name = "Senior Ranger" },
		{
			Name = "Sergeant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
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