exports.jobs:Register("GoPostal", {
	Public = true,
	Blip = {
		id = 478,
		scale = 0.5,
		color = 1,
	},
	Delivery = {
		Center = vector3(-101.2231674194336, -902.0380859375, 58.2816047668457),
		Properties = {
			Radius = 3000.0,
			Max = 128,
			Types = {
				["motel"] = true,
				["apartment"] = true,
				["house"] = true,
				["mansion"] = true,
			},
		},
		Pay = 100,
	},
	Clocks = {
		vector3(78.79257202148438, 112.04261779785156, 81.16808319091797),
	},
	Vehicles = {
		{
			Rank = 0,
			In = vector3(69.1707534790039, 127.6475830078125, 79.21290588378906),
			Model = "boxville2",
			PrimaryColor = 111,
			SecondaryColor = 64,
			Coords = {
				vector4(62.53487014770508, 124.09296417236328, 79.18883514404297, 158.0498809814453),
				vector4(72.32606506347656, 121.1430892944336, 79.18199157714844, 159.1589508056641),
				vector4(67.45699310302734, 123.11389923095705, 79.14530181884766, 161.6885986328125),
			},
		},
	},
	Ranks = {
		["Driver"] = 0,
		["Manager"] = 20,
	},
	Master = { "Judge" },
	ControlAt = 20,
	Pay = 15
})