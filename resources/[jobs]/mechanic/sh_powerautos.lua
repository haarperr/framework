exports.jobs:Register("powerautos", {
	Title = "Mechanic Shop",
	Name = "Power Autos",
	Faction = "mechanic",
	Group = "powerautos",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "mechanic",
		State = "powerautos",
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

		{ -- Power Autos.
			Rank = 0,
			In = vector3(-16.00259971618652, -1030.253662109375, 28.95600700378418),
			Model = "flatbed",
			PrimaryColor = 74,
			SecondaryColor = 0,
			Coords = {
				vector4(-24.64294052124023, -1019.8231811523438, 28.87130546569824, 67.10264587402344)
			},
		},
	},	
})