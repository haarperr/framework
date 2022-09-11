local template = {
	interact = "Talk",
	animations = {
		idle = { Dict = "timetable@ron@ig_3_couch", Name = "base" },
	},
}

local thomas = {
	{
		id = "TERRITORY",
		coords = vector4(-1610.4593505859375, -3011.478271484375, -75.20503997802734, 189.7862243652344),
		instance = "territory_1",
		appearance = json.decode('{"makeupOverlays":[4,2,3,0,0,0,35,35,35,32,32,32],"components":[1,1,1,1,1,1,197,17,119,29,18,1,1,1,1,1,1,4,1,1,1,1],"props":[1,104,34,1,1,1,4,1,1,1],"hair":[149,0,60]}'),
		features = json.decode('{"eyeColor":0,"overlays":[],"hairOverlays":[11,1,1,0.61,1,1,12,1,1],"bodyType":1,"otherOverlays":[1,1,1,1,1,1,0.18896675193231,0.00735024856576,0.11427237434617,0.00811838253267,0.93986320495605,0.635582447052,0.13508403301239],"faceFeatures":[0.27272727272727,-0.81818181818181,0.81818181818181,-0.63636363636363,-0.45454545454545,0.27272727272727,-0.63636363636363,-0.09090909090909,0.45454545454545,-0.27272727272727,0.45454545454545,0.27272727272727,0.27272727272727,-0.45454545454545,-0.45454545454545,0.81818181818181,-0.27272727272727,0.63636363636363,0.81818181818181,-0.45454545454545],"model":1,"blendData":[7,3,1,7,3,1,0.81818181818181,0.81818181818181,0.0]}'),
	},
}

Citizen.CreateThread(function()
	while not Npcs do
		Citizen.Wait(0)
	end

	for _, info in ipairs(thomas) do
		for k, v in pairs(template) do
			info[k] = v
		end
		local npc = Npcs:Register(info)

		npc:AddOption({
			text = "Can we talk?",
			dialogue = "&lt;He stares at you.&gt;",
			callback = function(self, index, option)
				self.locked = true

				Citizen.Wait(GetRandomIntInRange(1000, 2000)) -- TODO: replace with server event to check and wait for response.

				self.locked = false

				if exports.jobs:HasEmergency() then
					self.locked = false
					self:AddDialogue("I think maybe you should leave.")

					self:GoHome()
				else
					self.locked = false
					self:AddDialogue("What do you want?")

					local function friskUser(self, index, option)
						if exports.weapons:CarryingAnyWeapon() then
							self:AddDialogue("I feel something that I don't like. Get rid of it and come back.")
							self:SetOptions({
								Npcs.NEVERMIND,
							})
						else
							Npcs:CloseWindow()

							Citizen.Wait(1500)

							TriggerServerEvent("oldinstances:join", "territory_1")

							Citizen.Wait(4000)

							if exports.weapons:CarryingAnyWeapon() then
								exports.instances:LeaveInstance(true)
								exports.mythic_notify:SendAlert("inform", "Get out...", 7000)
							end
						end
					end

					local function mustFrisk(self, index, option)
						self:AddDialogue("You may, but I need to frisk you first.")
						self:SetOptions({
							{
								text = "Okay.",
								callback = friskUser,
							},
							Npcs.NEVERMIND,
						})
					end

					self:SetOptions({
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
							callback = mustFrisk,
						},
						Npcs.NEVERMIND,
					})
				end
			end
		})
	end
end)