Config.Filters.Digital = {
	blip = {
		name = "Tech Shop",
		id = 459,
		scale = 0.5,
		color = 29,
	},
	item = {
		["Mobile Phone"] = true,
		["Tablet"] = true,
		["Satellite Radio"] = true,
		["Binoculars"] = true,
		["Camera"] = true,
	},
}

RegisterShop("ELEC_STORE_1", {
	Name = "Digital Den Mirror Park",
	Clerks = {
		{
			coords = vector4(1137.393, -470.9925, 66.64777, 252.1172),
			model = "u_m_y_gabriel",
		},
	},
	Storage = {
		Coords = vector3(1137.393, -470.9925, 66.64777),
		Radius = 2.0,
		Filters = Config.Filters.Digital,
	},
	}
)

RegisterShop("ELEC_STORE_2", {
	Name = "Digital Den Paleto",
	Clerks = {
		{
			coords = vector4(-30.35926, 6480.384, 31.50102, 50.94812),
			model = "u_m_m_vince",
		},
	},
	Storage = {
		Coords = vector3(-30.35926, 6480.384, 31.50102),
		Radius = 2.0,
		Filters = Config.Filters.Digital,
	},
	}
)