exports.jobs:Register("cameltow", {
	Title = "Mechanic Shop",
	Name = "Camel Tow & Customs",
	Faction = "mechanic",
	Group = "cameltow",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "mechanic",
		State = "cameltow",
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

		{ -- Paleto Mechanic Garage.
			Rank = 0,
			In = vector3(120.5153350830078, 6624.37353515625, 31.95952033996582),
			Model = "flatbed",
			PrimaryColor = 0,
			SecondaryColor = 0,
			Coords = {
				vector4(125.96055603027344, 6624.87109375, 31.79936790466309, 135.3380889892578)
			},
		},
	},	
})