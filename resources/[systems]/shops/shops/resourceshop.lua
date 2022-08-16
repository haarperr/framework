Config.Filters.Resource = {
	blip = {
		name = "Resource Shop",
		id = 618,
		scale = 0.5,
		color = 29,
	},
	item = {
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
			model = "cs_floyd",
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
		["sales2"] = {
			item = "Resource Sales",
			invisible = true,
			coords = vector3(11.5801, -2680.863, 6.009491),
			rotation = vector3(-12.79698, -6.670106e-09, 89.62646),
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
			coords = vector3(1110.29, -2008.308, 31.62196),
			rotation = vector3(-20.1329, -8.537736e-07, 140.9155),			
		},
		["grinder1"] = {
			item = "Grindstone",
			invisible = true,
			coords = vector3(1101.828, -2024.645, 44.45947),
			rotation = vector3(-41.0309, -0, -128.5155),			
		},
		["keycard1"] = {
			item = "Keycard Printer",
			invisible = true,
			coords = vector3(1471.083, 6513.639, 20.86739),
			rotation = vector3(-9.37515, 2.668042e-08, -88.12991),
		},
		["keycard2"] = {
			item = "Keycard Printer",
			invisible = true,
			coords = vector3(1343.736, 4391.078, 45.57716),
			rotation = vector3(-12.97093, -0, -6.654992),
		},
		},
	}
)

