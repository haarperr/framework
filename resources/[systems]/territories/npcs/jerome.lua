AddNpc({
	name = "Jerome",
	id = "TERRITORY_JEROME",
	-- coords = vector4(424.5179138183594, -977.2692260742188, 30.71025848388672, 224.87002563476565),
	coords = vector4(-1618.34619140625, -3013.450439453125, -75.20506286621094, 190.6402282714844),
	instance = "territory_1",
	appearance = json.decode('{"hair":[0,0,1],"props":[177,1,1,1,1,5,1,1,1,1],"makeupOverlays":[4,2,3,0,0,0,35,35,35,32,32,32],"components":[1,1,1,1,1,9,113,15,182,111,12,1,1,1,1,1,2,1,1,1,1,1]}'),
	features = json.decode('{"overlays":[],"otherOverlays":[1,1,1,1,1,1,0.18896675193231,0.00735024856576,0.11427237434617,0.00811838253267,0.93986320495605,0.635582447052,0.13508403301239],"model":1,"hairOverlays":[2,1,1,0.0,1,1,27,1,1],"eyeColor":0,"blendData":[44,14,1,44,14,1,0.54545454545454,0.72727272727272,0.0],"faceFeatures":[-0.81818181818181,-0.45454545454545,0.81818181818181,0.63636363636363,-0.27272727272727,-0.45454545454545,0.09090909090909,0.09090909090909,0.81818181818181,0.09090909090909,0.09090909090909,-0.09090909090909,0.09090909090909,-0.45454545454545,-0.63636363636363,-0.27272727272727,-0.09090909090909,-0.81818181818181,-0.27272727272727,0.63636363636363],"bodyType":1}'),
	idle = {
		dict = "mp_corona@single_team",
		name = "single_team_loop_boss",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = { "Looking to lend a hand?", "INTRO" },
			condition = function(self)
				if IsInGang() then
					return true
				else
					return false, false, { "I don't know you.", "REJECT" }
				end
			end,
			onInvoke = function(self)
				RequestStatus(function(data)
					if not data then return end
					Daily = data.character

					if data.character then
						local quest = Quests[Daily]

						self:Set("stages.QUEST.text", quest.objectiveText)
						self:AddResponse({
							text = "What do you need help with?",
							next = "QUEST",
						})

						return
					end

					self:Say("Thanks for the help. I have nothing else for you.")
				end, "dailies")
			end,
		},
		["QUEST"] = {
			text = "",
			responses = {
				{
					text = "Sure.",
					condition = function(self)
						if not Daily then return true end

						local quest = Quests[Daily]
						if not quest then return true end
						
						quest = exports.quests:Get(quest.id)
						if not quest then return true end

						return not quest:Has()
					end,
					callback = function(self)
						TriggerServerEvent("territories:startDaily")
					end,
				},
				"NEVERMIND",
			},
		},
	},
})