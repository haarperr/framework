exports.jobs:Register("sams", {
	Title = "Federal",
	Name = "San Andreas Marshal Service",
	Faction = "federal",
	Pay = 90,
	Group = "sams",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "state",
	},
	Ranks = {
		{ Name = "Probationary Deputy Marshal" },
		{ Name = "Deputy Marshal" },
		{ Name = "Supervisory Marshal" },
		{
			Name = "Chief Deputy Marshal",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "District Marshal",
			Flags = Jobs.Permissions.ALL()
		},
	},
})