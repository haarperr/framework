Debug = false
IsFishing = false
NextCatch = 0
Slot = nil

--[[ Initialization ]]--
if Debug then
	local color = 0
	for zone, settings in pairs(Config.Zones) do
		for _, coords in ipairs(settings.Coords) do
			local blip = AddBlipForCoord(coords.x, coords.y, 0.0)
			SetBlipSprite(blip, 68)
			SetBlipColour(blip, color)
			SetBlipScale(blip, 1.0)
			SetBlipAlpha(blip, 192)
			SetBlipHiddenOnLegend(blip, true)
			SetBlipDisplay(blip, 3)
		end
		color = color + 5
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if IsFishing then
			local delay = GetRandomIntInRange(Config.Delay[1] * 1000, Config.Delay[2] * 1000)
			Citizen.Wait(delay)

			if not IsFishing then
				goto skip
			end

			local emote = exports.emotes:GetCurrentEmote()
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local origin = GetPedBoneCoords(ped, 60309, 0.0, 0.0, 2.5)
			local obstructions = 0
			local depth = 0.0
			local zone = GetNameOfZone(coords.x, coords.y, coords.z)

			for i = 0, 19 do
				local target = GetOffsetFromEntityInWorldCoords(ped, 0.0, 10.0 + i * 60.0, -300.0)
				local retval, surface = TestProbeAgainstWater(origin.x, origin.y, origin.z, target.x, target.y, target.z)
				if retval and #(surface - origin) > 100.0 then
					retval = false
				end
				if retval then
					local rayHandle = StartShapeTestRay(surface.x, surface.y, surface.z + 1000.0, surface.x, surface.y, surface.z - 1000.0, 1, nil, 0)
					local _retval, hit, floor, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
					if hit == 1 then
						depth = math.max(depth, #(floor - origin) - #(surface - origin))
						if Debug then
							Citizen.CreateThread(function()
								for i = 1, 300 do
									DrawLine(surface.x, surface.y, surface.z, floor.x, floor.y, floor.z, 0, 0, 255, 255)
									Citizen.Wait(0)
								end
							end)
						end
					elseif zone == "SanAnd" or zone == "OCEANA" then
						depth = 1000.0
					end
				else
					obstructions = obstructions + 1
				end

				if Debug then
					Citizen.CreateThread(function()
						for i = 1, 300 do
							local r, g, b = 255, 0, 0
							if retval then
								r = 0
								g = 255
							end
							DrawLine(origin.x, origin.y, origin.z, target.x, target.y, target.z, r, g, b, 255)
							Citizen.Wait(0)
						end
					end)
				end
			end

			local peers = 0
			local players = exports.oldutils:GetNearbyPlayers()
			for _, player in ipairs(players) do
				if #(coords - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))) < Config.PeerBonus.Range then
					peers = peers + 1
				end
			end

			local chance = Config.BaseCatchChance * (1.0 - (obstructions / 15)) + Config.PeerBonus.Chance * math.min(peers / Config.PeerBonus.Count, 1.0)
			local random = GetRandomFloatInRange(0.0, 1.0)

			if Debug then
				print("chance", chance, "obstructions", obstructions, "peers", peers, "depth", depth, "random", random)
			end

			if obstructions >= 15 then
				local message
				if obstructions >= 20 then
					message = "The line won't move without water!"
				else
					message = "The line is stuck!"
				end

				exports.mythic_notify:SendAlert("inform", message, 7000)
			elseif random < chance then
				exports.mythic_notify:SendAlert("success", "You feel a bite!", 7000)

				Citizen.Wait(2000)

				TriggerEvent("quickTime:begin", "linear", GetRandomFloatInRange(60.0, 80.0), function(status)
					StopFishing()

					if not status then return end

					Citizen.Wait(200)

					exports.emotes:Play(Config.CatchAnim)
					TriggerServerEvent("fishing:catch", Slot, GetHabitat(GetEntityCoords(PlayerPedId()), depth))
				end)
			else
				local message
				if obstructions > 0 then
					message = "The line is a little stuck, but you feel it reeling..."
				else
					message = "The line is reeling..."
				end
				exports.mythic_notify:SendAlert("inform", message, 7000)
			end
		else
			Citizen.Wait(1000)
		end
		::skip::
		Citizen.Wait(0)
	end
end)

function GetHabitat(coords, depth)
	if depth > 100.0 then
		return "Pelagic"
	end
	coords = vector2(coords.x, coords.y)
	local nearestZone = nil
	local nearestDist = 0.0
	for zone, settings in pairs(Config.Zones) do
		for _, zoneCoords in ipairs(settings.Coords) do
			local dist = #(coords - zoneCoords)
			if not nearestZone or dist < nearestDist then
				nearestDist = dist
				nearestZone = zone
			end
		end
	end
	if nearestZone and Config.Zones[nearestZone].DepthPrefix then
		if depth > 10.0 then
			nearestZone = "Deep "..nearestZone
		else
			nearestZone = "Shallow "..nearestZone
		end
	end
	return nearestZone
end

function StartFishing()
	TriggerEvent("disarmed")
	IsFishing = true
	exports.emotes:Play(Config.Anim, function(canceled)
		StopFishing()
	end)
end

function StopFishing()
	exports.emotes:Stop()
	IsFishing = false
end

RegisterNetEvent("inventory:use_FishingRod")
AddEventHandler("inventory:use_FishingRod", function(item, slotId)
	if IsFishing then
		StopFishing()
	else
		if IsPedInAnyVehicle(PlayerPedId(), true) then return end

		Slot = slotId
		StartFishing()
	end
end)