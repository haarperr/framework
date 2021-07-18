exports.jobs:Register("LSPD", {
	-- Clocks = {
	-- },
	Vehicles = {
		{ -- MRPD.
			Rank = 15,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- La Mesa.
			Rank = 15,
			In = vector3(838.2332763671875, -1395.865234375, 26.31386375427246),
			Model = "polmav",
			Coords = {
				vector4(836.5736694335938, -1406.729736328125, 26.133567810058597, 90.5609893798828)
			},
		},
		{ -- Sandy.
			Rank = 15,
			In = vector3(1778.707275390625, 3241.846923828125, 42.279335021972656),
			Model = "polmav",
			Coords = {
				vector4(1770.3162841796875, 3239.838623046875, 42.12533950805664, 102.01332092285156)
			},
		},
		{ -- Davis.
			Rank = 15,
			In = vector3(365.4794006347656, -1610.0294189453125, 36.94868850708008),
			Model = "polmav",
			Coords = {
				vector4(363.3021240234375, -1597.7979736328125, 36.94868850708008, 322.3875732421875)
			},
		},
		{ -- Paleto Bay.
			Rank = 15,
			In = vector3(-469.8903198242188, 6002.68505859375, 31.30247497558593),
			Model = "polmav",
			Coords = {
				vector4(-475.2674255371094, 5988.55810546875, 31.33670616149902, 315.12811279296875)
			},
		},
		{ -- Pillbox.
			Rank = 15,
			In = vector3(339.00408935546875, -587.0245971679688, 74.1644058227539),
			Model = "polmav",
			Coords = {
				vector4(352.0111083984375, -587.1908569335938, 74.1644058227539, 335.9550476074219)
			},
		},
		{ -- La Puerta.
			Rank = 15,
			In = vector3(-783.3768920898438, -1506.83154296875, 1.595213294029236),
			Model = "predator",
			PrimaryColor = 134,
			Coords = {
				vector4(-787.7235107421875, -1504.494873046875, 0.5319520235061646, 110.46382904052736)
			},
		},
		{ -- Chiliad.
			Rank = 15,
			In = vector3(-1609.0858154296875, 5246.728515625, 3.97409772872924),
			Model = "predator",
			PrimaryColor = 134,
			Coords = {
				vector4(-1616.7120361328125, 5243.80224609375, -0.47487032413482, 23.28446388244629)
			},
		},
		{ -- LSPD Mustang Sandy.
			Rank = 15,
			In = vector3(1854.200439453125, 3679.010986328125, 33.82350158691406),
			Model = "pddemon",
			Livery = 1,
			Extras = {
				[1] = true,
				[3] = true,
			},
			Coords = {
				vector4(1853.446044921875, 3676.443359375, 33.78342819213867, 213.1733551025391)
			},
		},
		{ -- LSPD Mustang MRPD.
			Rank = 15,
			In = vector3(460.0509033203125, -974.5726928710938, 25.69997024536132),
			Model = "pddemon",
			Livery = 1,
			Extras = {
				[1] = true,
				[3] = true,
			},
			Coords = {
				vector4(450.8050842285156, -975.7809448242188, 25.69997406005859, 90.8576202392578)
			},
		},
	},
	Ranks = {
		["Cadet"] = 0,
		["Officer"] = 5,
		["Senior Officer"] = 15,
		["Corporal"] = 20,
		["Sergeant"] = 25,
		["Lieutenant"] = 30,
		["Captain"] = 35,
		["Deputy Chief"] = 40,
		["Assistant Chief"] = 45,
		["Chief of Police"] = 50,
	},
	Licenses = {
		{ Name = "Drivers", Level = 0 },
		{ Name = "Boating", Level = 0 },
		{ Name = "Weapons", Level = 0 },
		{ Name = "Pilots", Level = 0 },
		{ Name = "Fishing", Level = 0 },
		{ Name = "Hunting", Level = 0 },
	},
	Master = { "Judge" },
	ControlAt = 25,
	UseGroup = true,
	Group = "Emergency",
	Pay = 200,
	Max = 14,
	Tracker = {
		Group = "emergency",
		Color = 38,
		SecondaryColor = 9,
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