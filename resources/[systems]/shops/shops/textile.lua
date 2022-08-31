Config.Filters.Textile = {
	item = {
		["Black Ink"] = true,
		["Brown Ink"] = true,
		["Green Ink"] = true,
		["Blue Ink"] = true,
		["Brown Ink"] = true,
		["Cloth"] = true,
	},
}

RegisterShop("TEXTILE_1", {
	Name = "Texile Mill",
	Clerks = {
		{
			coords = vector4(708.4426, -966.8796, 30.39535, 33.0609),
			model = "a_f_o_indian_01",
		},
	},
	Storage = {
		Coords = vector3(708.8674, -963.4448, 30.39535),
		Radius = 2.0,
		Filters = Config.Filters.Textile,
	},
	}
)