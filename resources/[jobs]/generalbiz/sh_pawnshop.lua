exports.jobs:Register("pawnshop", {
	Title = "Stores",
	Name = "Pawn Shop",
	Faction = "general",
	Group = "pawnshop",
	Clocks = {
		{ Coords = vector3(167.2446, -1313.406, 29.36362), Radius = 1.5 },
	},
	Tracker = {
		Group = "pawnshop",
		State = "general",
	},
	Ranks = {
		{ Name = "Store Assistant" },
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