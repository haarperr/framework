Config = {
	Filters = {},
	Shops = {},
	Tax = 0.07,
}

function RegisterShop(id, data)
	Config.Shops[id] = data
end