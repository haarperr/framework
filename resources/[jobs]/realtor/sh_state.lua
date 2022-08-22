exports.jobs:Register("staterealtor", {
	Title = "Realtor",
	Name = "State Realtor",
	Faction = "realtor",
	Group = "realtor",
	Clocks = {
		{ Coords = vector3(-555.0002, -228.0124, 38.17121), Radius = 3.5 },
	},
	Ranks = {
		{ Name = "Realtor" },
		{
			Name = "Owner",
			Flags = Jobs.Permissions.ALL()
		},
	},
})