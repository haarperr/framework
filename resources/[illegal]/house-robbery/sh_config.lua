Config ={
	Item = "Lockpick",
	LockTime = 3.0, -- How long before a property locks itself, in minutes.
	Time = { 22, 5 },
	Lockpicking = {
		Action = {
			Duration = 60000,
			Label = "Lockpicking...",
			UseWhileDead = false,
			CanCancel = true,
			Disarm = true,
			Anim = {
				Flag = 17,
				Dict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@crowbar@fidgets@a",
				Name = "fidget_low_loop",
				DisableMovement = true,
			},
		},
	},
	Properties = {
		["house"] = {
			Tasks = {
				{ "Robbery", vector4(-4.016316413879395, 200.175048828125, -99.19622802734376, 87.89713287353516) },
				{ "Robbery", vector4(-3.495914220809937, 194.05247497558597, -99.19622802734376, 178.83628845214844) },
				{ "Robbery", vector4(-0.1001778095960617, 194.19029235839844, -99.19622802734376, 178.86302185058597) },
				{ "Robbery", vector4(2.0257527828216553, 202.18450927734375, -99.19622802734376, 269.7495727539063) },
				{ "Robbery", vector4(8.42758560180664, 198.2181854248047, -99.1962432861328, 179.7458648681641) },
				{ "Robbery", vector4(7.891497611999512, 203.47140502929688, -99.19622802734376, 359.3304748535156) },
			},
			Peds = {
				{
					Chance = 1.0,
					Model = { "u_m_y_abner", "a_m_m_beach_02" },
					Coords = vector4(-1.3836398124694824, 202.7845001220703, -99.1961898803711, 177.12069702148438),
					Sleeping = true,
					Anim = {
						Dict = "amb@world_human_bum_slumped@male@laying_on_right_side@idle_a",
						Name = "idle_a",
						Flag = 129,
					},
				},
				{
					Chance = 0.2,
					Model = { "u_m_y_abner", "a_m_m_beach_02" },
					Coords = vector4(6.663024425506592, 201.33721923828128, -99.19622802734376, 259.43377685546875),
					Sleeping = true,
					Anim = {
						Dict = "amb@world_human_bum_slumped@male@laying_on_right_side@idle_a",
						Name = "idle_a",
						Flag = 129,
					},
				},
				{
					Chance = 0.05,
					Model = "u_m_m_jesus_01",
					Coords = vector4(-3.0079689025878906, 204.0733184814453, -99.1961898803711, 1.7056368589401245),
					Anim = {
						Dict = "amb@code_human_police_crowd_control@idle_a",
						Name = "idle_a",
						Flag = 129,
					},
				},
				{
					Chance = 0.2,
					Model = { "s_f_m_maid_01", "s_f_m_sweatshop_01", "a_f_m_bevhills_01" },
					Coords = vector4(1.2375526428222656, 194.6522216796875, -99.1961898803711, 270.036865234375),
					Anim = {
						Dict = "amb@prop_human_bbq@male@idle_a",
						Name = "idle_b",
						Flag = 1,
					},
				},
				-- {
				-- 	Chance = 0.5,
				-- 	Model = { "a_f_y_beach_01", "a_m_m_beach_02" },
				-- 	Coords = vector4(347.1211242675781, -995.359619140625, -99.11188507080078, 119.57894134521484),
				-- 	Anim = {
				-- 		Dict = "mp_safehouseshower@female@",
				-- 		Name = "shower_idle_a",
				-- 		Flag = 1
				-- 	},
				-- },
			},
		},
		-- ["mansion"] = {

		-- },
	},
}