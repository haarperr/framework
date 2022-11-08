EMS_FLAGS = {

}

exports.jobs:Register("paramedic", {
	Title = "EMS",
	Name = "LSFD Paramedic",
	Faction = "ems",
	Pay = 90,
	Group = "paramedic",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(199.5579, -1649.098, 29.79591), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "ems",
	},
	Ranks = {
		{ Name = "EMT Recruit", },
		{ Name = "EMT Basic", },
		{ Name = "EMT Paramedic", },
		{ Name = "EMT Advanced Paramedic", },
		{
			Name = "Lieutenant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Captain",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Deputy Chief",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Vehicles = {
		{ -- MRPD helicopter.
			Rank = 0,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- LS Freeway PD.
			Rank = 0,
			In = vector3(1574.3641357421875, 838.5654907226562, 77.14142608642578),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(1564.4281005859375, 844.2615966796875, 77.1413803100586, 58.50824356079101)
			},
		},
		{ -- Sandy helicopter.
			Rank = 0,
			In = vector3(1851.546, 3698.241, 33.9746),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(1853.314, 3706.242, 33.9746, 212.1331)
			},
		},
		{ -- Paleto helicopter.
			Rank = 0,
			In = vector3(-261.6651916503906, 6313.49853515625, 37.59577560424805),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(-252.42051696777344, 6319.06201171875, 39.65964126586914, 315.49237060546875)
			},
		},
		{ -- Paleto Mass Casualty Cargobob.
			Rank = 0,
			In = vector3(-257.6318664550781, 6309.6103515625, 37.60367965698242),
			Model = "cargobob2",
			PrimaryColor = 111,
			SecondaryColor = 27,
			Coords = {
				vector4(-252.42051696777344, 6319.06201171875, 39.65964126586914, 315.49237060546875)
			},
		},
		{ -- Paleto Bay PD.
			Rank = 0,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Mods = {
				[48] = 1,
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
				[48] = 3,
			},
			Coords = {
				vector4(-447.4776, -312.4739, 78.16724, 20.79933)
			},
		},
		{ -- Mount Zonah Mass Casualty Cargobob.
			Rank = 0,
			In = vector3(-449.4891, -294.8787, 78.16725),
			Model = "cargobob2",
			PrimaryColor = 111,
			SecondaryColor = 27,
			Coords = {
				vector4(-456.4517, -291.2623, 78.16725, 20.69705)
			},
		},
		{ -- Higgens Boat Dock.
			Rank = 0,
			In = vector3(-725.7732543945312, -1476.5074462890625, 5.000519752502441),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(-722.3483276367188, -1472.44873046875, 5.000519752502441, 49.11679458618164)
			},
		},
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Respawn = true,
		Panic = "Paramedic",
		DispatchPriority = {
			["10-47a"] = true,
			["10-47b"] = true,
			["10-47c"] = true,
			["10-47d"] = true,
			["10-52"] = true,
			["11-99"] = true,
		},
	},
})

exports.jobs:Register("firefighter", {
	Title = "EMS",
	Name = "LSFD Firefighter",
	Faction = "ems",
	Pay = 90,
	Group = "firefighter",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(208.1045, -1656.281, 29.80074), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "firefighter",
	},
	Ranks = {
		{ Name = "Probie", },
		{ Name = "Firefighter", },
		{ Name = "Advanced Firefighter", },
		{ Name = "Engineer", },
		{
			Name = "Lieutenant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Captain",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Deputy Chief",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Vehicles = {
		{ -- MRPD helicopter.
			Rank = 0,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- LS Freeway PD.
			Rank = 0,
			In = vector3(1574.3641357421875, 838.5654907226562, 77.14142608642578),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(1564.4281005859375, 844.2615966796875, 77.1413803100586, 58.50824356079101)
			},
		},
		{ -- Sandy helicopter.
			Rank = 0,
			In = vector3(1851.546, 3698.241, 33.9746),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(1853.314, 3706.242, 33.9746, 212.1331)
			},
		},
		{ -- Paleto helicopter.
			Rank = 0,
			In = vector3(-261.6651916503906, 6313.49853515625, 37.59577560424805),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(-252.42051696777344, 6319.06201171875, 39.65964126586914, 315.49237060546875)
			},
		},
		{ -- Paleto Mass Casualty Cargobob.
			Rank = 0,
			In = vector3(-257.6318664550781, 6309.6103515625, 37.60367965698242),
			Model = "cargobob2",
			PrimaryColor = 111,
			SecondaryColor = 27,
			Coords = {
				vector4(-252.42051696777344, 6319.06201171875, 39.65964126586914, 315.49237060546875)
			},
		},
		{ -- Paleto Bay PD.
			Rank = 0,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Mods = {
				[48] = 1,
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
				[48] = 3,
			},
			Coords = {
				vector4(-447.4776, -312.4739, 78.16724, 20.79933)
			},
		},
		{ -- Mount Zonah Mass Casualty Cargobob.
			Rank = 0,
			In = vector3(-449.4891, -294.8787, 78.16725),
			Model = "cargobob2",
			PrimaryColor = 111,
			SecondaryColor = 27,
			Coords = {
				vector4(-456.4517, -291.2623, 78.16725, 20.69705)
			},
		},
		{ -- Higgens Boat Dock.
			Rank = 0,
			In = vector3(-725.7732543945312, -1476.5074462890625, 5.000519752502441),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(-722.3483276367188, -1472.44873046875, 5.000519752502441, 49.11679458618164)
			},
		},
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Panic = "Firefighter",
		DispatchPriority = {
			["10-47a"] = true,
			["10-47b"] = true,
			["10-47c"] = true,
			["10-47d"] = true,
			["10-52"] = true,
			["11-99"] = true,
		},
	},
})

exports.jobs:Register("lsms", {
	Title = "EMS",
	Name = "Los Santos Medical Services",
	Faction = "ems",
	Pay = 90,
	Group = "lsms",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(-430.9317, -325.2623, 34.90064), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "lsms",
	},
	Ranks = {
		{ Name = "Nurse", },
		{ Name = "Intern", },
		{ Name = "Resident", },
		{
			Name = "Attending Physician",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Dean of Medicine",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Vehicles = {
		{ -- MRPD helicopter.
			Rank = 0,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- LS Freeway PD.
			Rank = 0,
			In = vector3(1574.3641357421875, 838.5654907226562, 77.14142608642578),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(1564.4281005859375, 844.2615966796875, 77.1413803100586, 58.50824356079101)
			},
		},
		{ -- Sandy helicopter.
			Rank = 0,
			In = vector3(1851.546, 3698.241, 33.9746),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(1853.314, 3706.242, 33.9746, 212.1331)
			},
		},
		{ -- Paleto Hospital Helicopter.
			Rank = 0,
			In = vector3(-261.6651916503906, 6313.49853515625, 37.59577560424805),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(-252.42051696777344, 6319.06201171875, 39.65964126586914, 315.49237060546875)
			},
		},
		{ -- Paleto Mass Casualty Cargobob.
			Rank = 0,
			In = vector3(-257.6318664550781, 6309.6103515625, 37.60367965698242),
			Model = "cargobob2",
			PrimaryColor = 111,
			SecondaryColor = 27,
			Coords = {
				vector4(-252.42051696777344, 6319.06201171875, 39.65964126586914, 315.49237060546875)
			},
		},
		{ -- Paleto Bay PD.
			Rank = 0,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Mods = {
				[48] = 1,
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
				[48] = 3,
			},
			Coords = {
				vector4(-447.4776, -312.4739, 78.16724, 20.79933)
			},
		},
		{ -- Mount Zonah Mass Casualty Cargobob.
			Rank = 0,
			In = vector3(-449.4891, -294.8787, 78.16725),
			Model = "cargobob2",
			PrimaryColor = 111,
			SecondaryColor = 27,
			Coords = {
				vector4(-456.4517, -291.2623, 78.16725, 20.69705)
			},
		},
		{ -- Higgens Boat Dock.
			Rank = 0,
			In = vector3(-725.7732543945312, -1476.5074462890625, 5.000519752502441),
			Model = "polmav",
			Mods = {
				[48] = 3,
			},
			Coords = {
				vector4(-722.3483276367188, -1472.44873046875, 5.000519752502441, 49.11679458618164)
			},
		},
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Panic = "Doctor",
		DispatchPriority = {
			["10-47a"] = true,
			["10-47b"] = true,
			["10-47c"] = true,
			["10-47d"] = true,
			["10-52"] = true,
			["11-99"] = true,
		},
	},
})