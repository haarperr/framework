Config.Filters.Armory = {
	item = {
		["Radio"] = true,
		["Body Armor"] = true,
		["Pistol 50"] = true,
		["Field Kit"] = true,
        ["Gunshot Residue Kit"] = true,
		["Evidence Bag"] = true,
		["9mm Parabellum"] = true,
        ["Flashlight"] = true,
        ["Handcuffs"] = true,
        ["Heavy Armor"] = true,
        ["Ballistic Helmet"] = true,
        ["Pistol Mk II"] = true,
        ["9mm Parabellum Box"] = true,
        ["9mm Magazine"] = true,
		["Bandage"] = true,
		["Nightstick"] = true,
		["Tweezers"] = true,
		["Handcuff Keys"] = true,
	},
}

RegisterShop("MRPD_ARMORY", {
	Name = "MRPD Armory",
	Clerks = {
		{
			coords = vector4(480.6032409667969, -996.8204345703124, 30.68978500366211, 85.53340148925781),
		},
	},
	Storage = {
		Coords = vector3(436.5448, -972.5101, 30.71302),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})
RegisterShop("PARKR_ARMORY1", {
	Name = "Park Rangers Armory",
	Clerks = {
		{
			coords = vector4(378.8461, 797.6976, 190.4943, 181.9152),
		},
	},
	Storage = {
		Coords = vector3(379.5146, 799.4862, 190.4852),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("LAMESA_ARMORY", {
	Name = "La Mesa Armory",
	Clerks = {
		{
			coords = vector4(837.1766967773438, -1288.55224609375, 28.24493980407715, 169.6649169921875),
		},
	},
	Storage = {
		Coords = vector3(837.8157348632812, -1285.8883056640625, 29.44531440734863),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("DAVIS_ARMORY", {
	Name = "Davis PD Armory",
	Clerks = {
		{
			coords = vector4(364.4138488769531, -1603.8021240234375, 25.45170021057129, 35.37334442138672),
		},
	},
	Storage = {
		Coords = vector3(363.3371887207031, -1599.851806640625, 26.73055458068847),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("HIGHWAY_ARMORY", {
	Name = "Highway Station Armory",
	Clerks = {
		{
			coords = vector4(1549.9698486328125, 838.8912963867188, 77.651123046875, 148.10208129882812),
		},
	},
	Storage = {
		Coords = vector3(1550.1397705078125, 840.4849853515625, 78.92387390136719),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("SANDY_ARMORY", {
	Name = "SSO Armory",
	Clerks = {
		{
			coords = vector4(1859.8604736328127, 3690.26904296875, 34.26554107666015, 61.01738739013672),
		},
	},
	Storage = {
		Coords = vector3(1861.7762451171875, 3690.20361328125, 35.82775115966797),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("PALETO_ARMORY", {
	Name = "Paleto PD Armory",
	Clerks = {
		{
			coords = vector4(-445.8472595214844, 6014.7763671875, 36.99567794799805, 225.29714965820312),
		},
	},
	Storage = {
		Coords = vector3(-443.7860107421875, 6018.5244140625, 38.34590911865234),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("PRISON_ARMORY", {
	Name = "Prison Armory",
	Clerks = {
		{
			coords = vector4(1782.193, 2543.499, 45.79791, 272.444),
		},
	},
	Storage = {
		Coords = vector3(1778.812, 2542.241, 45.79791),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})