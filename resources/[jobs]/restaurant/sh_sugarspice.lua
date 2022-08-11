exports.jobs:Register("sugarspice", {
	Title = "Restaurant",
	Name = "Sugar & Spice",
	Faction = "restaurant",
	Group = "sugarspice",
	Clocks = {
		{ Coords = vector3(1117.41, -641.4694, 56.81786), Radius = 3.5 },
	},
	Tracker = {
		Group = "restaurant",
		State = "sugarspice",
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