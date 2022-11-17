exports.jobs:Register("helas", {
	Title = "Farms",
	Name = "Helas Homestead",
	Faction = "farm",
	Group = "helas",
	Clocks = {
		{ Coords = vector3(-67.68621, 6254.081, 31.09013), Radius = 1.5 },
	},
	Tracker = {
		Group = "farm",
		State = "helas",
	},
	Ranks = {
		{ Name = "Farm Worker" },
		{
			Name = "Supervisor",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Owner",
			Flags = Jobs.Permissions.ALL()
		},
	},
})