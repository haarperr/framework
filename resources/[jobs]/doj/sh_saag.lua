exports.jobs:Register("saag", {
	Title = "Federal",
	Name = "San Andreas Attorney General",
	Faction = "federal",
	Group = "saag",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "federal",
	},
	Ranks = {
		{ Name = "Paralegal" },
		{ Name = "State Attorney" },
		{ Name = "Probationary Investigator" },
		{ Name = "Investigator" },
		{ Name = "Chief Investigator" },
		{ Name = "Assistant District Attorney" },
		{ Name = "District Attorney" },
		{
			Name = "Deputy Attorney General",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Attorney General",
			Flags = Jobs.Permissions.ALL()
		},
	},
})