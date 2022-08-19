Config.Filters.Storage = {
	item = {
		-- Floor Storage.
		["Safe"] = true,
		["Plastic Tote"] = true,
		["Large Storage Container"] = true,
		["Tool Box"] = true,
		["Military Storage Container"] = true,
	},
}

RegisterShop("STORAGE_01", {
	Name = "Storage Vendor",
	Clerks = {
		{
			coords = vector4(725.8601, -932.618, 24.57071, 327.4731),
			model = "cs_joeminuteman",
		},
	},
	Storage = {
		Coords = vector3(725.8601, -932.618, 24.57071),
		Radius = 2.0,
		Filters = Config.Filters.Storage,
	},
})