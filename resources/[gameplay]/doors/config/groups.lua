Config.Groups = {
	{
		name = "Prison",
		coords = vector3(1694.419, 2581.424, 51.70069),
		radius = 200,
		locked = true,
		overrides = {
			{ coords = vector3(1845.197998046875, 2585.239990234375, 46.09928894042969), locked = false }, -- Enterance.
			{ coords = vector3(1835.5213623046875, 2587.24609375, 46.25360107421875), locked = false }, -- Visitation.
			{ coords = vector3(1773.402587890625, 2569.47314453125, 45.69263076782226), ignore = true }, -- Double door next to Infirmary (L).
			{ coords = vector3(1773.44775390625, 2567.537353515625, 45.75871276855469), ignore = true }, -- Double door next to Infirmary (R).
			{ coords = vector3(1757.5650634765625, 2499.326904296875, 45.88970565795898), ignore = true }, -- Hallway to Nothing (L).
			{ coords = vector3(1754.3360595703125, 2497.71044921875, 45.83632659912109), ignore = true }, -- Hallway to Nothing (R).
			{ coords = vector3(1776.159912109375, 2552.3916015625, 45.57792282104492), locked = false }, -- Cafeteria door to yard.
			{ coords = vector3(1786.6405029296875, 2560.291259765625, 46.00416946411133), locked = false }, -- Cafeteria to Kitchen.
			{ coords = vector3(1838.0828857421875, 2572.031494140625, 46.39877319335937), locked = false }, -- Changing room to Bathroom.
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Sandy",
		coords = vector3(1843.6820068359375, 3685.4541015625, 34.26052856445312),
		radius = 50,
		locked = true,
		overrides = {
			{ coords = vector3(1835.127, 3673.418, 34.33901), locked = false },
			{ coords = vector3(1837.378, 3674.718, 34.33901), locked = false },
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	--[[{
		name = "Pillbox",
		coords = vector3(321.57473754883, -583.23687744141, 43.279979705811),
		radius = 50,
		locked = true,
		overrides = {
			{ coords = vector3(305.22186279296875, -582.3056030273438, 43.43391036987305), locked = false }, -- Main to Ward A (Double).
			{ coords = vector3(324.23602294921875, -589.2261962890625, 43.43391036987305), locked = false }, -- Main to Ward B (Double).
			{ coords = vector3(326.5498962402344, -578.0406494140625, 43.43391036987305), locked = false }, -- Ward A to Ward B (Double).
			{ coords = vector3(349.3137512207031, -586.3259887695312, 43.43391036987305), locked = false }, -- Ward B to Ward C (Double).
			{ coords = vector3(318.4846801757813, -579.2281494140625, 43.43391036987305), locked = false }, -- Intense Care (Double).
			{ coords = vector3(328.7010803222656, -587.3118896484375, 43.43391036987305), locked = false }, -- Bathroom.
			{ coords = vector3(328.9761657714844, -586.5975341796875, 43.43391036987305), locked = false }, -- Bathroom.
			{ coords = vector3(331.8989562988281, -568.1724243164062, 43.43391036987305), ignore = true }, -- Ward B Exit (L).
			{ coords = vector3(334.3179321289063, -569.0528564453125, 43.43391036987305), ignore = true }, -- Ward B Exit (R).
			{ coords = vector3(310.9024353027344, -602.540283203125, 43.43391036987305), ignore = true }, -- Break Room.
			{ coords = vector3(303.90869140625, -596.5780029296875, 43.43391036987305), locked = false }, -- Break Room to Cloakroom.
			{ coords = vector3(353.322265625, -579.1442260742188, 44.14674377441406), locked = false }, -- ICU.
			{ coords = vector3(351.4538269042969, -583.239501953125, 44.08108139038086), locked = false }, -- ICU.
			{ coords = vector3(299.4701232910156, -584.7398071289062, 43.26084899902344), locked = false }, -- Entrance (Double)
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},]]
	{
		name = "Mount Zonah",
		coords = vector3(-473.7684, -321.2826, 55.3812),
		radius = 70,
		locked = false,
		overrides = {
			{ coords = vector3(-440.6439, -321.7954, 35.06683), locked = true }, -- Reception
			{ coords = vector3(-442.589, -317.0564, 35.06619), locked = true }, -- Cloakroom
			{ coords = vector3(-451.4746, -309.0658, 35.06632), locked = true }, -- Closet/Store
			{ coords = vector3(-453.0472, -291.5856, 35.06544), locked = true }, -- MRI
			{ coords = vector3(-449.6572, -299.8383, 35.07071), locked = true }, -- Diagnostics
			{ coords = vector3(-447.3418, -305.4991, 35.07071), locked = true }, -- Xray
			{ coords = vector3(-499.2977, -325.1406, 42.46983), locked = true }, -- Office Entrance
			{ coords = vector3(-501.8895, -325.3537, 42.46983), locked = true }, -- Office Entrance
			{ coords = vector3(-496.5722, -338.9931, 69.67925), locked = true }, -- Upstairs Reception
			{ coords = vector3(-500.3457, -336.4971, 69.67925), locked = true }, -- Upstairs Office
			{ coords = vector3(-500.4143, -324.591, 69.67925), locked = true }, -- Upstairs Office
			{ coords = vector3(-501.9976, -312.5578, 69.67925), locked = true }, -- Upstairs Office
			{ coords = vector3(-502.8185, -302.2071, 69.67925), locked = true }, -- Upstairs Office
			{ coords = vector3(-445.4108, -320.6565, 69.67925), locked = true }, -- Upstairs Ward
			{ coords = vector3(-443.0081, -319.6809, 69.67925), locked = true }, -- Upstairs Ward
			{ coords = vector3(-446.4914, -341.6063, 78.47864), locked = true }, -- Helipad Broken Doors that drop you off map
			{ coords = vector3(-443.9187, -341.9425, 78.47864), locked = true }, -- Helipad Broken Doors that drop you off map
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Paleto Medical",
		coords = vector3(-254.7769, 6320.646, 32.43077),
		radius = 25,
		locked = true,
		overrides = {
			{ coords = vector3(-249.84161376953128, 6331.81640625, 32.5875015258789), locked = false }, -- Front to reception.
			{ coords = vector3(-255.3900909423828, 6321.27685546875, 32.46699142456055), locked = false }, -- Beds area.
			{ coords = vector3(-251.98960876464844, 6323.37451171875, 32.46699142456055), locked = false }, -- Waiting room to hallway.
			{ coords = vector3(-253.17071533203128, 6328.53271484375, 32.46699142456055), locked = false }, -- Waiting room to reception.
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Davis Firestation",
		coords = vector3(205.33511352539065, -1651.591796875, 29.80309295654297),
		radius = 30,
		locked = false,
		overrides = {
			{ coords = vector3(199.2920379638672, -1634.4873046875, 29.02260017395019), locked = true },
			{ coords = vector3(201.8855438232422, -1643.5914306640625, 28.79732513427734), locked = true },
			{ coords = vector3(200.4056854248047, -1645.355224609375, 28.79732513427734), locked = true },
			{ coords = vector3(213.99725341796875, -1653.7640380859375, 28.79732513427734), locked = true },
			{ coords = vector3(211.8350830078125, -1656.341796875, 28.79732513427734), locked = true },
			{ coords = vector3(204.11105346679688, -1654.8232421875, 29.95660018920898), locked = true },
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Capital Blvd Firestation",
		coords = vector3(1200.7562255859375, -1474.0010986328125, 34.85939407348633),
		radius = 30,
		locked = false,
		overrides = {
			{ coords = vector3(1185.0029296875, -1464.6861572265625, 34.07891082763672), locked = true },
			{ coords = vector3(1192.8416748046875, -1469.9932861328125, 33.85363388061523), locked = true },
			{ coords = vector3(1192.841796875, -1472.295654296875, 33.85363388061523), locked = true },
			{ coords = vector3(1208.6585693359375, -1470.000732421875, 33.85363388061523), locked = true },
			{ coords = vector3(1201.76611328125, -1477.1668701171875, 35.01290893554687), locked = true },
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "City Hall",
		coords = vector3(-550.3980102539062, -194.9214324951172, 38.22687149047851),
		radius = 60,
		locked = true,
		overrides = {
			{ coords = vector3(-546.5196533203125, -203.91189575195312, 38.42063903808594), locked = false },
			{ coords = vector3(-544.558349609375, -202.7798309326172, 38.42063903808594), locked = false },
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "DOJ Offices",
		coords = vector3(25.32975959777832, -920.0698852539064, 29.90266036987304),
		radius = 40,
		locked = true,
		factions = {
			["court"] = "federal",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "MRPD",
		coords = vector3(449.9324035644531, -987.0167236328124, 29.5869255065918),
		radius = 60,
		locked = true,
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "La Mesa",
		coords = vector3(848.5468, -1295.054, 28.24491),
		radius = 30,
		locked = true,
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Paleto PD",
		coords = vector3(-467.6436, 6003.471, 31.30809),
		radius = 50,
		locked = true,
		overrides = {
			{ coords = vector3(-451.2013244628906, 5994.7265625, 36.99581527709961), ignore = true },
			{ coords = vector3(-453.5218505859375, 5997.0830078125, 36.99581527709961), ignore = true },
		},
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Davis PD",
		coords = vector3(372.3197, -1601.038, 30.05141),
		radius = 35,
		locked = true,
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Park Ranger Station",
		coords = vector3(382.855224609375, 797.1598510742188, 190.4902496337891),
		radius = 25,
		locked = true,
		factions = {
			["lspd"] = "pd",
			["bcso"] = "pd",
			["sasp"] = "pd",
			["doc"] = "pd",
			["doj"] = "federal",
			["lsda"] = "federal",
			["opr"] = "federal",
			["saag"] = "federal",
			["sams"] = "federal",
			["sapr"] = "federal",
			["paramedic"] = "ems",
			["firefighter"] = "ems",
			["lsms"] = "ems",
		},
	},
	{
		name = "Tuner Meetup",
		coords = vector3(953.0521850585938, -1698.287353515625, 29.75150108337402),
		radius = 20,
		locked = true,
		factions = { "staffteam" },
	},
	{
		name = "High Times",
		coords = vector3(168.0943145751953, -228.05804443359375, 54.22780609130859),
		radius = 50,
		locked = true,
		factions = {
			["hightimes"] = "general",
		},
	},
	{
		name = "PDM",
		coords = vector3(-45.38729476928711, -1104.2705078125, 26.42233085632324),
		radius = 50,
		locked = false,
		factions = {
			["pdm"] = "dealership",
		},
		overrides = {
			{ coords = vector3(-30.42845916748047, -1102.47021484375, 27.42458724975586), locked = true },
			{ coords = vector3(-32.64266967773437, -1108.5592041015625, 27.42458724975586), locked = true },
		},
	},
	{
		name = "Malone and Sons",
		coords = vector3(-782.8184814453125, -1031.5516357421875, 20.13966560363769),
		radius = 50,
		locked = true,
		factions = {
			["maloneandsons"] = "dealership",
		},
		overrides = {
			{ coords = vector3(-774.6541137695312, -1042.2266845703125, 20.29215812683105), locked = false },
		},
	},
	{
		name = "Power Autos",
		coords = vector3(-35.50202941894531, -1043.854736328125, 28.5906867980957),
		radius = 10,
		locked = true,
		factions = {
			["powerautos"] = "mechanic",
		},
	},
	{
		name = "Route 68",
		coords = vector3(1178.876220703125, 2639.72607421875, 37.75382614135742),
		radius = 10,
		locked = true,
		factions = {
			["route68"] = "mechanic",
		},
	},
	{
		name = "Misfits",
		coords = vector3(941.6403, -969.2, 39.53661),
		radius = 25,
		locked = true,
		factions = {
			["misfits"] = "mechanic",
		},
	},
	{
		name = "Axles",
		coords = vector3(539.7577514648438, -183.5513153076172, 54.4866714477539),
		radius = 30,
		locked = true,
		factions = {
			["axles"] = "mechanic",
		},
		overrides = {
			{ coords = vector3(534.4030151367188, -166.29489135742188, 54.77276611328125), locked = true },
			{ coords = vector3(534.4017333984375, -166.29856872558597, 50.98633193969726), locked = true },
			{ coords = vector3(540.9420166015625, -195.96514892578128, 54.88402557373047), locked = true },
			{ coords = vector3(545.216552734375, -194.2509765625, 54.64054870605469), locked = true },
			{ coords = vector3(552.0873, -193.4602, 54.88621), locked = true },
		},
	},
	{
		name = "Beanie's",
		coords = vector3(-579.5952758789062, -1057.732421875, 22.34420013427734),
		radius = 20,
		locked = true,
		factions = {
			["beanies"] = "restaurant",
		},
		overrides = {
			{ coords = vector3(-570.6216430664062, -1053.2105712890625, 22.41300582885742), locked = false },
			{ coords = vector3(-570.6235961914062, -1055.215576171875, 22.41300582885742), locked = false },
		},
	},
	{
		name = "Burger Shot",
		coords = vector3(-1189.469482421875, -897.002685546875, 13.99527359008789),
		radius = 60,
		locked = true,
		factions = {
			["burgershot"] = "restaurant",
		},
		overrides = {
			{ coords = vector3(-1178.6585693359375, -892.2357788085938, 15.03763484954834), ignore = true },
		},
	},
	{
		name = "Pearls",
		coords = vector3(-1830.8314208984375, -1192.3887939453125, 14.33295345306396),
		radius = 60,
		locked = true,
		factions = {
			["pearls"] = "restaurant",
		},
	},
	{
		name = "Sugar & Spice",
		coords = vector3(1118.416259765625, -645.8768920898438, 56.81786346435547),
		radius = 15,
		locked = true,
		factions = {
			["sugarspice"] = "restaurant",
		},
	},
	{
		name = "Bahama Mamas",
		coords = vector3(-1391.3526611328125, -605.0252075195312, 30.31958198547363),
		radius = 60,
		locked = true,
		factions = {
			["bahamamamas"] = "nightclub",
		},
	},
	{
		name = "Vanilla Unicorn",
		coords = vector3(117.3445, -1293.967, 29.27564),
		radius = 30,
		locked = true,
		factions = {
			["vanillaunicorn"] = "nightclub",
		},
	},
	{
		name = "Yellowjack",
		coords = vector3(1995.3673095703127, 3047.844482421875, 49.5181999206543),
		radius = 45,
		locked = true,
		factions = {
			["yellowjack"] = "nightclub",
		},
	},
	{
		name = "Pawn Shop",
		coords = vector3(170.5313, -1315.49, 29.36363),
		radius = 18,
		locked = true,
		factions = {
			["pawnshop"] = "general",
		},
	},
	{
		name = "Chicken Factory",
		coords = vector3(-69.75774, 6254.107, 31.09011),
		radius = 18,
		locked = true, 
		factions = {
			["odin"] = "farm",
		},
	},
}
