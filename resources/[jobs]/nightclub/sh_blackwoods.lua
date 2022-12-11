exports.jobs:Register("blackwoods", {
	Title = "Nightclub",
	Name = "Black Woods Saloon",
	Faction = "nightclub",
	Group = "blackwoods",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "nightclub",
		State = "blackwoods",
	},
	Ranks = {
		{ Name = "Security" },
		{ Name = "Cook" },
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