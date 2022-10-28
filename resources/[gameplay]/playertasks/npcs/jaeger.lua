AddNpc({
	name = "Jaeger",
	id = "TASKS_JAEGER",
	coords = vector4(30.76503562927246, -2667.8544921875, 12.04505538940429, 271.91156005859375),
	model = "cs_hunter",
	idle = {
		dict = "mp_corona@single_team",
		name = "single_team_loop_boss",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = { "Lookin' for work?", "INTRO" },
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
						print("A")

						local quest = Quests[Daily]
						if not quest then return true end
						print("B")
						
						quest = exports.quests:Get(quest.id)
						if not quest then return true end
						print("C")

						return not quest:Has()
					end,
					callback = function(self)
						TriggerServerEvent("playertasks:startDaily")
					end,
				},
				"NEVERMIND",
			},
		},
	},
})