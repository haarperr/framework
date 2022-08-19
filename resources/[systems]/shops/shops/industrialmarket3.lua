Config.Filters.Supplier3 = {
	item = {
        ["Cake Flour"] = true,
        ["Baking Soda"] = true,
        ["Cheddar Cheese"] = true,
        ["Breakfast Muffin"] = true,
        ["Roll"] = true,
        ["White Vinegar"] = true,
        ["BBQ Sauce"] = true,
        ["Pork"] = true,
        ["Garlic Butter"] = true,
        ["Fizzy Water"] = true,
        ["Beef"] = true,
        ["Potatoes"] = true,
        ["Tomato"] = true,
        ["Carrot"] = true,
        ["Raw Chicken"] = true,
        ["Thyme"] = true,
        ["Sage"] = true,
        ["Rosemary"] = true,
        ["Turkey Spices"] = true,
        ["Bread"] = true,
        ["Shredded Cheese"] = true,
        ["Egg Whites"] = true,
        ["Vanilla Extract"] = true,
        ["Food Coloring"] = true,
        ["Coffee Grounds"] = true,
        ["Orange"] = true,
	},
}

RegisterShop("SUPP3_01", {
    Name = "Market Supplier",
    Factions = {
		["beanies"] = "restaurant",
		["burgershot"] = "restaurant",
		["sugarspice"] = "restaurant",
		["beanmachine"] = "restaurant",
	},
    Clerks = {
        {
            coords = vector4(-314.3562, 6118.892, 31.82176, 236.0881),
            model = "mp_m_shopkeep_01",
        },
    },
    Storage = {
        Coords = vector3(-314.3562, 6118.892, 31.82176),
        Radius = 2.0,
        Filters = Config.Filters.Supplier3,
    },
})
