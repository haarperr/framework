exports.jobs:Register("gopostal", {
	Title = "Dealership",
	Name = "Go-Postal",
	Faction = "delivery",
	Group = "gopostal",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "delivery",
		State = "gopostal",
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