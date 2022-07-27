Config = {
	Interact = {
		Radius = 1.0,
		Text = "Access Account",
	},
	Blips = {
		Bank = { id = 272, scale = 1.0, name = "Bank" },
	},
	BankTypes = {
		[1] = { Name = "Fleeca" },
		[2] = { Name = "Pacific Standard Bank" },
		[3] = { Name = "Blaine County Savings Bank" },
		[4] = { Name = "Maze Bank" },
		[5] = { Name = "Union Depository" },
	},
	AccountTypes = {
		[1] = { Name = "Checkings Account" },
		[2] = { Name = "Savings Account" },
		[3] = { Name = "Buisness Account" },
	},
	TransactionTypes = {
		[1] = { Name = "Withdrawl" },
		[2] = { Name = "Deposit" },
		[3] = { Name = "Transfer" },
	},
	Banks = {
		{ Coords = vector3(313.65426635742, -278.70379638672, 54.17077255249), Type = 1 }, -- Alta.
		{ Coords = vector3(149.19615173339844, -1040.4674072265625, 29.37408065795898), Type = 1 }, -- Pillbox Hill.
		{ Coords = vector3(-351.5462341308594, -49.6784782409668, 49.04257202148437), Type = 1 }, -- Burton.
		{ Coords = vector3(-1213.20751953125, -331.00091552734375, 37.78706741333008), Type = 1 }, -- Rockford Hills.
		{ Coords = vector3(-2962.61572265625, 482.3385314941406, 15.70310020446777), Type = 1 }, -- Great Ocean Highway.
		{ Coords = vector3(1175.334228515625, 2706.80322265625, 38.09403991699219), Type = 1 }, -- Grand Senora Desert.
		{ Coords = vector3(242.2916717529297, 224.9676513671875, 106.28681182861328), Type = 2, NoBlip = true }, -- Pacific Standard, Left.
		{ Coords = vector3(247.53799438476565, 223.1694793701172, 106.28672790527344), Type = 2 }, -- Pacific Standard, Middle.
		{ Coords = vector3(252.59483337402344, 221.3118896484375, 106.28655242919922), Type = 2, NoBlip = true }, -- Pacific Standard, Right.
		{ Coords = vector3(-112.47180175781, 6468.8686523438, 31.626718521118), Type = 3 }, -- Paleto Bay.
	},
	Desks = {
		{ Coords = vector3(253.9940185546875, 208.68099975585935, 106.73992919921876), Radius = 1.0 },
		{ Coords = vector3(248.67971801757812, 210.72677612304688, 106.4713897705078), Radius = 1.0 },
	},
	Cards = {
		Item = "Debit Card",
		Price = 100,
	},
	Coins = {
		{ Name = "Penny", OneDollar = 100 },
		{ Name = "Nickel", OneDollar = 20 },
		{ Name = "Dime", OneDollar = 10 },
		{ Name = "Quarter", OneDollar = 4 },
	},
	Atms = {
		{ Model = "prop_atm_01", Type = 2 },
		{ Model = "prop_atm_02", Type = 2 },
		{ Model = "prop_atm_03", Type = 4 },
		{ Model = "prop_fleeca_atm", Type = 1 },
	},
}
