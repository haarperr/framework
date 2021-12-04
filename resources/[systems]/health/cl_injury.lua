Injury = {
	state = "None",
	override = "Writhes",
	options = {
		{
			id = "injury-passout",
			text = "Passout",
			icon = "healing",
			anim = "Deaths",
		},
		{
			id = "injury-writhe",
			text = "Writhe",
			icon = "personal_injury",
			anim = "Writhes",
		},
		{
			id = "injury-situp",
			text = "Sit Up",
			icon = "chair",
			anim = "Sit",
			func = function()
				return true
			end,
		},
	}
}

--[[ Functions: Injury ]]--
function Injury:Update()
	-- Get player state.
	local state = LocalPlayer.state or {}

	-- Get ped stuff.
	local isRestrained = state.restrained
	local inVehicle = IsPedInAnyVehicle(Ped)
	local inWater = IsEntityInWater(Ped)
	local isMoving = GetEntitySpeed(Ped) > 0.2
	local isRagdoll = IsPedRagdoll(Ped)

	-- Get health values.
	local health = Main.effects["Health"] or 1.0
	local isDead = health < 0.001

	-- Determine anim state.
	local animState = (
		(not isDead and "None") or
		(inVehicle and "Vehicle") or
		(inWater and "Water") or
		"Normal"
	)

	-- Update anim state.
	if animState ~= self.state then
		-- Get anim.
		local anim = Config.Anims[animState]

		-- Cache state.
		self.state = animState

		-- Additional states.
		if anim then
			-- Restrained variant.
			anim = anim[isRestrained and "Restrained" or "Normal"] or anim

			-- Overrides.
			if self.override then
				anim = anim[self.override] or anim
			end

			-- Random anims.
			if #anim > 0 then
				anim = anim[GetRandomIntInRange(1, #anim)]
			end
		end

		-- Set anim.
		self:SetAnim(anim)

		-- Other ped stuff.
		ClearPedTasks(Ped)
		SetPedCanRagdoll(Ped, not isDead or (isMoving and not inWater))
		SetBlockingOfNonTemporaryEvents(Ped, isDead)
	end

	-- Replay anim.
	if self.emote and not exports.emotes:IsPlaying(self.emote, true) and not inWater then
		self:SetAnim(self.anim)
	end

	-- Cache and set state.
	if self.isDead ~= isDead then
		self.isDead = isDead

		state:set("immobile", isDead, true)
	end
end

function Injury:UpdateFrame()
	if not self.isDead then return end

	-- Disable controls.
	for i = 0, 360 do
		if not Config.EnableControls[i] then
			DisableControlAction(0, i)
		end
	end

	-- Prevent getting up.
	if IsPedGettingUp(Ped) then
		ClearPedTasksImmediately(Ped)
	end

	-- Water up.
	if GetEntitySubmergedLevel(Ped) > 0.9 then
		SetEntityVelocity(Ped, 0.0, 0.0, 2.0)
	end
end

function Injury:SetAnim(anim)
	if self.emote then
		exports.emotes:Stop(self.emote, IsPedInAnyVehicle(Ped))
	end

	if anim then
		anim.Locked = true
	end

	print("set", json.encode(anim))
	
	self.anim = anim
	self.emote = anim and exports.emotes:Play(anim) or nil

	if not anim and not IsPedInAnyVehicle(Ped) and not IsEntityInWater(Ped) then
		exports.emotes:Play(Config.Anims.Revive)
	end
end

--[[ Listeners ]]--
Main:AddListener("BuildNavigation", function(options)
	if not Injury.isInjured then return end
	
	for k, option in ipairs(Injury.options) do
		if option.anim ~= Injury.name and (not option.func or option.func()) then
			options[#options + 1] = {
				id = option.id,
				text = option.text,
				icon = option.icon,
			}
		end
	end
end)

--[[ Events ]]--
AddEventHandler("health:stop", function()
	if Injury.isInjured then
		Injury:SetAnim()
	end
end)

AddEventHandler("interact:onNavigate", function(id)
	if id:sub(1, ("injury"):len()) ~= "injury" then
		return
	end
	for k, option in ipairs(Injury.options) do
		if option.id == id then
			-- TODO: set override.
			break
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Injury:Update()
		Citizen.Wait(400)
	end
end)

Citizen.CreateThread(function()
	while true do
		Injury:UpdateFrame()
		Citizen.Wait(0)
	end
end)