Effects = { Thirst = 0.0, Hunger = 0.0 }
NextShake = 0
Affliction = 0.0

local lastBac = 0.0
local wasInVehicle = false
local notified = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	local lastUpdate = GetGameTimer()
	local interval = 1000.0
	-- local interval = 60000.0

	while true do
		Affliction = 0.0
		
		while IsPedDead(PlayerPedId()) or GetPlayerInvincible(PlayerId()) do
			lastUpdate = GetGameTimer()
			Citizen.Wait(1000)
		end
		
		local shouldUpdate = false
		local delta = (GetGameTimer() - lastUpdate) / 1000.0
		local notified = false
		
		for effect, settings in pairs(Config.Effects) do
			local value = Effects[effect] or 0.0
			if settings.Passive and ((settings.Passive > 0.0 and value < (settings.Max or 1.0)) or (settings.Passive < 0.0 and value > (settings.Min or 0.0))) then
				local amount = settings.Passive * delta
				if settings.Modifier then
					amount = _G[settings.Modifier](amount)
				end
				AddEffect(effect, amount)
			end
			if settings.Damage and value >= (settings.DamageAt or 1.0) then
				local damage, bone, weapon = table.unpack(settings.Damage)
				damage = math.ceil(damage * delta)

				TakeDamage(damage, bone, weapon)
			end
			if settings.Afflict and value >= settings.Afflict then
				local intensity = (value - settings.Afflict) / (settings.Max - settings.Afflict)
				Affliction = Affliction + intensity
			end
			if settings.Notify and value >= math.min(settings.Afflict or 1.0, settings.DamageAt or 1.0) and GetGameTimer() - LastNotify > 12000 then
				exports.mythic_notify:SendAlert("error", settings.Notify, 7000)
				notified = true
			end
		end

		if notified then
			LastNotify = GetGameTimer()
		end
		
		lastUpdate = GetGameTimer()

		local bac = Effects["Bac"] or 0.0
		local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
		if math.abs(lastBac - bac) > 0.1 or (bac <= 0.01 and lastBac >= 0.01) or (bac > 0.01 and isInVehicle ~= wasInVehicle) then
			DoScreenFadeOut(500)
			Citizen.Wait(500)
			DoScreenFadeIn(500)

			local mult = 2.0
			if isInVehicle then
				mult = 4.0
			end
			
			ShakeGameplayCam("DRUNK_SHAKE", bac * mult)

			local walkStyle = nil
			if bac >= 0.75 then
				walkStyle = "drunk3"
			elseif bac >= 0.5 then
				walkStyle = "drunk2"
			elseif bac > 0.01 then
				walkStyle = "drunk"
			end

			exports.emotes:SetCustomWalkStyle(walkStyle)
		end
		lastBac = bac
		wasInVehicle = isInVehicle

		Citizen.Wait(math.floor(interval))
	end
end)

Citizen.CreateThread(function()
	while true do
		while Affliction <= 0.001 do
			Citizen.Wait(500)
		end

		local time = GetRandomIntInRange(0, 500)
		Citizen.Wait(time)

		ShakeGameplayCam("VIBRATE_SHAKE", GetRandomFloatInRange(0.3, 0.6) * Affliction)

		-- if GetRandomFloatInRange(0.0, 1.0) < 0.1 then
		-- 	time = math.floor(GetRandomIntInRange(500, 1000) * (Affliction * 0.5 + 0.5))

		-- 	DoScreenFadeOut(time)
		-- 	Citizen.Wait(math.floor(time / 2))
		-- 	DoScreenFadeIn(time)
		-- end

		Citizen.Wait(GetRandomIntInRange(1000, 2000))
	end
end)

--[[ Functions ]]--
function AddEffect(name, amount)
	local effect = Effects[name] or 0.0
	local notify = notified[name]
	local settings = Config.Effects[name]

	effect = math.max(math.min(effect + amount, settings.Max or 1.0), settings.Min or 0.0)
	Effects[name] = effect
	
	if not notify or math.abs(effect - notify) >= 0.1 then
		UpdateInfo()
		notified[name] = effect
	end
	SendNUIMessage({ addEffect = { name = name, amount = effect } })
end
exports("AddEffect", AddEffect)

function GetEffect(name)
	return Effects[name] or 0.0
end
exports("GetEffect", GetEffect)

function ClearEffect(name)
	UpdateInfo()
	Effects[name] = nil
	SendNUIMessage({ clearEffect = name })
end
exports("ClearEffect", ClearEffect)

function ClearEffects()
	Effects = {}
	Affliction = 0.0
	
	SendNUIMessage({ clearEffects = true })
	UpdateInfo()
end
exports("ClearEffects", ClearEffects)

function BasicEffectModifier(value)
	local ped = PlayerPedId()

	-- Instanced modifier.
	if GetResourceState("instances") == "started" and exports.instances:IsInstanced() then
		value = value * 0.25
	end

	-- Movement modifiers.
	if IsPedSprinting(ped) then
		value = 1.5 * value
	elseif IsPedRunning(ped) then
		value = 1.25 * value
	elseif not IsPedWalking(ped) then
		value = 0.5 * value
	end

	-- Return value.
	return value
end