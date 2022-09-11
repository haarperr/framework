local template = {
	interact = "Talk",
	animations = {
		idle = { Dict = "mp_corona@single_team", Name = "single_team_loop_boss", Flag = 1 },
	},
}

local npcs = {
	{
		id = "TERRITORY_BOUNCER",
		coords = vector4(4.779600143432617, 219.453369140625, 107.61385345458984, 292.8753051757813),
		appearance = json.decode('{"makeupOverlays":[1,1,1,0,0,0,35,35,35,32,32,32],"hair":[4,0,1],"components":[1,144,1,1,1,1,1,17,19,162,22,1,1,1,1,1,1,1,1,1,5,2],"props":[54,9,105,2,1,7,1,2,1,1]}'),
		features = json.decode('{"overlays":[-173288591,-240234547,1593302778,-240234547,-1529401172,1529191571,2088037441,1529191571,-1565431690,1529191571,-1268397497,598190139,-1502257606,1529191571,826974918,1529191571,-546150284,1529191571,-1757770003,598190139],"hairOverlays":[3,14,1,0.99,1,1,4,1,1],"bodyType":1,"model":1,"otherOverlays":[1,1,1,1,1,1,0.18896675193231,0.00735024856576,0.11427237434617,0.00811838253267,0.93986320495605,0.635582447052,0.13508403301239],"eyeColor":3,"faceFeatures":[0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909,0.09090909090909],"blendData":[13,1,1,13,1,1,0.09090909090909,0.09090909090909,0.0]}'),
	},
}

Citizen.CreateThread(function()
	while not Npcs do
		Citizen.Wait(0)
	end

	for _, info in ipairs(npcs) do
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

				if exports.jobs:IsInEmergency() then
					self.locked = false
					self:AddDialogue("I think maybe you should leave.")

					self:GoHome()
				else
					self.locked = false
					self:AddDialogue("What do you want?")

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

					local function friskUser(self, index, option)
						if exports.weapons:CarryingAnyWeapon() then
							self:AddDialogue("I feel something that I don't like. Get rid of it and come back.")
							self:GoHome()
						else
							TriggerServerEvent("instances:join", "territory_1")

							Citizen.Wait(4000)

							if exports.weapons:CarryingAnyWeapon() then
								exports.instances:LeaveInstance(true)
								exports.mythic_notify:SendAlert("inform", "Get out...", 7000)
							end
						end
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
						}
						Npcs.NEVERMIND,
					})
				end
			end
		})
	end
end)