exports.jobs:Register("beanies", {
	Title = "Restaurant",
	Name = "Beanies Cafe",
	Faction = "restaurant",
	Group = "beanies",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "restaurant",
		State = "beanies",
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