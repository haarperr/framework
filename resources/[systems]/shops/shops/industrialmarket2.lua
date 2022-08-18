Config.Filters.Supplier2 = {
	item = {
		["Mango"] = true,
        ["Pineapple"] = true,
        ["Strawberry"] = true,
        ["Popsicle"] = true,
        ["Iced Tea"] = true,
        ["Ice"] = true,
        ["Peach"] = true,
        ["Sugar"] = true,
        ["Lime"] = true,
        ["Watermelon"] = true,
        ["Cream of Tartar"] = true,
        ["Orange Soda"] = true,
        ["Plain Ice Cream"] = true,
        ["Flour"] = true,
        ["Yeast"] = true,
        ["Honey"] = true, 
        ["Blueberry"] = true,
        ["Milk"] = true,
        ["Egg"] = true,
        ["Butter"] = true,
        ["Salt"] = true,
        ["Whiskey"] = true,
        ["Cherry Juice"] = true, 
        ["Raw Beef"] = true,
	},
}

RegisterShop("SUPP2_001", {
    Name = "Market Supplier",
    Factions = {
		["beanies"] = "restaurant",
		["burgershot"] = "restaurant",
		["sugarspice"] = "restaurant",
		["beanmachine"] = "restaurant",
	},
    Clerks = {
        {
            coords = vector4(-303.5894, 6116.102, 31.49935, 31.80476),
            model = "s_f_m_sweatshop_01",
        },
    },
    Storage = {
        Coords = vector3(-303.5894, 6116.102, 31.49935),
        Radius = 2.0,
        Filters = Config.Filters.Supplier2,
    },
})
