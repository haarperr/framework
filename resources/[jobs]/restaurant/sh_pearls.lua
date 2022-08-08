exports.jobs:Register("pearls", {
	Title = "Restaurant",
	Name = "pearls",
	Faction = "restaurant",
	Group = "pearls",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "restaurant",
		State = "pearls",
	},
	Ranks = {
		{ Name = "Employee" },
		{ Name = "Shift Lead" },
		{ Name = "Assistant Manager" },
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