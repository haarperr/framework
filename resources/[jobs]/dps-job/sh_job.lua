exports.jobs:Register("DPS", {
	--Clocks = {
	--	vector3(-449.96136474609375, 6010.41357421875, 31.71635437011718),
	--	vector3(840.5059814453125, -1291.14697265625, 28.23316574096679),
	--},
	Vehicles = {
		{ -- MRPD.
			Rank = 10,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- La Mesa.
			Rank = 10,
			In = vector3(838.2332763671875, -1395.865234375, 26.31386375427246),
			Model = "polmav",
			Coords = {
				vector4(836.5736694335938, -1406.729736328125, 26.133567810058597, 90.5609893798828)
			},
		},
		{ -- Sandy.
			Rank = 10,
			In = vector3(1778.707275390625, 3241.846923828125, 42.279335021972656),
			Model = "polmav",
			Coords = {
				vector4(1770.3162841796875, 3239.838623046875, 42.12533950805664, 102.01332092285156)
			},
		},
		{ -- Davis.
			Rank = 10,
			In = vector3(365.4794006347656, -1610.0294189453125, 36.94868850708008),
			Model = "polmav",
			Coords = {
				vector4(363.3021240234375, -1597.7979736328125, 36.94868850708008, 322.3875732421875)
			},
		},
		{ -- Paleto Bay.
			Rank = 10,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Coords = {
				vector4(-475.2674255371094, 5988.55810546875, 31.33670616149902, 315.12811279296875)
			},
		},
		{ -- Pillbox.
			Rank = 10,
			In = vector3(339.00408935546875, -587.0245971679688, 74.1644058227539),
			Model = "polmav",
			Coords = {
				vector4(352.0111083984375, -587.1908569335938, 74.1644058227539, 335.9550476074219)
			},
		},
		{ -- La Puerta.
			Rank = 10,
			In = vector3(-783.3768920898438, -1506.83154296875, 1.595213294029236),
			Model = "predator",
			PrimaryColor = 134,
			Coords = {
				vector4(-787.7235107421875, -1504.494873046875, 0.5319520235061646, 110.46382904052736)
			},
		},
		{ -- Chiliad.
			Rank = 10,
			In = vector3(-1609.0858154296875, 5246.728515625, 3.97409772872924),
			Model = "predator",
			PrimaryColor = 134,
			Coords = {
				vector4(-1616.7120361328125, 5243.80224609375, -0.47487032413482, 23.28446388244629)
			},
		},
		{ -- Mustang La Mesa.
			Rank = 30,
			In = vector3(862.4668579101562, -1361.5787353515625, 26.11133193969726),
			Model = "dpsdemon",
			Livery = 0,
			Extras = {
				[1] = true,
				[3] = true,
			},
			Coords = {
				vector4(860.9470825195312, -1357.6168212890625, 26.09544944763183, 92.80709075927736)
			},
		},
		{ -- Mustang Paleto.
			Rank = 30,
			In = vector3(-483.49957275390625, 6028.59716796875, 31.34051322937011),
			Model = "dpsdemon",
			Livery = 0,
			Extras = {
				[1] = true,
				[3] = true,
			},
			Coords = {
				vector4(-482.4667663574219, 6024.63818359375, 31.34052848815918, 223.88595581054688)
			},
		},
	},
	Ranks = {
		["Cadet"] = 0,
		["Probationary Trooper"] = 10,
		["Trooper"] = 20,
		["Senior Trooper"] = 30,
		["Trooper First Class"] = 40,
		["Sergeant"] = 50,
		["Lieutenant"] = 60,
		["Captain"] = 70,
		["Major"] = 80,
		["Lieutenant Colonel"] = 90,
		["Colonel"] = 100,
	},
	Licenses = {
		{ Name = "Drivers", Level = 0 },
		{ Name = "Boating", Level = 0 },
		{ Name = "Weapons", Level = 0 },
		{ Name = "Fishing", Level = 0 },
		{ Name = "Hunting", Level = 0 },
		{ Name = "Pilots", Level = 50 },
	},
	Master = { "Judge" },
	ControlAt = 50,
	UseGroup = true,
	Group = "Emergency",
	Pay = 200,
	Max = 14,
	Tracker = {
		Group = "emergency",
		Color = 5,
		SecondaryColor = 12,
	},
	Emergency = {
		AccessMdt = "police",
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = 2,
		ChopShop = true,
		DrugBonus = true,
		JailBreak = true,
		Robberies = true,
	},
})