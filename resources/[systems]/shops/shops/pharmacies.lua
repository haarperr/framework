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
        ["Body Armor"] = true,
	},
}

RegisterShop("MTZONAH_PHARM1", {
	Name = "Mount Zonah Pharmacy",
	License = "Medical",
	Clerks = {
		{
			coords = vector4(-458.6107, -312.7249, 34.89975, 14.33093),
			model = "s_m_m_doctor_01",
		},
	},
	Storage = {
		Coords = vector3(-488.9996, -343.5237, 42.32084),
		Radius = 2.0,
		Filters = Config.Filters.Pharm,
	},
})
