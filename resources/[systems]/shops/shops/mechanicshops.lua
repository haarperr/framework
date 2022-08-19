RegisterShop("MECHANIC_SHOP", {
	Name = "Mechanic Shop",
	Storage = {
		Coords = vector3(-1196.097, -904.3538, 13.99892),
		Radius = 1.0,
	},
	Containers = {
		{ -- Axles
			text = "Storage",
			radius = 0.6,
			coords = vector3(550.3969, -168.4101, 54.80797),
			discrete = true,
			width = 4,
			height = 20,
			factions = {
				["axles"] = "mechanic",
			},
			filters = {
				category = {
					["Vehicle Repair"] = true,
                    ["Vehicle"] = true,
                    ["Resource"] = true,
                    ["Tool"] = true,
                    ["Heist"] = true,
				}
			},
		},
        { -- Misfits
			text = "Storage",
			radius = 0.6,
			coords = vector3(952.424, -976.8836, 39.84251),
			discrete = true,
			width = 4,
			height = 20,
			factions = {
				["misfits"] = "mechanic",
			},
			filters = {
				category = {
					["Vehicle Repair"] = true,
                    ["Vehicle"] = true,
                    ["Resource"] = true,
                    ["Tool"] = true,
                    ["Heist"] = true,
				}
			},
		},
        { -- Power Autos
			text = "Storage",
			radius = 0.6,
			coords = vector3(-35.72437, -1071.158, 29.03377),
			discrete = true,
			width = 4,
			height = 20,
			factions = {
				["powerautos"] = "mechanic",
			},
			filters = {
				category = {
					["Vehicle Repair"] = true,
                    ["Vehicle"] = true,
                    ["Resource"] = true,
                    ["Tool"] = true,
                    ["Heist"] = true,
				}
			},
		},
        { -- Bike Shop
			text = "Storage",
			radius = 0.6,
			coords = vector3(906.8254, 3566.067, 34.55768),
			discrete = true,
			width = 4,
			height = 20,
			factions = {
				["bikeshop"] = "mechanic",
			},
			filters = {
				category = {
					["Vehicle Repair"] = true,
                    ["Vehicle"] = true,
                    ["Resource"] = true,
                    ["Tool"] = true,
                    ["Heist"] = true,
				}
			},
		},
        { -- Camel Tow
			text = "Storage",
			radius = 0.6,
			coords = vector3(98.01134, 6619.154, 32.78787),
			discrete = true,
			width = 4,
			height = 20,
			factions = {
				["cameltow"] = "mechanic",
			},
			filters = {
				category = {
					["Vehicle Repair"] = true,
                    ["Vehicle"] = true,
                    ["Resource"] = true,
                    ["Tool"] = true,
                    ["Heist"] = true,
				}
			},
		},
		{ -- Route 68
			text = "Storage",
			radius = 0.6,
			coords = vector3(1189.684, 2636.479, 38.67702),
			discrete = true,
			width = 4,
			height = 20,
			factions = {
				["route68"] = "mechanic",
			},
			filters = {
				category = {
					["Vehicle Repair"] = true,
                    ["Vehicle"] = true,
                    ["Resource"] = true,
                    ["Tool"] = true,
                    ["Heist"] = true,
				}
			},
		},
	},
})