AddNpc({
	name = "Thomas",
	id = "TERRITORY",
	-- coords = vector4(426.5736389160156, -976.3587036132812, 30.70977020263672, 172.5291290283203),
	coords = vector4(-1610.4593505859375, -3011.478271484375, -75.20503997802734, 189.7862243652344),
	instance = "territory_1",
	appearance = json.decode('{"makeupOverlays":[4,2,3,0,0,0,35,35,35,32,32,32],"components":[1,1,1,1,1,1,197,17,119,29,18,1,1,1,1,1,1,4,1,1,1,1],"props":[1,104,34,1,1,1,4,1,1,1],"hair":[149,0,60]}'),
	features = json.decode('{"eyeColor":0,"overlays":[],"hairOverlays":[11,1,1,0.61,1,1,12,1,1],"bodyType":1,"otherOverlays":[1,1,1,1,1,1,0.18896675193231,0.00735024856576,0.11427237434617,0.00811838253267,0.93986320495605,0.635582447052,0.13508403301239],"faceFeatures":[0.27272727272727,-0.81818181818181,0.81818181818181,-0.63636363636363,-0.45454545454545,0.27272727272727,-0.63636363636363,-0.09090909090909,0.45454545454545,-0.27272727272727,0.45454545454545,0.27272727272727,0.27272727272727,-0.45454545454545,-0.45454545454545,0.81818181818181,-0.27272727272727,0.63636363636363,0.81818181818181,-0.45454545454545],"model":1,"blendData":[7,3,1,7,3,1,0.81818181818181,0.81818181818181,0.0]}'),
	idle = {
		dict = "timetable@ron@ig_3_couch",
		name = "base",
	},
	stages = {
		["INIT"] = {
			text = "What do you want?",
			condition = function(self)
				if exports.jobs:HasEmergency() then
					return false, false, "You lookin' hella suspicious. I ain't talkin' to you."
				else
					return true
				end
			end,
			responses = {
				{
					text = "I'm looking for some territory.",
					next = "REGISTER",
					condition = function(self)
						return not IsInGang()
					end,
				},
				{
					text = "Let's discuss territories.",
					next = "TERRITORIES",
					condition = function(self)
						return IsInGang()
					end,
				},
				{
					text = "Tell me about the infamous gangs.",
					next = "INFAMY",
					condition = function(self)
						return IsInGang()
					end,
				},
				{
					text = "What info do you have on me?",
					callback = function(self)
						RequestStatus(function(data)
							local text = ("You are in <b>%s</b>."):format(data.faction)

							if data.members then
								text = text.."<br><br>You're the leader, and the members are:<br><span class='ordered'>"
								for k, v in ipairs(data.members) do
									text = text..("<span>• %s (%s)</span>"):format(v.name, v.character_id)
								end
								text = text.."</span>"
							end

							self:Say(text)
						end)
					end,
					condition = function(self)
						return IsInGang()
					end,
				},
				{
					text = "How do I earn or lose reputation?",
					next = "TUTORIAL",
					condition = function(self)
						return IsInGang()
					end,
				},
				{
					text = "I want to introduce somebody to you.",
					next = "ADD_MEMBER",
					condition = function(self)
						return IsGangLeader()
					end,
				},
				{
					text = "I want to kick a member.",
					next = "REMOVE_MEMBER",
					condition = function(self)
						return IsGangLeader()
					end,
				},
				{
					text = "I want to disband.",
					next = "DISBAND",
					condition = function(self)
						return IsGangLeader()
					end,
				},
				{
					text = "I want to leave.",
					next = "LEAVE",
					condition = function(self)
						return IsInGang() and not IsGangLeader()
					end,
				},
			},
		},
		["TERRITORIES"] = {
			text = "What would you like to discuss?",
			responses = {
				"NEVERMIND",
			},
			onInvoke = function(self)
				local sortedZones = {}
				for zone, settings in pairs(Config.Zones) do
					sortedZones[#sortedZones + 1] = { zone, GetLabelText(zone) }
				end
				table.sort(sortedZones, function(a, b)
					return a[2] < b[2]
				end)
				
				for k, v in ipairs(sortedZones) do
					local zone, name = table.unpack(v)
					local settings = Config.Zones[zone]
					if settings.Fallback == nil then
						self:AddResponse({
							text = "Tell me about "..name..".",
							callback = function(self)
								RequestStatus(function(data)
									CheckingStatus = data

									self:GotoStage("TERRITORY_STATUS")
									self:InvokeDialogue()
								end, zone)
							end,
						})
					end
				end
			end,
		},
		["TERRITORY_STATUS"] = {
			text = function(self)
				local faction = (GetGangFaction().fields or {}).name
				local zoneId = CheckingStatus.id
				local zone = CheckingStatus.zone
				local zoneSettings = Config.Zones[zoneId]

				local name = GetLabelText(zoneId)
				local groupCount = 0
				local affiliation = nil
				local control, controlRep = nil, 0.0

				for _faction, reputation in pairs(zone) do
					groupCount = groupCount + 1
					if _faction == faction then
						affiliation = reputation
					end
					if reputation > Config.Reputation.ControlAt and reputation > controlRep then
						control = _faction
						controlRep = reputation
					end
				end

				local interest
				if groupCount > 0 then
					interest = tostring(groupCount).." groups"
				else
					interest = "nobody"
				end
				
				local suffix = ""
				if affiliation then
					local symbols, color = GetReputationExtra(affiliation)
					suffix = (" (<span style='color: %s'>%s</span>)"):format(color, symbols)
				end
				local text = name..suffix..", which is a "..zoneSettings.Type:lower().." territory, currently has the interest of "..interest.."."

				if affiliation then
					if faction == control then
						text = text.."<br><br>You currently have prevalence, as well."
					elseif affiliation > Config.Reputation.ControlAt then
						text = text.."<br><br>Somebody else is prevalent, however."
					end
				end

				return text
			end,
			responses = {
				{
					text = "I want to make this our target.",
					next = "CLAIM",
					condition = function(self)
						return IsGangLeader()
					end,
				},
				{
					text = "I'd like to discuss something else.",
					next = "TERRITORIES",
				}
			}
		},
		["INFAMY"] = {
			text = "We are sat calm in the peace of darkness. Often, however, we must battle in the dark to find some light. There's only so much light to lead us all. If I find groups are stealing too much light for themselves, then they may enjoy the wrath of desolation.<br><br>Ehem... in short- if you have garnered too much negative reputation overall, then you're causing issues for me. If you're causing issues for me, then I'll cause issues for you.",
			responses = {
				"NEVERMIND",
			},
			onInvoke = function(self)
				RequestStatus(function(data)
					for name, total in pairs(data) do
						local symbols, color = GetReputationExtra(total)
						suffix = (" (<span style='color: %s'>%s</span>)"):format(color, symbols)

						self:AddResponse({
							text = "Tell me about "..name..".",
							dialogue = name.." is infamous."..suffix,
						})
					end
				end, "infamy")
			end,
		},
		["CLAIM"] = {
			text = "Are you sure? You will lose your positive reputation in other territories.",
			responses = {
				{
					text = "Yes.",
					callback = function(self)
						TriggerServerEvent("territories:changePrimary", CheckingStatus.id)
					end,
				},
				{
					text = "No.",
					next = "TERRITORY_STATUS",
				},
			}
		},
		["REGISTER"] = {
			text = "Interested in establishing yourself, huh? I'll tell you what. Talk to the man in charge and get a voucher.",
			responses = {
				{
					text = "I have the items.",
					next = "REGISTER_FINISH",
					condition = function(self)
						for item, amount in pairs(Config.Quests.Register.Items) do
							if exports.inventory:CountItem(item) < amount then
								return false
							end
						end
						return true
					end,
				},
				"NEVERMIND",
			},
		},
		["REGISTER_FINISH"] = {
			text = "Well done. What do you want to call yourselves?",
			responses = {
				"NEVERMIND",
			},
			onChange = function(self)
				local name, nameInput

				nameInput = function(message)
					local isNameValid
					isNameValid, name = CheckName(message)
					
					if isNameValid then
						Registering = name

						self:GotoStage("REGISTER_CONFIRM")
						self:InvokeDialogue()
					else
						self:Say("I don't understand...")
						self:Input(nameInput)
					end
				end

				self:Input(nameInput)
			end,
		},
		["REGISTER_CONFIRM"] = {
			text = function(self)
				return ("\"%s\", am I hearing that right?"):format(Registering)
			end,
			responses = {
				{
					text = "Yes.",
					callback = function(self)
						TriggerServerEvent("territories:register", Registering)
					end,
				},
				{
					text = "No.",
					dialogue = "I must have heard you wrong. What did you want to be called?",
					next = "REGISTER_FINISH",
				},
			},
		},
		["ADD_MEMBER"] = {
			text = function(self)
				return "Them? Are you sure you want to add ["..tostring(Inviting).."]?"
			end,
			condition = function(self)
				Inviting = exports.oldutils:GetNearestPlayer(5.0)
				if Inviting == 0 then
					return false, true, "I don't see anybody with you..."
				end
				return true
			end,
			responses = {
				{
					text = "Yes.",
					callback = function(self)
						print(Inviting)
						TriggerServerEvent("territories:invite", Inviting)
					end,
				},
				"NEVERMIND",
			},
		},
		["REMOVE_MEMBER"] = {
			text = "Who do you want gone?",
			responses = {
				"NEVERMIND",
			},
			onChange = function(self)
				self:Input(function(message)
					message = tonumber(message)
					if message then
						TriggerServerEvent("territories:kick", message)
					else
						self:Say("What are you trying to say? I need the number that I gave you with their name.")
						self:GotoStage("REMOVE_MEMBER")
					end
				end)
			end,
		},
		["DISBAND"] = {
			text = "Are you sure you want to disband? Tell me the name of your group to confirm.",
			responses = {
				"NEVERMIND",
			},
			onChange = function(self)
				self:Input(function(message)
					local faction = GetGangFaction()
					local name = (faction.fields or {}).name

					if message:lower() == name:lower() then
						TriggerServerEvent("territories:leave")
					else
						self:GotoStage("INIT")
						self:Say("Nevermind then.")
					end
				end)
			end,
		},
		["LEAVE"] = {
			text = "Are you sure you want to leave your group?",
			responses = {
				{
					text = "Yes.",
					callback = function(self)
						TriggerServerEvent("territories:leave")
					end,
				},
				{
					text = "No.",
					next = "INIT",
					dialogue = "Nevermind, then."
				},
			},
		},
		["TUTORIAL"] = {
			text = [[
				That depends. Different areas, people, and their expectations must be taken into consideration. The... less fortunate areas... are a little easier to appease. We shall call them "turf." While the more fortunate, whether it be in wealth or strong comradery, are a bit harder to earn the favor of. Those are the "communities."
				<br><br>
				The best way to appease the people is to appeal to them. Speak to the residents and offer a helping hand. Jerome might be able to help you a little more with that. He's watching the security cameras behind you if you want to speak to him.
			]],
			responses = {
				"NEVERMIND",
				{
					text = "Tell me about communities.",
					dialogue = "To communities, you're nobody. The question is: how do you fit yourself into their clique? Force yourself into it, but don't be obvious about it. Communities are probably the most fickle when it comes to anything. It depends on the area, but a lot of them hate drugs. Some of them love it. They typically hate guns and violence, opposed to turf, even brandishing will throw them into a fit. They might understand if you shoot in self-defense, but not if you're using class 2 weapons.",
				},
				{
					text = "Tell me about turfs.",
					dialogue = "If you're looking for a turf, don't expect to be discreet. Their populations are typically the easiest to read and influence. It's not hard to sell a drug addiction, and nobody will bat an eye when you do. Of course, nobody likes shooting, but they appreciate the defense when somebody else is causing problems. Same goes for brandishing: they feel safer when your weapons are drawn, but become timid when they're aimed.",
				},
			},
		},
	},
})