DrawMarkers = {}
DrawTexts = {}
InForensics = false
IsPickingUp = false
IsViewing = false
LastBled = 0.0
LastShot = nil
LastWeapon = 0
NearestEvidence = nil
Response = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local player = PlayerId()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped, true)
		local heading = GetEntityHeading(ped)
		local isShooting = IsPedShooting(ped)
		local selectedWeapon = GetSelectedPedWeapon(ped)

		if IsPedSwimming(ped) then
			LastShot = nil
		elseif isShooting and not Config.Excluded[selectedWeapon] then
			LastShot = GetGameTimer()
			LastWeapon = selectedWeapon

			local didHit, impactCoord = GetPedLastWeaponImpactCoord(ped)
			
			local camCoords = GetFinalRenderedCamCoord()
			local camRot = GetFinalRenderedCamRot(0)
			local camForward = exports.misc:FromRotation(camRot + vector3(0, 0, 90))
			local rayTarget = camCoords + camForward * (GetMaxRangeOfCurrentPedWeapon(ped) or 1000.0)
			local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, rayTarget.x, rayTarget.y, rayTarget.z, -1, ped, 0)
			local retval, didHit, impactCoord, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

			if didHit == 0 then goto continue end

			if Config.Debug then
				Citizen.CreateThread(function()
					for i = 1, 1000 do
						DrawLine(camCoords.x, camCoords.y, camCoords.z, impactCoord.x, impactCoord.y, impactCoord.z, 255, 0, 0, 255)
						Citizen.Wait(1)
					end
				end)
			end

			local caliber = exports.inventory:GetItem(exports.weapons:GetCurrentSlot().item_id).ammo
			if caliber == nil then goto continue end
			
			local headingRad = heading / 180 * math.pi
			local shellDist = GetRandomFloatInRange(Config.MinCasingDist, Config.MaxCasingDist)
			local offsetMult = (shellDist - Config.MinCasingDist) / Config.MaxCasingDist
			local xOffset = GetRandomFloatInRange(-1.0, 1.0) * Config.CasingSpread * offsetMult
			local yOffset = GetRandomFloatInRange(-1.0, 1.0) * Config.CasingSpread * offsetMult
			local casingPos = vector3(coords.x + math.cos(headingRad) * shellDist + xOffset, coords.y + math.sin(headingRad) * shellDist + yOffset, coords.z)
			
			local hasGround, groundZ = GetGroundZFor_3dCoord(casingPos.x, casingPos.y, casingPos.z)
			if hasGround then
				casingPos = vector3(casingPos.x, casingPos.y, groundZ)
			end

			-- Register impact.
			local isAiming, aimingAt = GetEntityPlayerIsFreeAimingAt(player)
			local aimingAtType = GetEntityType(aimingAt)
			
			if aimingAtType ~= 1 and aimingAtType ~= 2 then
				Register(0, impactCoord, { weapon = exports.weapons:GetCurrentSlot() })
			end
			
			-- Register casing.
			Register(1, casingPos, { weapon = exports.weapons:GetCurrentSlot() })
			
			::continue::
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	Flashlight = GetHashKey("WEAPON_FLASHLIGHT")
	while true do
		local player = PlayerId()
		local ped = PlayerPedId()
		local selectedWeapon = GetSelectedPedWeapon(ped)
		local coords = GetEntityCoords(ped, true)
		local wasViewing = IsViewing
		local nearestDist = 0.0
		
		DrawTexts = {}
		DrawMarkers = {}
		NearestEvidence = nil

		if
			not Config.Debug and
			not (exports.emotes:GetCurrentEmote() or {}).ShowEvidence and
			not (selectedWeapon == Flashlight and IsPlayerFreeAiming(player))
		then
			IsViewing = false
			selectedWeapon = GetSelectedPedWeapon(ped)

			Citizen.Wait(400)
		else
			IsViewing = true
				
			if Response ~= nil then
				for	_, grid in ipairs(Response) do
					for	__, item in ipairs(grid) do
						local dist = #(item.coords - coords)
						
						if (dist > Config.MaxDistance) then goto continue end
	
						-- Check nearest evidence.
						if not item.destroyed and dist < Config.PickupDistance and (not NearestEvidence or dist < nearestDist) and Config.Types[item.itype].Pickup ~= nil then
							NearestEvidence = { item.coords, item.itype }
							nearestDist = dist
						end
						
						-- Check visibility.
						local visible, screenX, screenY = World3dToScreen2d(item.coords.x, item.coords.y, item.coords.z)
						
						if not (visible) then goto continue end
						
						-- Define draw settings.
						local settings = Config.Types[item.itype]
						local markerType = PassSettings(settings.Marker.Type, item)
						
						-- Marker draw calls.
						local mergeDist = 0.3
						local merged = false
						for k, v in ipairs(DrawMarkers) do
							local coords = vector3(v[2], v[3], v[4])
							if v[1] == markerType and #(item.coords - coords) < mergeDist then
								coords = (item.coords + coords) * 0.5
								
								v[2] = coords.x
								v[3] = coords.y
								v[4] = coords.z
								
								merged = true
								break
							end
						end
						
						if not merged then
							local alpha = math.max(math.min(math.floor((1.0 - dist / Config.MaxDistance) * 255), 255), 0)
							local itemScale = PassSettings(settings.Marker.Scale or 0.5, item)
							local markerOffset = PassSettings(settings.Marker.Offset, item)
							local col
							if item.destroyed then
								col = { r = 255, g = 0, b = 0 }
								alpha = math.floor(alpha * 0.2)
							else
								col = PassSettings(settings.Marker.Color, item)
							end
							
							DrawMarkers[#DrawMarkers + 1] = {markerType, item.coords.x, item.coords.y, item.coords.z + markerOffset, 0.0, 0.0, 0.0, 0.0, 180, 0.0, itemScale, itemScale, itemScale, col.r, col.g, col.b, alpha, false, true, 2, nil, nil, true}
						end
						
						-- Text draw calls.
						if dist < Config.MaxDistance * 0.5 then
							local text = PassSettings(settings.Marker.Text or settings.Name, item)
	
							merged = false
							for k, v in ipairs(DrawTexts) do
								if #(item.coords - v[3]) < mergeDist and v[1] == text then
									v[3] = (item.coords + v[3]) * 0.5
									v[4] = v[4] + 1
									merged = true
									break
								end
							end
							
							if not merged then
								DrawTexts[#DrawTexts + 1] = {text, dist, item.coords, 1}
							end
						end
						
						::continue::
					end
				end
			end
		end
		
		if IsViewing and not wasViewing then
			TriggerServerEvent("evidence:requestEvidence", true, coords)
			Debug("Requesting evidence")
			collectgarbage()
		elseif not IsViewing and wasViewing then
			TriggerServerEvent("evidence:requestEvidence", false)
			Debug("No longer requesting evidence")
			collectgarbage()
		end

		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		while not IsViewing do
			Citizen.Wait(500)
		end
		-- Drawing evidence.
		for k, v in ipairs(DrawTexts) do
			local visible, screenX, screenY = World3dToScreen2d(v[3].x, v[3].y, v[3].z)
			local alpha = math.max(math.min(math.floor((1.0 - v[2] / Config.MaxDistance * 2) * 255), 255), 0)
			local text

			if v[4] > 1 then
				text = ("%s x%s"):format(v[1], v[4])
			else
				text = v[1]
			end
			SetTextScale(0.0, 0.35)
			SetTextFont(4)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, alpha)
			SetTextDropShadow(1, 0, 0, 0, 255)
			SetTextEntry("STRING")
			SetTextCentre(true)
			AddTextComponentString(text)
			DrawText(screenX, screenY)
		end
		for k, v in ipairs(DrawMarkers) do
			DrawMarker(table.unpack(v))
		end
		-- Picking up evidence.
		if IsControlJustPressed(0, 46) and not IsPickingUp then
			if not exports.inventory:HasItem("Evidence Bag") then
				TriggerEvent("chat:notify", "You have nothing to put that in!", "error")
			elseif not NearestEvidence or not (Config.Types[NearestEvidence[2]] or {}).Pickup then
				TriggerEvent("chat:notify", "Cannot find evidence to pick up!", "error")
			else
				local pickingUp = NearestEvidence
				IsPickingUp = true
				exports.mythic_progbar:Progress(Config.PickupAction, function(wasCancelled)
					IsPickingUp = false
					if wasCancelled then return end
					TriggerServerEvent("evidence:pickup", table.unpack(pickingUp))
				end)
			end
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function Register(itype, coords, extra)
	if type(itype) == "string" then
		for _itype, typeSettings in pairs(Config.Types) do
			if typeSettings.Name == itype then
				itype = _itype
				break
			end
		end
	end
	TriggerServerEvent("evidence:register", itype, coords, extra)
	Debug("Registering", itype, coords, json.encode(extra))
end
exports("Register", Register)

function DidShoot(firearm)
	if firearm and GetWeaponDamageType(LastWeapon) ~= 3 then
		return false
	end
	return LastShot ~= nil and GetGameTimer() - LastShot < Config.GunResidueLifetime
end
exports("DidShoot", DidShoot)

function PassSettings(settings, ...)
	if type(settings) == "function" then
		return settings(...)
	end
	return settings
end

function BeginForensics()
	if InForensics then return end

	-- Job check.
	if not exports.jobs:IsOnDuty("paramedic") and not exports.jobs:IsOnDuty("detective") then
		TriggerEvent("chat:notify", "You must be on duty!", "error")
		return
	end

	-- Start.
	InForensics = true
	
	-- Notify.
	TriggerEvent("chat:notify", "Starting forensics... Select the first piece of evidence.", "inform")

	-- Emote.
	exports.emotes:Play("clipboard")

	-- Open inventory.
	exports.inventory:ToggleMenu(true)
	exports.inventory:ClearSelection()

	-- Check that the inventory is open.
	local sourceSlot, targetSlot, lastId

	::restart::

	while exports.inventory:IsOpen() do
		Citizen.Wait(100)

		-- Get the current item.
		local selection = exports.inventory:GetSelection()
		local slot
		
		-- Check that something is selected in the player's inventory.
		if selection and selection.containerIndex == 0 then
			slot = exports.inventory:GetSlot(selection.slotId)
			local item = exports.inventory:GetItem(slot[1])

			-- Check that the item is evidence.
			if lastId == selection.slotId then
				TriggerEvent("chat:notify", "That's the same thing!", "error")
				exports.inventory:ClearSelection()
				
				goto restart
			elseif not item or item.name ~= "Sealed Evidence Bag" then
				TriggerEvent("chat:notify", "That's not evidence...", "error")
				exports.inventory:ClearSelection()
				
				goto restart
			end

			lastId = selection.slotId
		else
			goto restart
		end
		
		if not sourceSlot then
			-- Assign the first evidence.
			sourceSlot = slot
			exports.inventory:ClearSelection()
			TriggerEvent("chat:notify", "Now select the second piece of evidence...", "inform")
		elseif not targetSlot then
			-- Assign the second evidence.
			targetSlot = slot
			exports.inventory:ToggleMenu(false)
			break
		end
	end

	-- Process evidence.
	if sourceSlot and targetSlot then
		TriggerEvent("chat:notify", "Processing...", "inform")
		Citizen.Wait(2500)

		TriggerEvent("chat:notify", "Done!", "inform")
		Citizen.Wait(1000)
		
		local sourceExtra = sourceSlot[4] or {}
		local targetExtra = targetSlot[4] or {}
		local result = false

		if sourceExtra[2] and targetExtra[2] then
			sourceExtra[2][1] = nil
			targetExtra[2][1] = nil

			result = json.encode(sourceExtra[2]) == json.encode(targetExtra[2])
		end
		
		if result then
			TriggerEvent("chat:notify", "Match!", "success")
		else
			TriggerEvent("chat:notify", "No match...", "error")
		end

		Citizen.Wait(2000)
	else
		-- Notify.
		TriggerEvent("chat:notify", "Stopping forensics...", "inform")
	end

	-- Stop emoting.
	exports.emotes:Stop()

	-- End.
	InForensics = false
end

--[[ Events ]]--
AddEventHandler("evidence:clientStart", function()
	for k, coords in ipairs(Config.Forensics) do
		local callbackId = "Evidence-Forensics"..tostring(k)
		exports.markers:CreateUsable(GetCurrentResourceName(), coords, callbackId, "Forensics", 5.0, 2.5)

		AddEventHandler("markers:use_"..callbackId, BeginForensics)
	end
end)

RegisterNetEvent("evidence:requestDrop")
AddEventHandler("evidence:requestDrop", function(token)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped) - vector3(0.0, 0.0, GetEntityHeightAboveGround(ped))

	TriggerServerEvent("evidence:receiveDrop", coords, token)
end)

RegisterNetEvent("evidence:receiveEvidence")
AddEventHandler("evidence:receiveEvidence", function(scenes)
	Response = scenes
	Debug("Receiving response")
	--TriggerServerEvent("evidence:requestEvidence", true, GetEntityCoords(PlayerPedId(), true))
end)

RegisterNetEvent("evidence:register")
AddEventHandler("evidence:register", function(...)
	Register(...)
end)

RegisterNetEvent("inventory:use_Bleach")
AddEventHandler("inventory:use_Bleach", function(item, slotId)
	local slot = exports.inventory:GetSlot(slotId)
	if not slot then return end

	exports.mythic_progbar:Progress(Config.CleanAction, function(wasCancelled)
		if wasCancelled then return end
		TriggerServerEvent("evidence:clearArea", slotId, GetEntityCoords(PlayerPedId()))
	end)
end)

AddEventHandler("grids:enter"..Config.GridSize, function()
	if not IsViewing then return end
	TriggerServerEvent("evidence:requestEvidence", true, GetEntityCoords(PlayerPedId()))
	Debug("Requesting evidence")
end)

AddEventHandler("gameEventTriggered", function(name, args)
	if name ~= "CEventNetworkEntityDamage" then return end
	
	local ped = PlayerPedId()
	local targetEntity, sourceEntity, _, _, _, fatalDamage, weaponUsed = table.unpack(args)
	local damageType = GetWeaponDamageType(weaponUsed)
	-- Bullet = 3
	-- Hit by car/fall/other = 0
	local targetType = GetEntityType(targetEntity)
	local sourceType = GetEntityType(sourceEntity)
	-- print(string.format("target: %s (%s), source: %s (%s), bone: %s, fatal: %s, weapon used: %s, damage type: %s", args[1], targetType, args[2], sourceType, args[3], args[4], args[5], damageType))
	
	local isSelf = ped == targetEntity
	local isNpc = ped == sourceEntity and targetType == 1 and not IsPedAPlayer(targetEntity)

	if not isSelf and not isNpc then return end
		
	-- Add lead.
	
	-- Burnt flesh.
	
	-- Get position.
	local coords
	if isSelf then
		coords = GetEntityCoords(ped, true)
		coords = vector3(coords.x, coords.y, coords.z - GetEntityHeightAboveGround(ped))
	else
		coords = GetEntityCoords(targetEntity, true)
		coords = vector3(coords.x, coords.y, coords.z - GetEntityHeightAboveGround(targetEntity))
	end

	local isFall = weaponUsed == GetHashKey("WEAPON_FALL")
	local isRanOver = weaponUsed == GetHashKey("WEAPON_RUN_OVER_BY_CAR")
	local isHit = not isFall and (isRanOver or weaponUsed == GetHashKey("WEAPON_RAMMED_BY_CAR"))
	local isShot = damageType == 3
	local isMeleed = damageType == 2
	local isBlood = isFall or isHit or isShot or isMeleed
	local isSplat = isFall
	local isImpression = isFall or isRanOver

	if isFall then
		Register(2, coords)
	end

	-- Add blood.
	if isBlood and GetGameTimer() - LastBled > 0.5 then
		-- LastBled = GetGameTimer()

		local id = NetworkGetNetworkIdFromEntity(targetEntity)
		local rad = GetRandomFloatInRange(0.0, 2.0 * math.pi)
		local offsetR = GetRandomFloatInRange(1.0 - Config.BloodSplash.Deviation, 1.0)
		local offsetMin = Config.BloodSplash.MinSpread * offsetR
		
		Register(3, coords + vector3(math.cos(rad) * offsetMin, math.sin(rad) * offsetMin, 0))
		
		if isSplat then
			local speed = GetEntitySpeed(ped)
			local offsetMax = Config.BloodSplash.MaxSpread * math.min(speed / Config.BloodSplash.MaxSpeed, 1.0) * offsetR
			Register(3, coords + vector3(math.cos(rad) * offsetMax, math.sin(rad) * offsetMax, 0))
		end
	end
	--print(json.encode(args))
	--print(GetWeaponDamageType(weaponUsed))
end)