exports.jobs:Register("staterealtor", {
	Title = "Realtor",
	Name = "State Realtor",
	Faction = "realtor",
	Group = "realtor",
	Clocks = {
		{ Coords = vector3(-541.6601, -179.5692, 43.37186), Radius = 3.5 },
	},
	Ranks = {
		{ Name = "Realtor" },
		{
			Name = "Owner",
			Flags = Jobs.Permissions.ALL()
		},
	},
})