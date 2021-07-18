Main = {
	funcs = {},
}

--[[ Functions: Main ]]--
function Main:UpdateFrame()
	Ped = PlayerPedId()
	Player = PlayerId()

	self:UpdateMelee()

	-- Variables.
	-- local isArmedMelee = IsPedArmed(Ped, 1)
	-- local isArmedExplosives = IsPedArmed(Ped, 2)
	local isArmedOther = IsPedArmed(Ped, 4)

	-- Disable dispatch services.
	for service, toggle in pairs(Config.DispatchServices) do
		EnableDispatchService(service, toggle)
	end

	-- Disable unarmed attacks.
	if isArmedOther then
		for _, control in ipairs(Config.UnarmedDisabled) do
			DisableControlAction(0, control)
		end
	end

	-- Disable reticle.
	HideHudComponentThisFrame(14)

	-- Camera stuff.
	SetFollowPedCamThisUpdate("FOLLOW_PED_ON_EXILE1_LADDER_CAMERA", 0)

	local zoomMode = GetFollowPedCamViewMode(Ped)

	-- Anti combat roll/jump spam.
	local canJump = not self.lastJump or GetGameTimer() - self.lastJump > 4000

	if not canJump then
		DisableControlAction(0, 22)
	elseif IsControlJustPressed(0, 22) then
		if GetPedConfigFlag(Ped, 78) then
			TriggerEvent("roll")
		end

		self.lastJump = GetGameTimer()
	end

	-- Update ped.
	if self.ped ~= Ped then
		self.ped = Ped
		self:UpdatePed()
	end
end

function Main:UpdateSlow()
	Ped = PlayerPedId()
	Player = PlayerId()

	-- Turn friendly fire on.
	NetworkSetFriendlyFireOption(true)

	-- Disable idle camera.
	InvalidateIdleCam()
	InvalidateVehicleIdleCam()

	-- Reset wanted level.
	if GetPlayerWantedLevel(Player) ~= 0 then
		SetPlayerWantedLevel(Player, 0, false)
		SetPlayerWantedLevelNow(Player, false)
		SetMaxWantedLevel(0)
	end

	-- Disable action mode.
	if IsPedUsingActionMode(Ped) then
		SetPedUsingActionMode(Ped, false, -1, 0)
	end
end

function Main:UpdatePed()
	for flagId, value in pairs(Config.Flags) do
		SetPedConfigFlag(Ped, flagId, value)
	end
end

function Main:UpdateMelee()
	-- Update melee.
	if IsPedPerformingMeleeAction(Ped) then
		self.lastMelee = GetGameTimer()
	end

	-- Cooldown disable.
	local disableMelee = GetGameTimer() - (self.lastMelee or 0) < Config.Melee.Cooldown
	if disableMelee then
		DisablePlayerFiring(Player)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:UpdateFrame()

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdateSlow()

		Citizen.Wait(200)
	end
end)