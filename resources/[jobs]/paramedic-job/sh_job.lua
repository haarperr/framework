exports.jobs:Register("Paramedic", {
	Clocks = {
		vector3(301.90798950195, -599.39794921875, 43.284057617188),
		vector3(481.4516906738281, -993.7247314453124, 30.68962860107422), -- MRPD.
	},
	Vehicles = {
		{ -- MRPD helicopter.
			Rank = 20,
			In = vector3(461.4571838378906, -979.83349609375, 43.69192886352539),
			Model = "polmav",
			Coords = {
				vector4(449.3006896972656, -981.2842407226564, 43.69166564941406, 90.01665496826172)
			},
		},
		{ -- Sandy helicopter.
			Rank = 20,
			In = vector3(1778.707275390625, 3241.846923828125, 42.279335021972656),
			Model = "polmav",
			Coords = {
				vector4(1770.3162841796875, 3239.838623046875, 42.12533950805664, 102.01332092285156)
			},
		},
		{ -- Paleto helicopter.
			Rank = 20,
			In = vector3(-261.17889404296875, 6310.28173828125, 37.9550895690918),
			Model = "polmav",
			Coords = {
				vector4(-252.42051696777344, 6319.06201171875, 39.65964126586914, 315.49237060546875)
			},
		},
		{ -- Pillbox helicopter.
			Rank = 20,
			In = vector3(339.00408935546875, -587.0245971679688, 74.1644058227539),
			Model = "polmav",
			Coords = {
				vector4(352.0111083984375, -587.1908569335938, 74.1644058227539, 335.9550476074219)
			},
		},
		{ -- La Puerta boat.
			Rank = 20,
			In = vector3(-783.3768920898438, -1506.83154296875, 1.595213294029236),
			Model = "predator",
			Livery = 1,
			PrimaryColor = 134,
			Coords = {
				vector4(-787.7235107421875, -1504.494873046875, 0.5319520235061646, 110.46382904052736)
			},
		},
		{ -- Chiliad boat.
			Rank = 15,
			In = vector3(-1604.5989990234375, 5256.6181640625, 2.07401728630065),
			Model = "predator",
			Livery = 1,
			PrimaryColor = 134,
			Coords = {
				vector4(-1603.509765625, 5261.26806640625, 0.57565468549728, 24.12430381774902)
			},
		},
	},
	Ranks = {
		["Volunteer"] = 0,
		["EMT 1"] = 10,
		["EMT 2"] = 20,
		["Paramedic I"] = 30,
		["Paramedic II"] = 40,
		["Senior Paramedic"] = 50,
		["Advanced Paramedic"] = 60,
		["Lieutenant"] = 70,
		["Captain"] = 80,
		["Assistant Chief"] = 90,
		["Chief"] = 100,
	},
	Master = { "Judge" },
	ControlAt = 70,
	UseGroup = true,
	Group = "Emergency",
	Pay = 200,
	Max = 10,
	Tracker = {
		Group = "emergency",
		Color = 2,
		SecondaryColor = 18,
	},
	Emergency = {
		AccessMdt = "police",
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Panic = "Medic",
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