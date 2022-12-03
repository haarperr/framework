exports.jobs:Register("axles", {
	Title = "Mechanic Shop",
	Name = "Axle's Auto Exotic",
	Faction = "mechanic",
	Group = "axles",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "mechanic",
		State = "axles",
	},
	Ranks = {
		{ Name = "Tow Driver" },
		{ Name = "Mechanic" },
		{ Name = "Supervisor" },
		{
			Name = "Manager",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Owner",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Vehicles = {

		{ -- Axels Autos.
			Rank = 0,
			In = vector3(543.6646118164062, -202.7570953369141, 54.46318054199219),
			Model = "flatbed",
			PrimaryColor = 112,
			SecondaryColor = 0,
			Coords = {
				vector4(546.1356201171875, -212.3310546875, 53.11816024780273, 171.2291717529297)
			},
		},
	},	
})