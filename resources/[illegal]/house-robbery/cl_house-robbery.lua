Alertness = 0.0
Inside = nil
Peds = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not Inside do
			Citizen.Wait(2000)
		end
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local isStealth = GetPedStealthMovement(playerPed)
		local lastAlertness = Alertness
		if not isStealth and not IsPedStill(playerPed) then
			if IsPedRunning(playerPed) then
				Alertness = Alertness + 0.2
			else
				Alertness = Alertness + 0.1
			end
		end
		for ped, settings in pairs(Peds) do
			if DoesEntityExist(ped) then
				local pedAlertness = GetPedAlertness(ped)
				local lastPedAlertness = pedAlertness
				local shouldAlert = false
				local dist = #(GetEntityCoords(ped) - playerCoords)
				if
					IsPedInCombat(ped, playerPed) or
					(dist < 12.0 and Alertness > 1.0) or
					(dist < 6.0 and Alertness > 0.8) or
					(dist < 4.0 and Alertness > 0.6) or
					dist < 1.5
				then
					shouldAlert = true
				end
				SetPedAlertness(ped, pedAlertness)
				if not shouldAlert and not settings.alerted then
					if settings.Sleeping and not IsEntityPlayingAnim(ped, "facials@gen_male@base", "mood_sleeping_1", 3) then
						PlayFacialAnim(ped, "mood_sleeping_1", "facials@gen_male@base")
					end
					if settings.Anim and not IsEntityPlayingAnim(ped, settings.Anim.Dict, settings.Anim.Name, 3) then
						exports.emotes:PlayOnPed(ped, settings.Anim, false)
					end
				elseif shouldAlert and not settings.alerted then
					settings.alerted = true
					Alertness = 0.0

					Citizen.CreateThread(function()
						ClearPedTasks(ped)

						-- Turn the player.
						TaskTurnPedToFaceEntity(ped, playerPed, 2000)
						Citizen.Wait(2000)
						
						-- Pull out phone and wait.
						TaskStartScenarioInPlace(ped, "WORLD_HUMAN_TOURIST_MOBILE", 0, true)
						Citizen.Wait(4000)

						-- Report and wait.
						if not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then return end

						exports.dispatch:Report("emergency", { "10-31", "House" }, 0, true, nil, { coords = true })
						Citizen.Wait(4000)

						-- Cower.
						if not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then return end

						TaskCower(ped, -1)
					end)
				end
			end
		end
		if math.abs(lastAlertness - Alertness) < 0.01 then
			Alertness = math.max(Alertness - 0.04, 0.0)
		end
		Citizen.Wait(1000)
	end
end)

--[[ Functions ]]--
function IsInside()
	return Inside ~= nil
end
exports("IsInside", IsInside)

--[[ Events ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	-- Check item.
	if not item.name == Config.Item then return end

	-- Verify property.
	local property = exports.properties:GetNearestProperty(true)
	if not property or property.open or not property.type then return end

	local propertySettings = Config.Properties[property.type]
	if property.character_id or not propertySettings then
		TriggerEvent("chat:notify", { class = "error", text = "That property is shut too tight..." })
		return
	end

	local hour = GetClockHours()
	if hour < Config.Time[1] and hour > Config.Time[2] then
		TriggerEvent("chat:notify", { class = "error", text = "It's too bright out..." })
		return
	end

	cb(1000)
end)

AddEventHandler("inventory:useFinish", function(item, slotId)
	-- Check item.
	local anim = item.name == Config.Item and Config.Lockpicking.Action.Anim
	if not anim then return end

	local property = exports.properties:GetNearestProperty(true)
	if not property or property.open or not property.type then return end

	local propertySettings = Config.Properties[property.type]
	if property.character_id or not propertySettings then
		TriggerEvent("chat:notify", { class = "error", text = "That property is shut too tight..." })
		return
	end

	local hour = GetClockHours()
	if hour < Config.Time[1] and hour > Config.Time[2] then
		TriggerEvent("chat:notify", { class = "error", text = "It's too bright out..." })
		return
	end

	anim.Duration = Config.Lockpicking.Action.Duration

	local emote = exports.emotes:Play(anim)

	if not exports.quickTime:Begin(Config.QuickTime) then return end

	if not emote then return end
	exports.emotes:Stop(emote)

	TriggerServerEvent("house-robbery:open", slotId, property.id)
end)

RegisterNetEvent("house-robbery:enter")
AddEventHandler("house-robbery:enter", function(cache)
	Alertness = 0.0
	Inside = cache

	if cache.tasks then
		for taskId, task in pairs(cache.tasks) do
			exports.tasks:Add(taskId, task[1], task[2])
		end
	end

	local property = exports.properties:GetProperty(cache.property)
	local settings = Config.Properties[property.type]
	
	if settings.Peds then
		local seed = math.floor(Inside.seed)
		
		for k, pedSettings in ipairs(settings.Peds) do
			math.randomseed(seed + k * 376)
			if math.random() <= pedSettings.Chance then
				local model = pedSettings.Model

				-- Get a random model.
				if type(model) == "table" then
					math.randomseed(seed - k * 192)
					model = model[math.random(1, #model)]
				end

				-- Load the model.
				while not HasModelLoaded(model) do
					RequestModel(model)
					Citizen.Wait(20)
				end

				-- Create the ped.
				local ped = CreatePed(4, model, pedSettings.Coords.x, pedSettings.Coords.y, pedSettings.Coords.z, pedSettings.Coords.w, false, true)
				Peds[ped] = pedSettings
				
				SetPedDefaultComponentVariation(ped)
				SetPedCombatAttributes(ped, 46, false)
				SetPedConfigFlag(ped, 224, false)
				SetPedCombatMovement(ped, 0)

				-- Request facial dict.
				if settings.Anim then
					Citizen.CreateThread(function()
						while settings.Sleeping and not HasAnimDictLoaded("facials@gen_male@base") do
							RequestAnimDict("facials@gen_male@base")
							Citizen.Wait(20)
						end
					end)
				end
			end
		end
	end
end)

RegisterNetEvent("house-robbery:exit")
AddEventHandler("house-robbery:exit", function(cache)
	if Inside and Inside.tasks then
		for taskId, task in pairs(cache.tasks) do
			exports.tasks:Remove(taskId)
		end
	end
	for ped, _ in pairs(Peds) do
		if DoesEntityExist(ped) then
			DeleteEntity(ped)
		end
	end
	Peds = {}
	Inside = nil
end)