Config.Filters.Resource = {
	Item = {
		-- Food.
		["Iron Ingot"] = true,
		["Gold Ingot"] = true,
		["Copper Ingot"] = true,
		["Silver Ingot"] = true,
		["Platinum Ingot"] = true,
		["Steel Ingot"] = true,
		["Wood"] = true,
		["Wood Branch"] = true,
		["Wood Log"] = true,
		["Treated Wood"] = true,
		["Sulfur"] = true,
	},
}

RegisterShop("RESOURCE_247", {
	Name = "Resource Shop",
	Clerks = {
		{
			coords = vector4(48.68785, -2676.06, 6.004161, 270.6614),
		},
	},
	Storage = {
		Coords = vector3(45.68102, -2673.021, 6.009615),
		Radius = 2.0,
		Filters = Config.Filters.Resource,
	},
    Decorations = {
		["sales1"] = {
			item = "Resource Sales",
			invisible = true,
			coords = vector3(47.86516, -2677.576, 6.004142),
			heading = 123.7745,
		},
        ["mill1"] = {
			item = "Saw Mill",
			invisible = true,
			coords = vector3(-554.6359, 5328.727, 73.59967),
			heading = 123.7745,
		},
        ["mill2"] = {
			item = "Saw Mill",
			invisible = true,
			coords = vector3(-554.6359, 5328.727, 73.59967),
			heading = 123.7745,
		},
        ["smelter1"] = {
			item = "Smeltry",
			invisible = true,
			coords = vector3(1111.95, -2008.832, 31.0676),
			heading = 236.7808,
		},
		},
	}
)

