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
        ["Body Armor"] = true,
	},
}

RegisterShop("MTZONAH_PHARM", {
	Name = "Mount Zonah Pharmacy",
	Clerks = {
		{
			coords = vector4(-492.1134, -342.5998, 42.32042, 350.0087),
		},
	},
	Storage = {
		Coords = vector3(-488.9996, -343.5237, 42.32084),
		Radius = 2.0,
		Filters = Config.Filters.Pharm,
	},
})
