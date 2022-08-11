EMS_FLAGS = {

}

exports.jobs:Register("paramedic", {
	Title = "EMS",
	Name = "Paramedic",
	Faction = "ems",
	Group = "paramedic",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(199.5579, -1649.098, 29.79591), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "ems",
	},
	Ranks = {
		{ Name = "EMT Recruit", },
		{ Name = "EMT Basic", },
		{ Name = "EMT Paramedic", },
		{ Name = "EMT Advanced Paramedic", },
		{
			Name = "Lieutenant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Captain",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Assistant Chief",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief",
			Flags = Jobs.Permissions.ALL()
		},
	},
})

exports.jobs:Register("firefighter", {
	Title = "EMS",
	Name = "Firefighter",
	Faction = "ems",
	Group = "firefighter",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(199.5579, -1649.098, 29.79591), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "ems",
	},
	Ranks = {
		{ Name = "Probie", },
		{ Name = "Firefighter", },
		{ Name = "Advanced Firefighter", },
		{ Name = "Engineer", },
		{
			Name = "Field Lieutenant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Captain",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Assistant Chief",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief",
			Flags = Jobs.Permissions.ALL()
		},
	},
})

exports.jobs:Register("lsms", {
	Title = "EMS",
	Name = "Los Santos Medical Services",
	Faction = "ems",
	Group = "lsms",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(-430.9317, -325.2623, 34.90064), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "ems",
	},
	Ranks = {
		{ Name = "Nurse", },
		{ Name = "Intern", },
		{ Name = "Resident", },
		{
			Name = "Attending Physician",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Dean of Medicine",
			Flags = Jobs.Permissions.ALL()
		},
	},
})