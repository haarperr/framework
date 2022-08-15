Config.Filters.Pharm = {
	item = {
		["Bandage"] = true,
        ["Saline"] = true,
        ["Gauze"] = true,
        ["Ice Pack"] = true,
        ["Surgical Kit"] = true,
        ["Cervical Collar"] = true,
        ["Nasopharyngeal Airway"] = true,
        ["Splint"] = true,
        ["IV Bag"] = true,
        ["Tranexamic Acid"] = true,
        ["Torniquet"] = true,
        ["Fire Blanket"] = true,
        ["Stun Gun"] = true,
		["Taser Cartridge"] = true,
        ["Taser Prong"] = true,
        ["Body Armor"] = true,
		["Radio"] = true,
	},
}

RegisterShop("MTZONAH_PHARM01", {
	Name = "Mount Zonah Pharmacy",
	License = "medical",
	Clerks = {
		{
			coords = vector4(-458.6107, -312.7249, 34.89975, 14.33093),
			model = "s_m_m_doctor_01",
		},
	},
	Storage = {
		Coords = vector3(-458.253, -311.8409, 34.91074),
		Radius = 2.0,
		Filters = Config.Filters.Pharm,
	},
})
