AddNpc({
	name = "Jerome",
	id = "TERRITORY_JEROME",
	-- coords = vector4(424.5179138183594, -977.2692260742188, 30.71025848388672, 224.87002563476565),
	coords = vector4(-1618.34619140625, -3013.450439453125, -75.20506286621094, 190.6402282714844),
	instance = "territory_1",
	model = "mp_m_freemode_01",
	data = json.decode('[1,43,13,6,8,[1,3,10,9,4,3,6,6,10,6,6,5,6,3,2,4,5,1,4,9],[[0,0.0,1],[0,0.0,1],[27,0.99,26],[11,0.69,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[0,0,1,1],[180,0,1,1],[109,0,1,1],[0,0,1,1],[10,0,1,1],[0,0,1,1],[13,0,1,1],[8,1,1,1],[0,0,1,1],[111,0,1,1]],0,[[176,4],[0,0],[0,0],[],[],[],[0,0],[0,0]],[{"1":1},[],[]]]'),
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