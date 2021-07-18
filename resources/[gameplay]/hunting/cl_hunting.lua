Target = 0
IsTracking = false
Tracking = 0
Spawned = {}

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local peds = exports.oldutils:GetPeds()

		Target = 0

		for _, ped in ipairs(peds) do
			local model = GetEntityModel(ped)
			if IsPedDeadOrDying(ped, 1) and not IsPedAPlayer(ped) and Config.Animals[model] ~= nil and #(GetEntityCoords(ped) - coords) < Config.Distance then
				Target = ped
				break
			elseif IsTracking and not DoesEntityExist(Tracking) and Config.Animals[model] ~= nil then
				TrackPed(ped)
			end
		end

		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local zone = Config.Zones[GetNameOfZone(coords.x, coords.y, coords.z) or ""]
		if zone then
			local count = 0
			for ped, _ in pairs(Spawned) do
				if DoesEntityExist(ped) then
					if #(GetEntityCoords(ped) - coords) > 250.0 and exports.oldutils:RequestAccess(ped) then
						SetEntityAsNoLongerNeeded(ped)
					end
					-- DrawLine(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, coords.x, coords.y, coords.z, 0, 255, 255, 255)
					count = count + 1
				else
					Spawned[ped] = nil
				end
			end

			local nearbyPeds = exports.oldutils:GetPeds()
			local playerCount = 0
			for k, v in ipairs(nearbyPeds) do
				if IsPedAPlayer(v) and #(coords - GetEntityCoords(v)) < 50.0 then
					playerCount = playerCount + 1
				end
			end

			if count < zone.Max / playerCount then
				local model = GetHashKey(zone.Spawns[GetRandomIntInRange(1, #zone.Spawns + 1)])
				if not HasModelLoaded(model) then
					RequestModel(model)
					Citizen.Wait(0)
				end

				local radian = GetRandomFloatInRange(0.0, math.pi * 2.0)
				local range = GetRandomFloatInRange(100.0, 200.0)
				local spawnCoords = coords + vector3(math.cos(radian) * range, math.sin(radian) * range, 0.0)
				local retval, safeCoords = GetSafeCoordForPed(spawnCoords.x, spawnCoords.y, spawnCoords.z, false, 0)

				if retval then
					local ped = CreatePed(28, model, safeCoords.x, safeCoords.y, safeCoords.z, 0.0, true, false)
					PlaceObjectOnGroundProperly(ped)
					TaskWanderStandard(ped, 0, 0)
					
					Spawned[ped] = true
				end
			end
		end
		
		Citizen.Wait(500)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		local function checkTarget()
			if not DoesEntityExist(Target) then return false end

			return #(GetEntityCoords(Target) - GetEntityCoords(PlayerPedId())) < Config.Distance
		end

		if DoesEntityExist(Target) and exports.oldutils:DrawContext("Harvest", GetEntityCoords(Target)) then
			TaskTurnPedToFaceEntity(ped, Target, 4000)

			while not IsPedFacingPed(ped, Target, 45.0) do
				Citizen.Wait(0)
			end

			if checkTarget() then
				exports.mythic_progbar:Progress(Config.Action, function(wasCancelled)
					if wasCancelled or not checkTarget() then return end
					
					TriggerServerEvent("hunting:harvest", PedToNet(Target), GetEntityModel(Target))
				end)
			end
		end

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("hunting:harvested")
AddEventHandler("hunting:harvested", function(netId)
	local ped = NetToPed(netId)
	if DoesEntityExist(ped) and exports.oldutils:RequestAccess(ped) then
		DeletePed(ped)
	end
end)

function TrackPed(ped)
	Tracking = ped
	Citizen.CreateThread(function()
		while not HasNamedPtfxAssetLoaded(Config.Tracking.Effect.Dict) do
			RequestNamedPtfxAsset(Config.Tracking.Effect.Dict)
			Citizen.Wait(0)
		end
		
		local effect
		while IsTracking and Tracking == ped and DoesEntityExist(ped) do
			if effect then
				StopParticleFxLooped(effect)
			end
			UseParticleFxAssetNextCall(Config.Tracking.Effect.Dict)

			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local pedCoords = GetEntityCoords(ped)
			local dir = exports.misc:Normalize(pedCoords - coords)
			local rot = exports.misc:ToRotation2(dir)

			-- DrawLine(coords.x, coords.y, coords.z, pedCoords.x, pedCoords.y, pedCoords.z, 255, 0, 255, 255)
			
			coords = coords + dir * math.min(GetRandomFloatInRange(10.0, 20.0), #(pedCoords - coords))
			effect = StartParticleFxLoopedAtCoord(Config.Tracking.Effect.Name, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z - 90.0, 2.0, 0.0, 0.0, 0.0)

			Citizen.Wait(2000)
		end
		if effect then
			StopParticleFxLooped(effect)
		end
	end)
end

-- RegisterCommand("/track", function(source, args, command)
-- 	IsTracking = not IsTracking
-- end)

-- Citizen.CreateThread(function()
-- 	local coords = GetEntityCoords(PlayerPedId())
-- 	IsTracking = true
-- 	RequestModel(GetHashKey("a_c_deer"))
-- 	TrackPed(CreatePed(28, GetHashKey("a_c_deer"), coords.x, coords.y, coords.z, 0.0, true, false))
-- end)