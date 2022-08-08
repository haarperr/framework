exports.jobs:Register("vanillaunicorn", {
	Title = "Nightclub",
	Name = "Vanilla Unicorn",
	Faction = "nightclub",
	Group = "vanillaunicorn",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "nightclub",
		State = "vanillaunicorn",
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