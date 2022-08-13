EMS_FLAGS = {

}

exports.jobs:Register("paramedic", {
	Title = "EMS",
	Name = "Paramedic",
	Faction = "ems",
	Pay = 80,
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
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Panic = "Paramedic",
		DispatchPriority = {
			["10-47a"] = true,
			["10-47b"] = true,
			["10-47c"] = true,
			["10-47d"] = true,
			["10-52"] = true,
			["11-99"] = true,
		},
	},
})

exports.jobs:Register("firefighter", {
	Title = "EMS",
	Name = "Firefighter",
	Faction = "ems",
	Pay = 90,
	Group = "firefighter",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(208.1045, -1656.281, 29.80074), Radius = 2.0 },
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
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Panic = "Firefighter",
		DispatchPriority = {
			["10-47a"] = true,
			["10-47b"] = true,
			["10-47c"] = true,
			["10-47d"] = true,
			["10-52"] = true,
			["11-99"] = true,
		},
	},
})

exports.jobs:Register("lsms", {
	Title = "EMS",
	Name = "Los Santos Medical Services",
	Faction = "ems",
	Pay = 80,
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
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = true,
		Panic = "Doctor",
		DispatchPriority = {
			["10-47a"] = true,
			["10-47b"] = true,
			["10-47c"] = true,
			["10-47d"] = true,
			["10-52"] = true,
			["11-99"] = true,
		},
	},
})