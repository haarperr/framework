exports.jobs:Register("waterpower", {
	Title = "Dealership",
	Name = "Los Santos Department of Water & Power",
	Faction = "delivery",
	Group = "waterpower",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "delivery",
		State = "waterpower",
	},
	Ranks = {
		{ Name = "Delivery Driver" },
		{
			Name = "Manager",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Owner",
			Flags = Jobs.Permissions.ALL()
		},
	},
})