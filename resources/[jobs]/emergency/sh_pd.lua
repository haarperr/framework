PD_FLAGS = {
	[1 << 1] = { name = "FTO" },

	[1 << 10] = { name = "Helicopter" },
	[1 << 11] = { name = "Motorcycle" },
	[1 << 12] = { name = "Interceptor" },
	[1 << 13] = { name = "Marine" },
	[1 << 14] = { name = "Medical" },
}

exports.jobs:Register("lspd", {
	Title = "Police",
	Name = "Los Santos Police Department",
	Faction = "pd",
	Group = "lspd",
	Pay = 90,
	-- Description = "Known for winning situations.",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(451.3806, -989.2128, 30.68959), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "lspd",
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
		{ Name = "Cadet" },
		{ Name = "Probationary Officer" },
		{ Name = "Officer" },
		{ Name = "Senior Officer" },
		{ Name = "Corporal" },
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
			Name = "Chief of Police",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Vehicles = {
		{ -- MRPD.
			Rank = 0,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- MRPD Interceptor.
			Rank = 0,
			In = vector3(458.8453, -1022.333, 28.25194),
			Model = "polcoquetteg",
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(453.8888, -1024.356, 27.76532, 49.2397)
			},
		},		
		{ -- Sandy.
			Rank = 0,
			In = vector3(1851.546, 3698.241, 33.9746),
			Model = "polmav",
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(1853.314, 3706.242, 33.9746, 212.1331)
			},
		},
		{ -- Sandy Interceptor.
			Rank = 0,
			In = vector3(1837.621, 3689.885, 33.97464),
			Model = "polcoquetteg",
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(1840.379, 3693.882, 33.27345, 340.9695)
			},
		},			
		{ -- Paleto Bay.
			Rank = 0,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(-475.2674255371094, 5988.55810546875, 31.33670616149902, 315.12811279296875)
			},
		},
		{ -- Paleto Interceptor.
			Rank = 0,
			In = vector3(-459.6599, 6031.548, 31.44805),
			Model = "polcoquetteg",		
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(-454.628, 6040.89, 30.63842, 135.5516)
			},
		},			
		{ -- Mount Zonah.
			Rank = 0,
			In = vector3(-440.7097, -316.1926, 78.16725),
			Model = "polmav",
			Mods = {
				[48] = 0,
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
				[48] = 0,
			},
			Coords = {
				vector4(-722.3483276367188, -1472.44873046875, 5.000519752502441, 49.11679458618164)
			},
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Weapons" },
		{ Name = "Pilots" },
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
})

exports.jobs:Register("bcso", {
	Title = "Police",
	Name = "Blaine County Sheriff's Office",
	Faction = "pd",
	Pay = 90,
	Group = "bcso",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(1837.863, 3680.292, 34.18918), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "bcso",
	},
	Ranks ={
		{ Name = "Cadet" },
		{ Name = "Probationary Deputy" },
		{ Name = "Deputy" },
		{ Name = "Senior Deputy" },
		{ Name = "Corporal" },
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
			Name = "Undersheriff",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Sheriff",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Vehicles = {
		{ -- MRPD.
			Rank = 0,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Mods = {
				[48] = 2,
			},
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- MRPD Interceptor.
			Rank = 0,
			In = vector3(458.8453, -1022.333, 28.25194),
			Model = "polcoquetteg",
			PrimaryColor = 153,			
			Mods = {
				[48] = 1,
			},
			Coords = {
				vector4(453.8888, -1024.356, 27.76532, 49.2397)
			},
		},		
		{ -- Sandy.
			Rank = 0,
			In = vector3(1851.546, 3698.241, 33.9746),
			Model = "polmav",
			Mods = {
				[48] = 2,
			},
			Coords = {
				vector4(1853.314, 3706.242, 33.9746, 212.1331)
			},
		},
		{ -- Sandy Interceptor.
			Rank = 0,
			In = vector3(1837.621, 3689.885, 33.97464),
			Model = "polcoquetteg",
			PrimaryColor = 153,			
			Mods = {
				[48] = 1,
			},
			Coords = {
				vector4(1840.379, 3693.882, 33.27345, 340.9695)
			},
		},		
		{ -- Paleto Bay.
			Rank = 0,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Mods = {
				[48] = 2,
			},
			Coords = {
				vector4(-475.2674255371094, 5988.55810546875, 31.33670616149902, 315.12811279296875)
			},
		},
		{ -- Paleto Interceptor.
			Rank = 0,
			In = vector3(-459.6599, 6031.548, 31.44805),
			Model = "polcoquetteg",
			PrimaryColor = 153,			
			Mods = {
				[48] = 1,
			},
			Coords = {
				vector4(-454.628, 6040.89, 30.63842, 135.5516)
			},
		},		
		{ -- Mount Zonah.
			Rank = 0,
			In = vector3(-440.7097, -316.1926, 78.16725),
			Model = "polmav",
			Mods = {
				[48] = 2,
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
				[48] = 2,
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
})

exports.jobs:Register("sasp", {
	Title = "Police",
	Name = "San Andreas State Police",
	Faction = "pd",
	Pay = 90,
	Group = "sasp",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(-445.5677, 6019.318, 32.28866), Radius = 3.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "sasp",
	},
	Ranks ={
		{ Name = "Cadet" },
		{ Name = "Probationary Trooper" },
		{ Name = "Trooper" },
		{ Name = "Senior Trooper" },
		{ Name = "Trooper First Class" },
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
			Name = "Lieutenant Colonel",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Colonel",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Vehicles = {
		{ -- MRPD.
			Rank = 0,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Mods = {
				[48] = 1,
			},
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- MRPD Interceptor.
			Rank = 0,
			In = vector3(458.8453, -1022.333, 28.25194),
			Model = "polcoquettegb",
			PrimaryColor = 6,
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(453.8888, -1024.356, 27.76532, 49.2397)
			},
		},
		{ -- Sandy.
			Rank = 0,
			In = vector3(1851.546, 3698.241, 33.9746),
			Model = "polmav",
			Mods = {
				[48] = 1,
			},
			Coords = {
				vector4(1853.314, 3706.242, 33.9746, 212.1331)
			},
		},
		{ -- Sandy Interceptor.
			Rank = 0,
			In = vector3(1837.621, 3689.885, 33.97464),
			Model = "polcoquettegb",
			PrimaryColor = 6,			
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(1840.379, 3693.882, 33.27345, 340.9695)
			},
		},			
		{ -- Paleto Bay.
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
		{ -- Paleto Interceptor.
			Rank = 0,
			In = vector3(-459.6599, 6031.548, 31.44805),
			Model = "polcoquettegb",
			PrimaryColor = 6,			
			Mods = {
				[48] = 0,
			},
			Coords = {
				vector4(-454.628, 6040.89, 30.63842, 135.5516)
			},
		},			
		{ -- Mount Zonah.
			Rank = 0,
			In = vector3(-440.7097, -316.1926, 78.16725),
			Model = "polmav",
			Mods = {
				[48] = 1,
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
				[48] = 1,
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
})

exports.jobs:Register("doc", {
	Title = "Police",
	Name = "Department of Corrections",
	Faction = "pd",
	Pay = 90,
	Group = "doc",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(1789.061, 2548.169, 45.80244), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "doc",
	},
	Ranks ={
		{ Name = "Probationary Corrections Officer" },
		{ Name = "Corrections Officer I" },
		{ Name = "Corrections Officer II" },
		{ Name = "Corporal" },
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
			Name = "Deputy Warden",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Warden",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Emergency = {
		AccessMdt = "police",
		CanJail = true,
		CanImpound = true,
		CanFine = true,
		JailBreak = true,
		Corrections = true,
	},
})