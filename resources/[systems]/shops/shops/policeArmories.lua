Config.Filters.Armory = {
	item = {
		["Radio"] = true,
		["Body Armor"] = true,
		["Pistol 50"] = true,
		["Stun Gun"] = true,
		["Field Kit"] = true,
        ["Gunshot Residue Kit"] = true,
        ["Taser Cartridge"] = true,
		["Evidence Bag"] = true,
		["9mm Parabellum"] = true,
        ["Flashlight"] = true,
        ["Handcuffs"] = true,
        ["Heavy Armor"] = true,
        ["Ballistic Helmet"] = true,
        ["Pistol Mk II"] = true,
		["SNS Pistol Mk II"] = true,
		[".45 ACP Box"] = true,
		[".45 ACP"] = true,
        ["9mm Parabellum Box"] = true,
        ["9mm Magazine"] = true,
		[".45 Magazine"] = true,
		["Gauze"] = true,
		["Nightstick"] = true,
		["Tweezers"] = true,
		["Handcuff Keys"] = true,
		["Binoculars"] = true,
		["Bandage"] = true,
        ["Saline"] = true,
        ["Ice Pack"] = true,
		["Nasopharyngeal Airway"] = true,
        ["Splint"] = true,
        ["IV Bag"] = true,
        ["Tranexamic Acid"] = true,
        ["Torniquet"] = true,
        ["Fire Blanket"] = true,
		["Scissors"] = true,
	},
}

RegisterShop("MRPD_ARMORY001", {
	Name = "MRPD Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(480.6032409667969, -996.8204345703124, 30.68978500366211, 85.53340148925781),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(480.2994, -996.1855, 30.68495),
		Radius = 3.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("SAMS_ARMORY001", {
	Name = "SAMS Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(24.35694, -939.46, 29.90331, 24.46633),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(24.26934, -939.5259, 29.9025),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("PARKRA_ARMORY001", {
	Name = "Park Rangers Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(378.8461, 797.6976, 190.4943, 181.9152),
			model = "csb_cop",
		},
	},
	Storage = {
		Coords = vector3(379.5146, 799.4862, 190.4852),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("LAMESA_ARMORY001", {
	Name = "La Mesa Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(837.1766967773438, -1288.55224609375, 28.24493980407715, 169.6649169921875),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(837.8157348632812, -1285.8883056640625, 29.44531440734863),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("DAVIS_ARMORY001", {
	Name = "Davis PD Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(364.4138488769531, -1603.8021240234375, 25.45170021057129, 35.37334442138672),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(363.3371887207031, -1599.851806640625, 26.73055458068847),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("HIGHWAY_ARMORY001", {
	Name = "Highway Station Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(1549.9698486328125, 838.8912963867188, 77.651123046875, 148.10208129882812),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(1550.1397705078125, 840.4849853515625, 78.92387390136719),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("SANDY_ARMORY001", {
	Name = "SSO Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(1836.843, 3687.967, 34.18922, 208.3548),
			model = "s_f_y_sheriff_01",
		},
	},
	Storage = {
		Coords = vector3(1837.689, 3688.296, 34.18922),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("PALETO_ARMORY001", {
	Name = "Paleto PD Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(-445.8472595214844, 6014.7763671875, 36.99567794799805, 225.29714965820312),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(-443.7860107421875, 6018.5244140625, 38.34590911865234),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})

RegisterShop("PRISON_ARMORY001", {
	Name = "Prison Armory",
	License = "weapons",
	Clerks = {
		{
			coords = vector4(1782.193, 2543.499, 45.79791, 272.444),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(1778.812, 2542.241, 45.79791),
		Radius = 2.0,
		Filters = Config.Filters.Armory,
	},
})