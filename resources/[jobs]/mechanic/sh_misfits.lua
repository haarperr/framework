exports.jobs:Register("misfits", {
	Title = "Mechanic Shop",
	Name = "Misfits",
	Faction = "mechanic",
	Group = "misfits",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "mechanic",
		State = "misfits",
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
})