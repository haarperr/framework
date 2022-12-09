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
	Vehicles = {
		{ -- MRPD.
			Rank = 0,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Mods = {
				[48] = 4,
			},
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- Sandy.
			Rank = 0,
			In = vector3(1851.546, 3698.241, 33.9746),
			Model = "polmav",
			Mods = {
				[48] = 4,
			},
			Coords = {
				vector4(1853.314, 3706.242, 33.9746, 212.1331)
			},
		},
		{ -- Paleto Bay.
			Rank = 0,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Mods = {
				[48] = 4,
			},
			Coords = {
				vector4(-475.2674255371094, 5988.55810546875, 31.33670616149902, 315.12811279296875)
			},
		},
		{ -- Mount Zonah.
			Rank = 0,
			In = vector3(-440.7097, -316.1926, 78.16725),
			Model = "polmav",
			Mods = {
				[48] = 4,
			},
			Coords = {
				vector4(-447.4776, -312.4739, 78.16724, 20.79933)
			},
		},
		{ -- Higgens Boat Dock.
			Rank = 0,
			In = vector3(-725.7732543945312, -1476.5074462890625, 5.000519752502441),
			Model = "polmav",
			Mods = {
				[48] = 4,
			},
			Coords = {
				vector4(-722.3483276367188, -1472.44873046875, 5.000519752502441, 49.11679458618164)
			},
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