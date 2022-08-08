exports.jobs:Register("bahamamamas", {
	Title = "Nightclub",
	Name = "Bahama Mamas",
	Faction = "nightclub",
	Group = "bahamamamas",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "nightclub",
		State = "bahamamamas",
	},
	Ranks = {
		{ Name = "Security" },
		{ Name = "Dancer" },
		{ Name = "Bartender" },
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