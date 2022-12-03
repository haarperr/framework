exports.jobs:Register("docksidemech", {
	Title = "Mechanic Shop",
	Name = "Crossroads Tuning",
	Faction = "mechanic",
	Group = "docksidemech",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "mechanic",
		State = "docksidemech",
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
		{ -- Dockside.
			Rank = 0,
			In = vector3(158.3742, -3012.157, 6.021935),
			Model = "flatbed",
			PrimaryColor = 55,
			SecondaryColor = 0,
			Coords = {
				vector4(165.3806, -3009.482, 5.897386, 264.7101)
			},
		},
	},
})