AddNpc({
	name = "Bouncer",
	id = "TERRITORY_BOUNCER",
	coords = vector4(4.779600143432617, 219.453369140625, 107.61385345458984, 292.8753051757813),
	-- coords = vector4(423.8233642578125, -979.8137817382812, 30.71080780029297, 266.2473754882813),
	appearance = json.decode('{"makeupOverlays":[4,2,3,0,0,0,35,35,35,32,32,32],"hair":[140,0,6],"props":[4,1,1,1,1,1,1,1,1,1],"components":[1,1,103,1,1,1,113,15,182,111,12,1,1,1,1,1,1,1,1,1,1,1]}'),
	features = json.decode('{"overlays":[],"eyeColor":0,"otherOverlays":[1,1,1,1,1,1,0.18896675193231,0.00735024856576,0.11427237434617,0.00811838253267,0.93986320495605,0.635582447052,0.13508403301239],"bodyType":1,"hairOverlays":[2,1,1,0.0,1,1,0,1,1],"model":1,"faceFeatures":[-0.09090909090909,-0.81818181818181,-0.09090909090909,-0.09090909090909,-0.27272727272727,0.45454545454545,-0.81818181818181,0.45454545454545,-0.09090909090909,-0.63636363636363,-0.63636363636363,-0.63636363636363,0.09090909090909,-0.09090909090909,-0.09090909090909,-0.45454545454545,0.27272727272727,-0.45454545454545,-0.09090909090909,-0.27272727272727],"blendData":[21,45,1,21,45,1,0.45454545454545,0.27272727272727,0.0]}'),
	idle = {
		dict = "mp_corona@single_team",
		name = "single_team_loop_boss",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = "&lt;He stares at you.&gt;",
			condition = function(self)
				if exports.jobs:HasEmergency() then
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
						if exports.weapons:CarryingAnyWeapon() then
							self:Say("I feel something that I don't like. Get rid of it and come back.")
						else
							TriggerServerEvent("oldinstances:join", "territory_1")

							Citizen.Wait(4000)

							if exports.weapons:CarryingAnyWeapon() then
								exports.oldinstances:LeaveInstance(true)
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