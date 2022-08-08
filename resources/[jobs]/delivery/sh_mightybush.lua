exports.jobs:Register("mightybush", {
	Title = "Dealership",
	Name = "Mighty Bush",
	Faction = "delivery",
	Group = "mightybush",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "delivery",
		State = "mightybush",
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