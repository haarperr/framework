AddNpc({
	name = "Bouncer",
	id = "TERRITORY_BOUNCER",
	coords = vector4(4.779600143432617, 219.453369140625, 107.61385345458984, 292.8753051757813),
	-- coords = vector4(423.8233642578125, -979.8137817382812, 30.71080780029297, 266.2473754882813),
	model = "mp_m_freemode_01",
	data = json.decode('[1,20,44,5,3,[5,1,5,5,4,8,1,8,5,2,2,2,6,5,5,3,7,3,5,4],[[0,0.0,1],[0,0.0,1],[0,0.0,1],[9,0.13,1],[0,0.0,1,1],[0,0.0,1,1],[0,0.0,1],[0,0.0,1],[0,0.0,1,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[140,0,6,9],[180,0,1,1],[109,0,1,1],[0,0,1,1],[10,0,1,1],[102,0,1,1],[13,0,1,1],[0,0,1,1],[0,0,1,1],[111,0,1,1]],0,[[3,0],[0,0],[0,0],[],[],[],[0,0],[0,0]],[{"1":1},[],[]]]'),
	idle = {
		dict = "mp_corona@single_team",
		name = "single_team_loop_boss",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = "&lt;He stares at you.&gt;",
			condition = function(self)
				if exports.jobs:IsInEmergency() then
					return false, false, "Please leave."
				else
					return true
				end
			end,
			responses = {
				{
					text = "What is this place?",
					dialogue = "If you have to ask, then maybe you shouldn't be here.",
				},
				{
					text = "What are the rules?",
					dialogue = "There's no violence on the premises allowed. Including outside. We would wouldn't want to exile you.",
				},
				{
					text = "May I go in?",
					next = "FRISK",
				},
			},
		},
		["FRISK"] = {
			text = "You may, but I need to frisk you first.",
			responses = {
				{
					text = "Alright.",
					callback = function(self)
						if exports.weapons:HasAnyWeapon() then
							self:Say("I feel something that I don't like. Get rid of it and come back.")
						else
							TriggerServerEvent("instances:join", "territory_1")

							Citizen.Wait(4000)

							if exports.weapons:HasAnyWeapon() then
								exports.instances:LeaveInstance(true)
								exports.mythic_notify:SendAlert("inform", "Get out...", 7000)
							end
						end
					end,
				},
				"NEVERMIND",
			},
		},
	},
})