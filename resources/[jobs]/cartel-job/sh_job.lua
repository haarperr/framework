exports.jobs:Register("Cartel", {
	Clocks = {
		vector3(4993.1015625, -5712.97509765625, 19.88019752502441), -- Villa.
	},
	Ranks = {
		["Halcón"] = 0,
		["Sicario"] = 10,
		["Teniente"] = 20,
		["El Jefe"] = 30,
	},
	Vehicles = {
		{ -- Cayo Perico Airstrip.
			Rank = 10,
			In = vector3(4478.3369140625, -4442.62158203125, 4.11659288406372),
			Model = "cuban800",
			PrimaryColor = 111,
			SecondaryColor = 111,
			Coords = {
				vector4(4484.6552734375, -4460.29150390625, 4.24137544631958, 168.6766357421875)
			},
		},
		{
			Rank = 20,
			In = vector3(4930.51708984375, -5145.9072265625, 2.45980358123779),
			Model = "longfin",
			PrimaryColor = 0,
			SecondaryColor = 111,
			Coords = {
				vector4(4940.21728515625, -5145.07763671875, -0.36269131302833, 66.87728881835938)
			},
		},
		{
			Rank = 10,
			In = vector3(5153.3955078125, -4656.16162109375, 1.4359632730484),
			Model = "squalo",
			PrimaryColor = 0,
			SecondaryColor = 111,
			Coords = {
				vector4(5155.68115234375, -4660.4453125, -0.47469899058341, 342.044189453125)
			},
		},
		{
			Rank = 20,
			In = vector3(4880.81298828125, -5726.30517578125, 26.36125755310058),
			Model = "volatus",
			PrimaryColor = 6,
			SecondaryColor = 0,
			Coords = {
				vector4(4890.5517578125, -5736.548828125, 26.35090065002441, 338.10009765625)
			},
		},
	},
	ControlAt = 30,
	Pay = 20,
})