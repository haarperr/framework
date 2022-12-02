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
	Vehicles = {

		{ -- Misfits.
			Rank = 0,
			In = vector3(949.66748046875, -957.4671020507812, 39.49985122680664),
			Model = "flatbed",
			PrimaryColor = 112,
			SecondaryColor = 0,
			Coords = {
				vector4(953.232666015625, -944.9090576171876, 39.49985122680664, 157.59141540527344)
			},
		},
	},		
})