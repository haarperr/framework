exports.jobs:Register("beanmachine", {
	Title = "Restaurant",
	Name = "Bean Machine",
	Faction = "restaurant",
	Group = "beanmachine",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "restaurant",
		State = "beanmachine",
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