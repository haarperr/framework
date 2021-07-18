exports.jobs:Register("Los Santos Department of Water & Power", {
	Public = true,
	Blip = {
		id = 478,
		scale = 0.5,
		color = 26,
	},
	Delivery = {
		Center = vector3(128.63401794433597, -1790.023681640625, 117.05559539794922),
		Properties = {
			Radius = 500.0,
			Max = 128,
			Types = {
				["apartment"] = true,
				["house"] = true,
			},
		},
		Pay = 100,
	},
	Clocks = {
		vector3(520.2094116210938, -1652.173828125, 29.5268497467041),
	},
	Vehicles = {
		{
			Rank = 0,
			In = vector3(527.1103515625, -1652.636474609375, 29.320009231567383),
			Model = "boxville",
			PrimaryColor = 0,
			SecondaryColor = 0,
			Coords = {
				vector4(523.2278442382812, -1653.056396484375, 29.306880950927734, 136.12002563476565),
				vector4(521.0298461914062, -1664.4891357421875, 29.09666633605957, 41.45882797241211),
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