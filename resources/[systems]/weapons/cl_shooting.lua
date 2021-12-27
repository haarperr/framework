Shooting = {}

--[[ Functions: Shooting ]]--
function Shooting:UpdateShooting(weapon)
	local ped = PlayerPedId()

	if not IsPedShooting(ped) and not weapon then return false end

	if not weapon then
		local hasWeapon, _weapon = GetCurrentPedWeapon(ped)
		weapon = _weapon
	end

	if not weapon or weapon == `WEAPON_UNARMED` then return false end
	
	-- Vector maths.
	local coords = GetFinalRenderedCamCoord()
	local rotation = GetFinalRenderedCamRot()
	local direction = FromRotation(rotation + vector3(0, 0, 90))
	local target = coords + direction

	-- Raycast
	local target = coords + direction * (GetMaxRangeOfCurrentPedWeapon(ped) or 1000.0)
	local handle = StartShapeTestRay(coords.x, coords.y, coords.z, target.x, target.y, target.z, -1, ped, 4)
	local retval, didHit, hitCoords, surfaceNormal, entity = GetShapeTestResult(handle)

	didHit = didHit == 1

	-- if didHit then
	-- 	Citizen.CreateThread(function()
	-- 		for i = 1, 1000 do
	-- 			DrawLine(coords.x, coords.y, coords.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 0, 0, 200)
	-- 			Citizen.Wait(0)
	-- 		end
	-- 	end)
	-- end

	-- Update recoil.
	self:UpdateRecoil()

	-- Update cache.
	self.lastShot = GetGameTimer()
	self.shotTime = (self.shotTime or 0) + 200

	-- Trigger events.
	local slot = State.currentSlot

	TriggerEvent("shoot", didHit, coords, hitCoords, entity, hasWeapon and weapon)
	TriggerServerEvent("shoot", didHit, coords, hitCoords, entity ~= 0 and NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity), hasWeapon and weapon, slot and slot.slot_id)

	-- Update ammo.
	State.ammo = State.debug and 100 or math.max((State.ammo or 0) - 1, 0)
	State:UpdateAmmo()

	-- didHit, coords, hitCoords, entity, weapon, slotId

	return true
end

function Shooting:UpdateRecoil()
	local ped = PlayerPedId()
	local ratio = self.shotTime / 1000
	local offset = 0.0
	
	if IsPedSprinting(ped) or IsPedRunning(ped) then
		offset = 1.0
	elseif IsPedWalking(ped) then
		offset = 0.5
	end

	ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", GetRandomFloatInRange(0.018, 0.021) + ratio * 0.05 + offset * 0.05)
end

function Shooting:Update()
	local ped = PlayerPedId()

	local delta = self.lastUpdate and (GetGameTimer() - self.lastUpdate) or 0
	local force = false
	local isBomb = GetIsTaskActive(ped, 432)

	if isBomb and not self.isBombing then
		self.isBombing = true
	elseif not isBomb and self.isBombing then
		force = `WEAPON_STICKYBOMB`
		self.isBombing = nil
	end

	if not self:UpdateShooting(force) then
		if IsPedReloading(ped) then
			self.shotTime = 0.0
		else
			self.shotTime = self.shotTime and math.max(self.shotTime - delta * 2.0, 0) or 0
		end
	end

	self.lastUpdate = GetGameTimer()
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Shooting:Update()

		Citizen.Wait(0)
	end
end)