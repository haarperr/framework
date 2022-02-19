Config.Groups = {
	{
		name = "Prison",
		coords = vector3(1767.4293212890625, 2546.900146484375, 45.55982971191406),
		radius = 500,
		locked = true,
		factions = { "dps", "paramedic", "firefighter", "lspd", "judge", "doc", "parole", "lsda", "doctor", "sasp", "bcso", "sams" },
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
	},
	{
		name = "Sandy PD & Hospital",
		coords = vector3(1843.6820068359375, 3685.4541015625, 34.26052856445312),
		radius = 260,
		locked = true,
		factions = { "lspd", "paramedic", "firefighter", "judge", "doc", "parole", "lsda", "doctor", "dps", "sd-staff", "sasp", "bcso", "sams" },
		overrides = {
			{ coords = vector3(1828.6787109375, 3691.4052734375, 34.27360534667969), locked = false }, -- Rear Double Medical Doors
		},
	},
	{
		name = "Pillbox",
		coords = vector3(321.57473754883, -583.23687744141, 43.279979705811),
		radius = 50,
		locked = true,
		factions = { "dps", "paramedic", "firefighter", "lspd", "judge", "doc", "parole", "lsda", "doctor", "hospital", "sasp", "bcso", "sams" },
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
	},
	{
		name = "Paleto Medical",
		coords = vector3(-256.3061828613281, 6317.18212890625, 32.42717361450195),
		radius = 100,
		locked = true,
		factions = { "dps", "paramedic", "firefighter", "lspd", "judge", "doc", "parole", "lsda", "doctor", "hospital", "sasp", "bcso", "sams" },
		overrides = {
			{ coords = vector3(-249.84161376953128, 6331.81640625, 32.5875015258789), locked = false }, -- Front to reception.
			{ coords = vector3(-255.3900909423828, 6321.27685546875, 32.46699142456055), locked = false }, -- Beds area.
			{ coords = vector3(-251.98960876464844, 6323.37451171875, 32.46699142456055), locked = false }, -- Waiting room to hallway.
			{ coords = vector3(-253.17071533203128, 6328.53271484375, 32.46699142456055), locked = false }, -- Waiting room to reception.
		},
	},
	{
		name = "Davis Firestation",
		coords = vector3(205.33511352539065, -1651.591796875, 29.80309295654297),
		radius = 25,
		locked = true,
		factions = { "dps", "paramedic", "firefighter", "lspd", "judge", "doc", "parole", "lsda", "doctor", "hospital", "sasp", "bcso" },
	},
	{
		name = "Capital Blvd Firestation",
		coords = vector3(1200.7562255859375, -1474.0010986328125, 34.85939407348633),
		radius = 25,
		locked = true,
		factions = { "dps", "paramedic", "firefighter", "lspd", "judge", "doc", "parole", "lsda", "doctor", "hospital", "sasp", "bcso" },
	},
	{
		name = "City Hall",
		coords = vector3(-549.9605102539062, -195.8555908203125, 38.22295379638672),
		radius = 50,
		locked = true,
		factions = { "judge", "lsda", "lspd", "bcso", "dps", "doc", "parole", "sasp", "paramedic", "firefighter" },
		overrides = {
			{ coords = vector3(-529.7550048828125, -183.2404937744141, 38.34344100952148), ignore = true },
			{ coords = vector3(-531.0458374023438, -180.98399353027344, 38.34344100952148), ignore = true },
			{ coords = vector3(-550.7864379882812, -183.2413024902344, 38.34754180908203), ignore = true },
			{ coords = vector3(-569.098388671875, -216.0363922119141, 38.35443878173828), ignore = true },
			{ coords = vector3(-571.3546142578125, -217.31919860839844, 38.35443878173828), ignore = true },
			{ coords = vector3(-544.3212890625, -187.4945068359375, 47.54306030273437), ignore = true },
			{ coords = vector3(-546.5814208984375, -188.77850341796875, 47.54306030273437), ignore = true },
			{ coords = vector3(-536.7028198242188, -187.28829956054688, 47.54306030273437), ignore = true },
			{ coords = vector3(-537.9937133789062, -185.03179931640625, 47.54306030273437), ignore = true },
		},
	},
	{
		name = "Courthouse",
		coords = vector3(234.555908203125, -418.3627014160156, 48.09120559692383),
		radius = 80,
		locked = true,
		factions = { "judge", "lsda", "lspd", "dps", "doc", "parole", "sasp", "bcso", "sams", "paramedic", "firefighter" },
	},
	{
		name = "MRPD",
		coords = vector3(449.9324035644531, -987.0167236328124, 29.5869255065918),
		radius = 60,
		locked = true,
		factions = { "lspd", "paramedic", "firefighter", "judge", "doc", "parole", "lsda", "doctor", "dps", "pd-staff", "sasp", "bcso", "sams" },
	},
	{
		name = "Paleto PD",
		coords = vector3(-441.0958251953125, 6005.5146484375, 31.71618270874023),
		radius = 30,
		locked = true,
		factions = { "lspd", "paramedic", "firefighter", "judge", "doc", "parole", "lsda", "doctor", "dps", "sd-staff", "sasp", "bcso", "sams" },
	},
	{
		name = "Highway PD",
		coords = vector3(1546.182861328125, 823.8367919921875, 86.44590759277344),
		radius = 80,
		locked = true,
		factions = { "lspd", "paramedic", "firefighter", "judge", "doc", "parole", "lsda", "doctor", "dps", "pd-staff", "sasp", "bcso", "sams" },
		overrides = {
			{ coords = vector3(1553.8079833984375, 830.4913940429688, 77.81657409667969), ignore = true },
		},
	},
	{
		name = "Chumash PD",
		coords = vector3(-3149.261962890625, 1129.031005859375, 20.79466247558593),
		radius = 50,
		locked = true,
		factions = { "lspd", "paramedic", "firefighter", "judge", "doc", "parole", "lsda", "doctor", "dps", "pd-staff", "sasp", "bcso", "sams" },
	},
	{
		name = "Davis PD",
		coords = vector3(368.6966247558594, -1592.2149658203125, 36.94865036010742),
		radius = 60,
		locked = true,
		factions = { "lspd", "paramedic", "firefighter", "judge", "doc", "parole", "lsda", "doctor", "dps", "pd-staff", "sasp", "bcso", "sams" },
	},
	{
		name = "Cayo Villa",
		coords = vector3(5028.58544921875, -5748.40185546875, 16.28327369689941),
		radius = 250,
		locked = true,
		factions = { "cartel" },
	},
	{
		name = "Cayo Hanger",
		coords = vector3(4472.3759765625, -4512.6494140625, 4.18709707260131),
		radius = 600,
		locked = true,
		factions = { "cartel" },
	},
	{
		name = "Cayo Main Docks",
		coords = vector3(4933.88720703125, -5202.65576171875, 2.4674265384674),
		radius = 300,
		locked = true,
		factions = { "cartel" },
	},
	{
		name = "Cayo Main Checkpoint",
		coords = vector3(5145.69189453125, -4950.6552734375, 14.24116706848144),
		radius = 20,
		locked = true,
		factions = { "cartel" },
	},
	{
		name = "Cayo Cove",
		coords = vector3(4953.65380859375, -4891.39697265625, 4.60661840438842),
		radius = 300,
		locked = true,
		factions = { "cartel" },
	},
	{
		name = "Weed",
		coords = vector3(168.0943145751953, -228.05804443359375, 54.22780609130859),
		radius = 50,
		locked = true,
		factions = { "weed" },
	},
	{
		name = "Bail Bonds",
		coords = vector3(2468.856201171875, 4093.64990234375, 38.06180191040039),
		radius = 30,
		locked = true,
		factions = { "bailbonds" },
	},
	{
		name = "PDM",
		coords = vector3(-45.38729476928711, -1104.2705078125, 26.42233085632324),
		radius = 50,
		locked = true,
		factions = { "pdm" },
		overrides = {
			{ coords = vector3(-37.49523544311523, -1108.7884521484375, 26.64494132995605), locked = false },
			{ coords = vector3(-38.98845291137695, -1108.2642822265625, 26.69929313659668), locked = false },
			{ coords = vector3(-60.45976638793945, -1094.5400390625, 26.79322242736816), locked = false },
			{ coords = vector3(-59.99090957641601, -1093.1563720703125, 26.85989570617675), locked = false },
		},
	},
	{
		name = "Taco",
		coords = vector3(13.02145957946777, -1601.5521240234375, 29.37517166137695),
		radius = 50,
		locked = true,
		factions = { "taco" },
	},
	{
		name = "Luchettis",
		coords = vector3(294.1844177246094, -978.3340454101564, 29.43342590332031),
		radius = 40,
		locked = true,
		factions = { "luchettis" },
	},
	{
		name = "Pearls",
		coords = vector3(-1830.8314208984375, -1192.3887939453125, 14.33295345306396),
		radius = 60,
		locked = true,
		factions = { "pearls" },
	},
	{
		name = "Blushy Bunnies",
		coords = vector3(-307.6798400878906, 206.97915649414065, 87.87068939208984),
		radius = 60,
		locked = true,
		factions = { "blushys" },
	},
	{
		name = "Split Side",
		coords = vector3(-436.6955871582031, 272.52587890625, 83.41837310791016),
		radius = 60,
		locked = true,
		factions = { "splitside" },
	},
	{
		name = "Vanilla Unicorn",
		coords = vector3(125.34671020507812, -1292.195068359375, 35.00981903076172),
		radius = 60,
		locked = true,
		factions = { "unicorn" },
	},
	{
		name = "Burger Shot",
		coords = vector3(-1189.469482421875, -897.002685546875, 13.99527359008789),
		radius = 60,
		locked = true,
		factions = { "burger" },
		overrides = {
			{ coords = vector3(-1178.6585693359375, -892.2357788085938, 15.03763484954834), ignore = true },
		},
	},
	{
		name = "Bahama Mamas",
		coords = vector3(-1391.3526611328125, -605.0252075195312, 30.31958198547363),
		radius = 60,
		locked = true,
		factions = { "bahama" },
	},
	{
		name = "Yellowjack",
		coords = vector3(1995.3673095703127, 3047.844482421875, 49.5181999206543),
		radius = 45,
		locked = true,
		factions = { "yellowjack" },
	},
	{
		name = "SAMS Office",
		coords = vector3(-72.85314178466797, -816.87841796875, 243.38592529296875),
		radius = 30,
		locked = true,
		factions = { "sams" },
	},
}