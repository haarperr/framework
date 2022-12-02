exports.jobs:Register("route68", {
	Title = "Mechanic Shop",
	Name = "Mickey's Garage",
	Faction = "mechanic",
	Group = "route68",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "mechanic",
		State = "route68",
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
	Vehicles = {

		{ -- RT 68 .
			Rank = 0,
			In = vector3(1189.8507080078125, 2651.068115234375, 37.83514404296875),
			Model = "flatbed",
			PrimaryColor = 27,
			SecondaryColor = 0,
			Coords = {
				vector4(1164.0753173828125, 2641.443115234375, 38.04860687255859, 357.9701232910156)
			},
		},
	},	
})