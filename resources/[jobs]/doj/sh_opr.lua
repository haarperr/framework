exports.jobs:Register("opr", {
	Title = "Federal",
	Name = "Office of Professional Responsibility",
	Faction = "federal",
	Group = "opr",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "federal",
	},
	Ranks = {
		{ Name = "Investigator" },
		{ Name = "Senior Investigator" },
		{
			Name = "Assistant Director",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Director",
			Flags = Jobs.Permissions.ALL()
		},
	},
})