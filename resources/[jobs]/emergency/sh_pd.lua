PD_FLAGS = {
	[1 << 1] = { name = "FTO" },

	[1 << 10] = { name = "Helicopter" },
	[1 << 11] = { name = "Motorcycle" },
	[1 << 12] = { name = "Interceptor" },
	[1 << 13] = { name = "Marine" },
	[1 << 14] = { name = "Medical" },
}

exports.jobs:Register("lspd", {
	Title = "Police",
	Name = "Los Santos Police Department",
	Faction = "pd",
	Group = "lspd",
	Pay = 80,
	-- Description = "Known for winning situations.",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(451.3806, -989.2128, 30.68959), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "lspd",
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = 2,
		ChopShop = true,
		DrugBonus = true,
		JailBreak = true,
		Robberies = true,
	},
	Ranks = {
		{ Name = "Cadet" },
		{ Name = "Probationary Officer" },
		{ Name = "Officer" },
		{ Name = "Senior Officer" },
		{ Name = "Corporal" },
		{
			Name = "Sergeant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
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
			Name = "Deputy Chief",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief of Police",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Weapons" },
		{ Name = "Pilots" },
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = 2,
		ChopShop = true,
		DrugBonus = true,
		JailBreak = true,
		Robberies = true,
	},
})

exports.jobs:Register("bcso", {
	Title = "Police",
	Name = "Blaine County Sheriff's Office",
	Faction = "pd",
	Pay = 80,
	Group = "bcso",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(1837.863, 3680.292, 34.18918), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "bcso",
	},
	Ranks ={
		{ Name = "Cadet" },
		{ Name = "Probationary Deputy" },
		{ Name = "Deputy" },
		{ Name = "Senior Deputy" },
		{ Name = "Corporal" },
		{
			Name = "Sergeant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
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
			Name = "Undersheriff",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Sheriff",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Boating" },
		{ Name = "Weapons" },
		{ Name = "Fishing" },
		{ Name = "Hunting" },
		{ Name = "Pilots" },
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = 2,
		ChopShop = true,
		DrugBonus = true,
		JailBreak = true,
		Robberies = true,
	},
})

exports.jobs:Register("sasp", {
	Title = "Police",
	Name = "San Andreas State Police",
	Faction = "pd",
	Pay = 80,
	Group = "sasp",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(-445.5677, 6019.318, 32.28866), Radius = 3.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "sasp",
	},
	Ranks ={
		{ Name = "Cadet" },
		{ Name = "Probationary Trooper" },
		{ Name = "Trooper" },
		{ Name = "Senior Trooper" },
		{ Name = "Trooper First Class" },
		{
			Name = "Sergeant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
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
			Name = "Lieutenant Colonel",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Colonel",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Boating" },
		{ Name = "Weapons" },
		{ Name = "Fishing" },
		{ Name = "Hunting" },
		{ Name = "Pilots" },
	},
	Emergency = {
		AccessMdt = "police",
		CanBreach = true,
		CanFine = true,
		CanImpound = true,
		CanJail = true,
		CheckIn = 2,
		ChopShop = true,
		DrugBonus = true,
		JailBreak = true,
		Robberies = true,
	},
})

exports.jobs:Register("doc", {
	Title = "Police",
	Name = "Department of Corrections",
	Faction = "pd",
	Pay = 80,
	Group = "doc",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(1848.291, 3686.824, 34.27011), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "doc",
	},
	Ranks ={
		{ Name = "Probationary Corrections Officer" },
		{ Name = "Corrections Officer I" },
		{ Name = "Corrections Officer II" },
		{ Name = "Corporal" },
		{
			Name = "Sergeant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
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
			Name = "Deputy Warden",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Warden",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Emergency = {
		AccessMdt = "police",
		CanJail = true,
		CanImpound = true,
		CanFine = true,
		CheckIn = 2,
		JailBreak = true,
		Corrections = true,
	},
})