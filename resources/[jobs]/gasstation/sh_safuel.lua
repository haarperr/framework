exports.jobs:Register("safuel", {
	Title = "Gas Station",
	Name = "San Andreas Fuel",
	Faction = "gasstation",
	Group = "safuel",
	Clocks = {
		{ Coords = vector3(167.2446, -1313.406, 29.36362), Radius = 1.5 },
	},
	-- Tracker = {
	-- 	Group = "gasstation",
	-- 	State = "general",
	-- },
	Ranks = {
		{ Name = "Gas Station Attendent" },
		{
			Name = "Manager",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "CEO",
			Flags = Jobs.Permissions.ALL()
		},
	},
})