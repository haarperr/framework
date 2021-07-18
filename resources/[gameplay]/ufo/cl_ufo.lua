Spawned = {}
Event = true

local ufos = {}
local flyable = 0
local endCoords = vector3(2946.993408203125, 2777.056640625, 39.2110481262207)
local startCoords = vector3(-2241.234619140625, 261.9048461914063, 174.61080932617188)

Citizen.CreateThread(function()
	local spacing = 500.0
	local width = 18
	local height = 27
	for i = 0, width*height-1 do
		local coords = vector3(math.floor(i / height) * spacing - 4000, math.floor(i % height) * spacing - 5000, 500.0)
		local height = GetHeightmapTopZForPosition(coords.x, coords.y)
		local ufo = CreateObject(GetHashKey("p_spinning_anus_s"), coords.x, coords.y, coords.z + height, false, false, false)
		SetEntityLodDist(ufo, 3000)
		FreezeEntityPosition(ufo, true)
		ufos[ufo] = coords
	end

	while true do
		for k, coords in pairs(ufos) do
			local rot = GetEntityRotation(k)
			SetEntityRotation(k, rot.x, rot.y, rot.z + 2)
		end
		
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	if not Event then return end

	AddRelationshipGroup("aliens")

	local blip = AddBlipForRadius(endCoords.x, endCoords.y, endCoords.z, 200.0)
	SetBlipAlpha(blip, 128)
	SetBlipColour(blip, 1)

	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local nearbyPeds = exports.oldutils:GetPeds()
		local playerCount = 0
		for k, v in ipairs(nearbyPeds) do
			if IsPedAPlayer(v) and #(coords - GetEntityCoords(v)) < 50.0 then
				playerCount = playerCount + 1
			end
		end

		local count = 0
		for ped, _ in pairs(Spawned) do
			if DoesEntityExist(ped) then
				if #(GetEntityCoords(ped) - coords) > 250.0 or IsPedDeadOrDying(ped) then
					SetEntityAsNoLongerNeeded(ped)
				end
				count = count + 1
			else
				Spawned[ped] = nil
			end
		end

		local startDist =#(startCoords - coords)
		local endDist = #(endCoords - coords)
		local max = 10 / playerCount

		if startDist < 200.0 then
			max = 0
		elseif endDist < 200.0 then
			max = 0
		elseif endDist < 400.0 then
			max = 25
		end

		if count < max then
			local model = GetHashKey("s_m_m_movalien_01")
			if not HasModelLoaded(model) then
				RequestModel(model)
				Citizen.Wait(0)
			end

			local radian = GetRandomFloatInRange(0.0, math.pi * 2.0)
			local range = GetRandomFloatInRange(100.0, 150.0)
			local spawnCoords = coords + vector3(math.cos(radian) * range, math.sin(radian) * range, 0.0)
			local retval, safeCoords = GetSafeCoordForPed(spawnCoords.x, spawnCoords.y, spawnCoords.z, false, 0)

			local ped = CreatePed(28, model, safeCoords.x, safeCoords.y, safeCoords.z, 0.0, true, false)
			PlaceObjectOnGroundProperly(ped)
			for i = 0, 11 do
				SetPedComponentVariation(ped, i, 0, 0, 0)
				SetPedPropIndex(ped, i, 0, 0, 0)
			end
			
			SetPedCombatAbility(ped, 0)
			SetPedCombatAttributes(ped, 1, false)
			SetPedCombatAttributes(ped, 5, true)
			SetPedCombatAttributes(ped, 46, true)
			SetPedCombatRange(ped, 2)
			SetPedRelationshipGroupHash(ped, GetHashKey("aliens"))
			SetPedAccuracy(ped, 0)
			SetPedHasAiBlip(ped, true)

			GiveWeaponToPed(ped, GetHashKey("WEAPON_RAYCARBINE"), 0, false, true)

			TaskCombatPed(ped, playerPed, p2, p3)

			Spawned[ped] = true
		end

		if IsPedDeadOrDying(playerPed) then
			local weapon = GetHashKey("WEAPON_COMBATPISTOL")
			NetworkResurrectLocalPlayer(startCoords.x, startCoords.y, startCoords.z, 90.0)
			GiveWeaponToPed(playerPed, weapon, 999, false, true)
			SetPedInfiniteAmmo(playerPed, true, weapon)
			TriggerEvent("health:revive")
		end
		
		Citizen.Wait(1000)
	end
end)

RegisterNetEvent("ufo:toggle")
AddEventHandler("ufo:toggle", function()
	if DoesEntityExist(flyable) then
		DeleteVehicle(flyable)
		flyable = 0
		return
	end

	local model = GetHashKey("hydra")
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(20)
	end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped) + vector3(0.0, 0.0, 100.0)
	local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, true)
	SetPedIntoVehicle(ped, vehicle, -1)
	-- SetEntityVisible(vehicle, false)
	flyable = vehicle

	local ufo = CreateObject(GetHashKey("p_spinning_anus_s"), coords.x, coords.y, coords.z, true, false, true)
	AttachEntityToEntity(ufo, vehicle, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, false, false, 0, true)
	SetEntityLodDist(ufo, 3000)
end)

AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end
	for k, v in pairs(ufos) do
		if DoesEntityExist(k) then
			DeleteObject(k)
		end
	end
end)