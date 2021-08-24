BuyerPed = 0
Corner = nil
CurrentDrug = ""
CurrentDrugCount = 0
CurrentPrice = nil
CurrentZone = nil
DrugEffect = nil
DrugEffectTime = 0
IsSelling = false
IsWaiting = false
LastDrugUsed = nil
LastEvent = nil
LastShake = 0
LastSling = 0
LastSpawned = 0
LastUpdate = 0
IgnoreModels = {
	[GetHashKey("mp_f_freemode_01")] = true,
	[GetHashKey("mp_m_freemode_01")] = true,
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Corner then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			if DoesEntityExist(BuyerPed) and not IsPedDeadOrDying(BuyerPed) then
				local buyerCoords = GetEntityCoords(BuyerPed)
				local dist = #(playerCoords - buyerCoords)

				-- DrawLine(buyerCoords.x, buyerCoords.y, buyerCoords.z, playerCoords.x, playerCoords.y, playerCoords.z, 255, 0, 255, 255)

				if CurrentPrice and dist < Config.Slinging.DrawDistance then
					-- local context = exports.oldutils:DrawContext({
					-- 	{nil, ("$%s - %s"):format(price, drug)},
					-- 	{51, "Accept"},
					-- 	{47, "Reject"},
					-- }, buyerCoords, 1)
					local id = 2
					
					if dist < Config.Slinging.Distance then
						id = 1
						
						if not IsWaiting then
							TaskStandStill(BuyerPed, 5000)
							TaskTurnPedToFaceEntity(BuyerPed, playerPed, -1)
							IsWaiting = true
						end
						
						if IsControlJustPressed(0, 51) then
							local startTime = GetGameTimer()
							TaskTurnPedToFaceEntity(playerPed, BuyerPed, 4000)
							TaskTurnPedToFaceEntity(BuyerPed, playerPed, 4000)
							while not IsPedFacingPed(playerPed, BuyerPed, 10.0) and GetGameTimer() - startTime < 4000 do
								Citizen.Wait(0)
							end
							while not HasAnimDictLoaded(Config.Slinging.Anim.Dict) do
								RequestAnimDict(Config.Slinging.Anim.Dict)
								Citizen.Wait(0)
							end
							if not IsPedRagdoll(BuyerPed) and not IsPedDeadOrDying(BuyerPed) then
								IsSelling = true

								exports.emotes:Play(Config.Slinging.Anim)
								TaskPlayAnim(BuyerPed, Config.Slinging.Anim.Dict, Config.Slinging.Anim.Name, 4.0, 4.0, -1, Config.Slinging.Anim.Flag, 0, false, false, false)

								local ped = BuyerPed
								
								Citizen.CreateThread(function()
									local retval, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z)
									if retval and GetRandomFloatInRange(0.0, 1.0) < 0.1 then
										exports.evidence:Register("Drug Residue", vector3(playerCoords.x, playerCoords.y, groundZ), { drug = CurrentDrug })
									end
									for i = 1, 30 do
										exports.peds:AddEvent("drugs")
										Citizen.Wait(100)
									end
									
									if DoesEntityExist(ped) and GetRandomFloatInRange(0.0, 1.0) < 0.5 then
										DecorSetBool(ped, "No_Report", false)
									end
								end)

								Citizen.Wait(2000)

								TriggerServerEvent("drugs:sell")
								ClearPedSecondaryTask(BuyerPed)
								TaskWanderStandard(BuyerPed, 10.0, 10)
								
								BuyerPed = 0

								Citizen.Wait(1000)
							end
						elseif IsControlJustPressed(0, 47) or IsPedFleeing(BuyerPed) then
							TaskWanderStandard(BuyerPed, 10.0, 10)
							BuyerPed = 0
						end
					end

					if BuyerPed ~= 0 then
						exports.oldutils:Draw3DText(buyerCoords, ("$%s - %s x%s"):format(CurrentPrice * CurrentDrugCount, CurrentDrug, CurrentDrugCount), 4, 0.4, id, 1, vector2(0.0, -0.03))
						exports.oldutils:Draw3DText(buyerCoords, exports.oldutils:FormatInstructional("Accept", 51), 4, 0.4, id, 1, vector2(0.0, 0.0))
						exports.oldutils:Draw3DText(buyerCoords, exports.oldutils:FormatInstructional("Reject", 47), 4, 0.4, id, 1, vector2(0.0, 0.03))
					end
				end
				if IsPedClimbing(BuyerPed) then
					ClearPedTasksImmediately(BuyerPed)
					TaskReactAndFleePed(BuyerPed, playerPed)
					BuyerPed = 0
				elseif not IsWaiting and not GetIsTaskActive(BuyerPed, 224) and GetGameTimer() - LastUpdate > 500 then
					TaskFollowNavMeshToCoord(BuyerPed, playerCoords.x, playerCoords.y, playerCoords.z, 1.0, -1, 0, false, 0)
					-- TaskGoToCoordAnyMeans(BuyerPed, playerCoords.x, playerCoords.y, playerCoords.z, 1.0, 0, 0, 786603, 0xbf800000)
					LastUpdate = GetGameTimer()
				end
			elseif not IsSelling then
				Spawn()
				Citizen.Wait(1000)
			end
			if Corner and #(Corner - playerCoords) > Config.Slinging.MaxRange then
				StopSlinging()
			end
			LastSling = GetGameTimer()
		else
			if DoesEntityExist(BuyerPed) then
				TaskWanderStandard(BuyerPed, 10.0, 10)
				BuyerPed = 0
			end
			Citizen.Wait(1000)
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if DrugEffect then
			local ped = PlayerPedId()
			local time = GetGameTimer() - DrugEffectTime
			local strength = 0.0
			local speed = 1.0
			local delay = 2000.0
			local fade = 2000.0
			local duration = 60000.0
			
			if time < fade + delay and time > delay then
				strength = (time - delay) / fade
			elseif time > duration + fade then
				DrugEffect = nil
			elseif time > duration then
				strength = 1.0 - (time - duration) / fade
			elseif time > delay then
				strength = 1.0
			end
			if DrugEffect then
				SetTimecycleModifier(DrugEffect)
				SetTimecycleModifierStrength(math.min(math.max(strength, 0.0), 1.0))
				
				if time > 6000 then
					speed = 1.5 - (math.cos(2.0 * math.pi * (time - 6000) / 5000)^4) * 0.5
				end
			else
				ClearTimecycleModifier()
			end
			if LastDrugUsed == "Cocaine" then
				if GetGameTimer() - LastShake > 2000 then
					ShakeGameplayCam("JOLT_SHAKE", 0.5)
					LastShake = GetGameTimer()
				end
				SetPedMoveRateOverride(ped, speed)
			end
			if LastDrugUsed == "Ketamine Syringe" then
				if GetGameTimer() - LastShake > 2000 then
					ShakeGameplayCam("JOLT_SHAKE", 1.0)
					LastShake = GetGameTimer()
				end
				SetPedMoveRateOverride(ped, 1.8)
			end
			if LastDrugUsed == "Laced Heroin Syringe" then
				if GetGameTimer() - LastShake > 2000 then
					ShakeGameplayCam("JOLT_SHAKE", 0.2)
					LastShake = GetGameTimer()
				end
				SetPedMoveRateOverride(ped, 1.1)
			end

			Citizen.Wait(0)
		else
			Citizen.Wait(500)
		end
	end
end)

--[[ Functions ]]--
function Spawn()
	if GetGameTimer() - LastSpawned < Config.Slinging.SpawnCooldown then return end
	
	TriggerServerEvent("drugs:attemptSell", CurrentZone, CurrentDrug)
end

function StopSlinging()
	Corner = nil
	exports.mythic_notify:SendAlert("inform", "No longer slinging...", 7000)
end

function RegisterItems()
	for k, v in pairs(Config.Actions) do
		exports.inventory:RegisterAction(k, v)
	end
end

--[[ Events ]]--
RegisterNetEvent("drugs:sell")
AddEventHandler("drugs:sell", function()
	IsSelling = false

	exports.mythic_notify:SendAlert("inform", ("Sold %sx %s for $%s!"):format(CurrentDrugCount, CurrentDrug, CurrentDrugCount * CurrentPrice), 7000)

	if not exports.inventory:HasItem(CurrentDrug) then
		StopSlinging()
	end
end)

RegisterNetEvent("drugs:attemptSell")
AddEventHandler("drugs:attemptSell", function(price, amount)
	if not price then return end

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local peds = exports.oldutils:GetPeds()
	local randomPeds = {}
	for k, ped in ipairs(peds) do
		if DoesEntityExist(ped) and not IsPedAPlayer(ped) and IsPedHuman(ped) and not IgnoreModels[GetEntityModel(ped)] then
			randomPeds[#randomPeds + 1] = ped
		end
	end

	if #randomPeds == 0 then
		return
	end

	local referencePed = randomPeds[GetRandomIntInRange(1, #randomPeds)]
	if not referencePed then return end
	
	local radius = GetRandomFloatInRange(25.0, 50.0)
	local radians = GetRandomFloatInRange(0.0, 2.0 * math.pi)

	-- Try to place them somewhere safe.
	local x, y = coords.x + math.cos(radians) * radius, coords.y + math.sin(radians) * radius
	local retval, outCoords = GetSafeCoordForPed(x, y, coords.z, true, 0)

	-- Try to place them anywhere.
	if not retval then
		retval, outCoords = GetSafeCoordForPed(x, y, coords.z, false, 0)
	end

	if not retval then return end
	
	CurrentPrice = price
	CurrentDrugCount = amount

	BuyerPed = CreatePed(
		GetPedType(referencePed),
		GetEntityModel(referencePed),
		outCoords.x,
		outCoords.y,
		outCoords.z,
		0.0,
		true,
		false
	)
	
	DecorSetBool(BuyerPed, "No_Report", GetRandomFloatInRange(0.0, 1.0) > 0.05)
	SetEntityCoordsNoOffset(BuyerPed, outCoords.x, outCoords.y, outCoords.z)
	-- Debug.
	-- SetEntityCoordsNoOffset(BuyerPed, coords.x, coords.y - 0.5, coords.z)
	SetEntityAsNoLongerNeeded(BuyerPed)
	
	IsWaiting = false
	LastSpawned = GetGameTimer()
end)

RegisterNetEvent("drugs:stopSelling")
AddEventHandler("drugs:stopSelling", function()
	StopSlinging()
end)

AddEventHandler("drugs:start", function()
	RegisterItems()
end)

RegisterNetEvent("inventory:use_Joint")
AddEventHandler("inventory:use_Joint", function()
	local ped = PlayerPedId()
	exports.health:ArmorUp(0.1)

	LastDrugUsed = "Weed"
	DrugEffect = "stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_Bong")
AddEventHandler("inventory:use_Bong", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Bong"
	DrugEffect = "stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_MedicinalJoint")
AddEventHandler("inventory:use_MedicinalJoint", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Medicinal Joint"
	DrugEffect = "stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_CherryMedicinalJoint")
AddEventHandler("inventory:use_CherryMedicinalJoint", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Cherry Medicinal Joint"
	DrugEffect = "stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_MangoMedicinalJoint")
AddEventHandler("inventory:use_MangoMedicinalJoint", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Mango Medicinal Joint"
	DrugEffect = "stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_Edible")
AddEventHandler("inventory:use_Edible", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Edible"
	DrugEffect = "Barry1_Stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_WaxConcentrate")
AddEventHandler("inventory:use_WaxConcentrate", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Wax Concentrate"
	DrugEffect = "Barry1_Stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_DabSauce")
AddEventHandler("inventory:use_DabSauce", function()
	local ped = PlayerPedId()

	LastDrugUsed = "DabSauce"
	DrugEffect = "Barry1_Stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_SpecialCookies")
AddEventHandler("inventory:use_SpecialCookies", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Special Cookies"
	DrugEffect = "Barry1_Stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_CerealKrispie")
AddEventHandler("inventory:use_CerealKrispie", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Cereal Krispie"
	DrugEffect = "Barry1_Stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_RiceKrispie")
AddEventHandler("inventory:use_RiceKrispie", function()
	local ped = PlayerPedId()

	LastDrugUsed = "Rice Krispie"
	DrugEffect = "Barry1_Stoned"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_Cocaine")
AddEventHandler("inventory:use_Cocaine", function()
	LastDrugUsed = "Cocaine"
	DrugEffect = "spectator6"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_CocaineGrenada")
AddEventHandler("inventory:use_CocaineGrenada", function()
	LastDrugUsed = "Cocaine"
	DrugEffect = "spectator6"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_CocaineCompact")
AddEventHandler("inventory:use_CocaineCompact", function()
	LastDrugUsed = "Cocaine"
	DrugEffect = "spectator6"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_CrackPipe")
AddEventHandler("inventory:use_CrackPipe", function()
	LastDrugUsed = "Crack Pipe"
	DrugEffect = "LectroLight"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_PeyoteChunk")
AddEventHandler("inventory:use_PeyoteChunk", function()
	LastDrugUsed = "Peyote Chunk"
	DrugEffect = "ArenaEMP"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_KetamineSyringe")
AddEventHandler("inventory:use_KetamineSyringe", function()
	LastDrugUsed = "Ketamine Syringe"
	DrugEffect = "BlackOut"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_LacedHeroinSyringe")
AddEventHandler("inventory:use_LacedHeroinSyringe", function()
	LastDrugUsed = "Laced Heroin Syringe"
	DrugEffect = "drug_drive_blend01"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_HeroinSyringe")
AddEventHandler("inventory:use_HeroinSyringe", function()
	LastDrugUsed = "Heroin Syringe"
	DrugEffect = "drug_drive_blend01"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_ChinaWhiteSyringe")
AddEventHandler("inventory:use_ChinaWhiteSyringe", function()
	LastDrugUsed = "China White Syringe"
	DrugEffect = "drug_drive_blend01"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_Lean")
AddEventHandler("inventory:use_Lean", function()
	LastDrugUsed = "Lean"
	DrugEffect = "drug_wobbly"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_LSD")
AddEventHandler("inventory:use_LSD", function()
	LastDrugUsed = "LSD"
	DrugEffect = "spectator9"
	DrugEffectTime = GetGameTimer()
end)

RegisterNetEvent("inventory:use_PowderedFentanyl")
AddEventHandler("inventory:use_PowderedFentanyl", function()
	LastDrugUsed = "Powdered Fentanyl"
	DrugEffect = "drug_drive_blend01"
	DrugEffectTime = GetGameTimer()
end)

AddEventHandler("inventory:loaded", function()
	RegisterItems()
end)

--[[ Commands ]]--
RegisterCommand("corner", function(source, args, command)
	if Corner then
		StopSlinging()
		return
	end
	
	if GetGameTimer() - LastSling < Config.Slinging.Cooldown * 1000 then
		exports.mythic_notify:SendAlert("error", "You're slinging too fast!", 7000)
		return
	end

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	
	CurrentZone = GetNameOfZone(coords.x, coords.y, coords.z)
	local zone = Config.Zones[CurrentZone]
	if not zone then
		print("Invalid zone: "..tostring(CurrentZone))
		return
	end
	
	local items = {}
	for _, item in ipairs(Config.Items) do
		if zone[item] >= -0.0 and exports.inventory:HasItem(item) then
			items[#items + 1] = item
		end
	end
	if #items > 0 then
		CurrentDrug = items[GetRandomIntInRange(1, #items)]
		exports.mythic_notify:SendAlert("inform", ("Slinging %s..."):format(CurrentDrug:lower()), 7000)
	else
		exports.mythic_notify:SendAlert("error", "You can't seem to sling here...", 7000)
		return
	end

	LastSling = GetGameTimer()
	Corner = coords
	IsSelling = false
end)
