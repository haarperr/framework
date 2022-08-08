exports.jobs:Register("doj", {
	Title = "State",
	Name = "Department of Justice",
	Faction = "state",
	Group = "doj",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "state",
		State = "doj",
	},
	Ranks = {
		{ Name = "Secretary" },
		{ Name = "Head Secretary" },
		{ Name = "Clerk" },
		{ Name = "Judge" },
		{ Name = "Court Manager" },
		{
			Name = "Justice",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief Justice",
			Flags = Jobs.Permissions.ALL()
		},
	},
})