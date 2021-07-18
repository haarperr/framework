Citizen.CreateThread(function()
	exports.npcs:Add({
		name = "Girl",
		id = "ERP",
		coords = vector4(-575.849853515625, 239.10169982910156, 82.6587142944336, 353.0852355957031),
		-- instance = "territory_1",
		model = "mp_f_freemode_01",
		data = json.decode('[1,45,25,5,8,[8,4,4,2,3,6,5,6,8,7,2,5,7,3,6,6,6,6,6,6],[[0,0.0],[0,0.0],[1,0.98,1],[0,0.0],[35,0.98,56,6],[1,0.57,6,6],[0,0.0],[0,0.0],[1,0.97,56,56],[0,0.0],[0,0.0,1],[0,0.0],[0,0.0]],[[0,0],[0,0],[118,0,35,29],[0,0],[162,1],[0,0],[110,0],[105,2],[136,1],[0,0],[0,0],[271,3]],30,[[0,0],[0,0],[0,0],[],[],[],[0,0],[0,0]],[[],[],[]]]'),
		idle = {
			dict = "amb@world_human_prostitute@hooker@idle_a",
			name = "idle_a",
			flag = 1,
		},
		stages = {
			["INIT"] = {
				text = "Welcome to The Lust Resort. Adults only.",
				responses = {
					{
						text = "I would like to enter...",
						next = "ENTER",
					},
				},
			},
			["ENTER"] = {
				text = "<div style='color: red'>You are about to enter an NSFW area. You agree that you are not streaming, that you are 18 years or older, and consent to being exposed to the sexually explicit content inside.</div>",
				responses = {
					{
						text = "I agree.",
						callback = function()
							TriggerServerEvent("erp:enter")
						end,
					},
					"NEVERMIND",
				},
			}
		},
	})
	
	exports.npcs:Add({
		id = "ERP_DANCER1",
		coords = vector4(-1596.032958984375, -3008.02392578125, -78.2110595703125, 168.2655792236328),
		instance = Config.Instance,
		model = "u_f_y_dancerave_01",
		idle = {
			dict = "mini@strip_club@private_dance@part1",
			name = "priv_dance_p1",
			flag = 1,
		},
	})
	
	exports.npcs:Add({
		id = "ERP_DANCER2",
		coords = vector4(-1598.3636474609375, -3015.74609375, -78.21113586425781, 331.712646484375),
		instance = Config.Instance,
		model = "u_f_y_danceburl_01",
		idle = {
			dict = "mini@strip_club@private_dance@part1",
			name = "priv_dance_p1",
			flag = 1,
		},
	})
	
	exports.npcs:Add({
		id = "ERP_GIRL1",
		coords = vector4(-1597.4307861328125, -3004.8826171875, -76.0049819946289, 172.7886199951172),
		instance = Config.Instance,
		model = "mp_f_freemode_01",
		data = json.decode('[1,25,45,5,6,[6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6],[[0,0.0,1],[0,0.0,3],[2,0.96,1],[0,0.0,1],[2,0.71,56,1],[1,0.52,21,1],[0,0.0,1],[0,0.0,1],[4,0.94,21,52],[0,0.0,1],[0,0.36,3],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[1,1,58,1],[15,0,1,1],[101,2,1,1],[0,0,1,1],[119,0,1,1],[0,0,1,1],[16,0,1,1],[0,0,1,1],[0,0,1,1],[16,0,1,1]],0,[[0,0],[0,0],[16,0],[],[],[],[0,0],[0,0]]]'),
		idle = {
			dict = "misscarsteal2pimpsex",
			name = "shagloop_hooker",
			flag = 1,
		},
	})

	exports.npcs:Add({
		id = "ERP_GUY1",
		coords = vector4(-1597.42041015625, -3005.2595703125, -76.0049819946289, 14.475600242614746),
		instance = Config.Instance,
		model = "mp_m_freemode_01",
		data = json.decode('[1,25,0,8,9,[3,3,7,4,6,9,1,4,6,10,6,9,2,10,6,3,5,4,9,4],[[0,0.0,1],[0,0.02,1],[16,0.99,8],[0,0.0,1],[0,0.07,1,1],[0,0.0,1,1],[0,0.0,1],[0,0.0,1],[0,0.0,1,52],[0,0.92,1],[0,0.0,1],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[13,0,7,1],[15,0,1,1],[145,4,1,1],[0,0,1,1],[118,0,1,1],[0,0,1,1],[15,0,1,1],[0,0,1,1],[0,0,1,1],[15,0,1,1]],0,[[0,0],[3,0],[0,0],[],[],[],[0,0],[0,0]],[[],[],[]]]'),
		idle = {
			dict = "misscarsteal2pimpsex",
			name = "shagloop_pimp",
			flag = 1,
		},
	})

	exports.npcs:Add({
		id = "ERP_GIRL2",
		coords = vector4(-1585.7557373046875, -3013.18798828125, -75.1913833618164 - 0.62, 0.8602731823921204),
		instance = Config.Instance,
		model = "mp_f_freemode_01",
		data = json.decode('[1,21,45,5,6,[6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6],[[0,0.0,1],[0,0.0,3],[2,0.96,1],[0,0.0,1],[2,0.71,56,1],[1,0.52,24,1],[0,0.0,1],[0,0.0,1],[3,0.58,22,1],[0,0.0,1],[0,0.36,3],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[4,0,38,1],[15,0,1,1],[101,0,1,1],[0,0,1,1],[119,0,1,1],[0,0,1,1],[16,0,1,1],[0,0,1,1],[0,0,1,1],[16,0,1,1]],0,[[0,0],[0,0],[16,0],[],[],[],[0,0],[0,0]]]'),
		idle = {
			dict = "timetable@amanda@ig_6",
			name = "ig_6_base",
			flag = 1,
		},
	})
end)