Config = {
	Quests = {
		Register = {
			Items = {
				["Voucher"] = 1,
			}
		}
	},
	Weapons = {
		[970310034] = 2, -- Assault Rifle.
		[416676503] = 1, -- Handguns.
		[2725924767] = 2, -- Heavy Weapon.
		[1159398588] = 2, -- Light Machine Gun.
		[2685387236] = 0, -- Melee.
		[4257178988] = 0, -- Misc.
		[860033945] = 2, -- Shotgun.
		[3082541095] = 2, -- Sniper.
		[3337201093] = 2, -- Submachine Gun.
		[1548507267] = 0, -- Throwable.
	},
	Reputation = {
		Cooldown = 5.0,
		ControlAt = 10.0,
		Infamy = -5.0,
	},
	Types = {
		["Gang"] = {
			
		},
		["Community"] = {

		},
	},
	Zones = {
		["BEACH"] = { Fallback = "VESP" }, -- Vespucci Beach.
		["CHAMH"] = { Type = "Gang", Color = 27, Coords = vector3(-120.76901245117188, -1535.637939453125, 36.10380554199219), Radius = 200.0 }, -- Chamberlain Hills.
		["CHIL"] = { Type = "Community" }, -- Vinewood Hills.
		["CHU"] = { Type = "Community" }, -- Chumash.
		["CYPRE"] = { Type = "Community" }, -- Cypress Flats.
		["DAVIS"] = { Type = "Gang", Color = 25 }, -- Davis.
		["MAC"] = { Type = "Gang", Color = 72, Coords = vector3(275.8959655761719, -1550.3687744140625, 29.341594696044925), Radius = 200.0, Name = "Macdonald" }, -- Macdonald.
		["DELBE"] = { Fallback = "VESP" }, -- Del Perro Beach.
		["DELPE"] = { Fallback = "VESP" }, -- Del Perro.
		["DTVINE"] = { Type = "Community" }, -- Downtown Vinewood.
		["EAST_V"] = { Type = "Gang", Color = 75, Coords = vector3(1000.5669555664064, -117.00440979003906, 73.98900604248047), Radius = 125.0 }, -- East Vinewood.
		["EBURO"] = { Type = "Gang", Color = 75, Coords = vector3(1258.982177734375, -1683.3140869140625, 45.8569564819336), Radius = 200.0 }, -- El Burro Heights.
		["GALFISH"] = { Type = "Gang", Color = 75 }, -- Galilee.
		["HARMO"] = { Type = "Community" }, -- Harmony.
		["KOREAT"] = { Type = "Gang", Color = 75, Coords = vector3(-623.513671875, -932.5188598632812, 22.459247589111328), Radius = 200.0 }, -- Little Seoul.
		["MIRR"] = { Type = "Community" }, -- Mirror Park.
		["MORN"] = { Type = "Community" }, -- Morningwood.
		["PALETO"] = { Type = "Community" }, -- Paleto Bay.
		["RANCHO"] = { Type = "Gang", Color = 46 }, -- Rancho.
		["RICHM"] = { Type = "Community" }, -- Richman.
		["ROCKF"] = { Type = "Community" }, -- Rockford Hills.
		["SANDY"] = { Type = "Community" }, -- Sandy Shores.
		["SLAB"] = { Type = "Gang", Color = 75, Coords = vector3(60.15562057495117, 3700.555908203125, 39.8385009765625), Radius = 200.0 }, -- Stab City.
		["STRAW"] = { Type = "Gang", Color = 48 }, -- Strawberry.
		["VCANA"] = { Fallback = "VESP" }, -- Vespucci Canals.
		["VESP"] = { Type = "Community" }, -- Vespucci.
		["WVINE"] = { Type = "Community" }, -- West Vinewood.
		["GRAPES"] = { Type = "Community", Coords = vector3(1863.6739501953127, 4848.64501953125, 45.53164672851562), Radius = 350.0 }, -- Grapeseed.
	},
	Labs = {
		Types = {
			["WEAPON"] = {
				Coords = vector4(996.92431640625, -3200.6821289063, -36.393730163574, 269.40762329102),
			},
			["FORGE"] = {
				Coords = vector4(1173.7132568359, -3196.5947265625, -39.007987976074, 90.79810333252),
			},
			["DRUG"] = {
				Coords = vector4(1088.7271728516, -3187.5910644531, -38.993476867676, 179.19236755371),
			},
			["GROW"] = {
				Coords = vector4(1066.3129882813, -3183.3771972656, -39.16349029541, 92.385810852051),
			},
		},
		Locations = {
			{
				Zone = "CHAMH",
				Type = "DRUG",
				Instance = "t_chamh1",
				Coords = vector4(-197.7569274902344, -1699.82470703125, 33.484249114990234, 37.90886306762695),
				Revival = vector3(427.8741149902344, -974.4700927734376, 30.70996856689453),
			},
			{
				Zone = "CHIL",
				Type = "WEAPON",
				Instance = "t_chil1",
				Coords = vector4(780.7457275390625, 1296.8330078125, 361.3618469238281, 270.5789794921875),
			},
			{
				Zone = "CHU",
				Type = "FORGE",
				Instance = "t_chu1",
				Coords = vector4(-3149.4775390625, 1043.4949951171875, 20.686750411987305, 245.58123779296875),
			},
			{
				Zone = "CYPRE",
				Type = "FORGE",
				Instance = "t_cypre1",
				Coords = vector4(806.1619262695312, -2380.78662109375, 29.09770393371582, 82.07010650634766),
			},
			{
				Zone = "DAVIS",
				Type = "FORGE",
				Instance = "t_davis1",
				Coords = vector4(116.7958526611328, -1990.2109375, 18.40419197082519, 337.9661560058594),
			},
			{
				Zone = "MAC",
				Type = "GROW",
				Instance = "t_mac1",
				Coords = vector4(146.64881896972656, -1644.306640625, 29.4751033782959, 123.37609100341795),
			},
			{
				Zone = "DTVINE",
				Type = "GROW",
				Instance = "t_dtvine1",
				Coords = vector4(581.1705932617188, 139.05535888671875, 99.47477722167967, 158.66876220703125),
			},
			{
				Zone = "EASTV",
				Type = "FORGE",
				Instance = "t_eastv1",
				Coords = vector4(871.6438598632812, -158.16705322265625, 78.3403091430664, 326.62939453125),
			},
			{
				Zone = "EBURO",
				Type = "DRUG",
				Instance = "t_eburo1",
				Coords = vector4(1441.2713623046875, -1669.0823974609375, 66.64537811279297, 113.99232482910156),
			},
			{
				Zone = "GALFISH",
				Type = "GROW",
				Instance = "t_galfish1",
				Coords = vector4(1308.9200439453125, 4362.1171875, 41.54622268676758, 71.2686996459961),
			},
			{
				Zone = "HARMO",
				Type = "WEAPON",
				Instance = "t_harmo1",
				Coords = vector4(591.8631591796875, 2782.635498046875, 43.48118209838867, 1.0657048225402832),
			},
			{
				Zone = "KOREAT",
				Type = "GROW",
				Instance = "t_koreat1",
				Coords = vector4(-690.986328125, -1155.5570068359375, 10.812644004821777, 131.0283966064453),
			},
			{
				Zone = "MIRR",
				Type = "WEAPON",
				Instance = "t_mirr1",
				Coords = vector4(1131.5224609375, -454.3440856933594, 66.48649597167969, 73.1792221069336),
			},
			{
				Zone = "MORN",
				Type = "GROW",
				Instance = "t_morn1",
				Coords = vector4(-1370.2147216796875, -324.6269836425781, 39.25997924804688, 118.0980453491211),
			},
			{
				Zone = "PALETO",
				Type = "DRUG",
				Instance = "t_paleto1",
				Coords = vector4(-29.959732055664062, 6458.03759765625, 31.457565307617188, 224.97805786132812),
			},
			{
				Zone = "RANCHO",
				Type = "WEAPON",
				Instance = "t_rancho1",
				Coords = vector4(460.0614013671875, -1869.8555908203127, 26.97677993774414, 222.7998809814453),
			},
			{
				Zone = "RICHM",
				Type = "GROW",
				Instance = "t_richm1",
				Coords = vector4(-1724.4935302734375, 234.20542907714844, 58.47171401977539, 23.512638092041016),
			},
			{
				Zone = "ROCKF",
				Type = "FORGE",
				Instance = "t_rockf1",
				Coords = vector4(-1328.17138671875, -237.76748657226565, 42.70354843139649, 301.6998291015625),
			},
			{
				Zone = "SANDY",
				Type = "DRUG",
				Instance = "t_sandy1",
				Coords = vector4(1536.96484375, 3797.234130859375, 34.451324462890625, 20.97075653076172),
			},
			{
				Zone = "SLAB",
				Type = "DRUG",
				Instance = "t_slab1",
				Coords = vector4(13.274357795715332, 3732.19970703125, 39.67777633666992, 345.7344360351563),
			},
			{
				Zone = "STRAW",
				Type = "WEAPON",
				Instance = "t_straw1",
				Coords = vector4(366.5815124511719, -1250.5068359375, 32.50911712646485, 316.6795043945313),
			},
			{
				Zone = "VESP",
				Type = "DRUG",
				Instance = "t_vesp1",
				Coords = vector4(-1519.5206298828125, -893.9198608398438, 13.68464469909668, 318.4120178222656),
			},
			{
				Zone = "WVINE",
				Type = "FORGE",
				Instance = "t_wvine1",
				Coords = vector4(-53.055320739746094, 79.30472564697266, 71.6160888671875, 334.7234191894531),
			},
			{
				Zone = "EAST_V",
				Type = "FORGE",
				Instance = "t_eastv1",
				Coords = vector4(1005.7230224609376, -114.6909637451172, 73.9734878540039, 149.4705810546875),
			},
			{
				Zone = "GRAPES",
				Type = "DRUG",
				Instance = "t_grapes1",
				Coords = vector4(1639.58154296875, 4879.38671875, 42.14072799682617, 282.6084594726563),
			},
		}
	},
	Instances = {
		{
			id = "territory_1",
			outCoords = vector4(4.137566566467285, 220.41030883789065, 107.7463150024414, 68.41716003417969),
			-- outCoords = vector4(423.9320983886719, -978.7457275390624, 30.710580825805664, 266.2480163574219),
			inCoords = vector4(-1569.4666748046875, -3017.457275390625, -74.40607452392578, 358.1445922851563),
		},
	},
}
