Freecam = {
	speed = 0.2,
	fov = 70.0,
}

function Freecam:Update()
	local camera = self.camera
	if not camera then return end

	local ped = PlayerPedId()
	local vehicle = IsPedInAnyVehicle(ped) and GetVehiclePedIsIn(ped) or nil
	local delta = GetFrameTime()

	-- Check vehicle.
	if vehicle and GetPedInVehicleSeat(vehicle, -1) ~= ped then
		vehicle = nil
	end

	-- Get input.
	local lookX = GetDisabledControlNormal(0, 1) -- Mouse left/right.
	local lookY = GetDisabledControlNormal(0, 2) -- Mouse up/down.

	local horizontal = GetDisabledControlNormal(0, 30) -- Left/right.
	local vertical = GetDisabledControlNormal(0, 31) -- Forward/back.
	local height = (IsDisabledControlPressed(0, 205) and -1.0) or (IsDisabledControlPressed(0, 206) and 1.0) or 0.0

	-- Calculate vectors.
	local forward = FromRotation(self.rotation + vector3(0, 0, 90))
	local right = Cross(forward, Up)
	local up = Cross(forward, right)

	-- Scrolling.
	local scroll = ((IsDisabledControlPressed(0, 241) and 1.0) or (IsDisabledControlPressed(0, 242) and -1.0) or 0.0)
	if IsDisabledControlPressed(0, 19) then -- Left alt.
		-- Changing fov.
		self.fov = math.min(math.max(self.fov - scroll * 10.0, 10.0), 100.0)
		camera.fov = self.fov
	else
		-- Changing speed.
		self.speed = math.min(math.max(self.speed + scroll * 0.1, 0.1), 1.0)
	end

	-- Get offsets.
	local speed = math.pow(self.speed, 2.0) * 400.0 * (IsDisabledControlPressed(0, 209) and 2.0 or 1.0)
	local rotation = self.rotation - vector3(lookY, 0.0, lookX) * 0.16 / delta
	local coords = self.coords + (forward * -vertical + right * horizontal + up * height) * delta * speed

	-- Following.
	local isFollowing = self.follow and DoesEntityExist(self.follow)
	if IsDisabledControlJustPressed(0, 251) then -- F.
		if isFollowing then
			self.follow = nil
		else
			local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast()
			if didHit then
				self.follow = entity
			end
		end

		isFollowing = not isFollowing
	end

	if isFollowing then
		local followCoords = GetEntityCoords(self.follow)
		rotation = ToRotation(Normalize(followCoords - coords))
		coords = coords + GetEntityVelocity(self.follow) * delta
	end

	-- Update camera.
	self.rotation = rotation
	self.coords = coords

	camera.rotation = self.rotation
	camera.coords = self.coords

	-- Update focus.
	SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)

	-- Other controls.
	if IsDisabledControlJustPressed(0, 69) then -- Left click.
		self:Deactivate()
	elseif IsDisabledControlJustPressed(0, 70) then -- Right click.
		SetEntityCoordsNoOffset(vehicle or ped, coords.x, coords.y, coords.z, true)
		
		if vehicle then
			SetEntityRotation(vehicle, 0.0, 0.0, rotation.z)
		else
			SetEntityHeading(ped, rotation.z)
		end
	end

	-- Disable controls.
	DisableAllControlActions(0)
end

function Freecam:Activate()
	if self.active then return end

	self.active = true
	self.coords = GetFinalRenderedCamCoord()
	self.rotation = GetFinalRenderedCamRot()

	self.camera = Camera:Create({
		coords = self.coords,
		rotation = self.rotation,
		fov = self.fov,
	})

	self.camera:Activate()
end

function Freecam:Deactivate()
	if not self.active then return end
	self.active = false

	if self.camera then
		self.camera:Destroy()
		self.camera = nil
	end

	-- Clear focus.
	ClearFocus()

	-- Temporary disable controls.
	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < 1000 do
			DisableControlAction(0, 24)
			DisableControlAction(0, 25)

			Citizen.Wait(0)
		end
	end)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Freecam.active then
			Freecam:Update()
		end

		Citizen.Wait(0)
	end
end)

--[[ Commands ]]--
RegisterKeyMapping("+nsrp_freecam", "Admin - Freecam", "KEYBOARD", "EQUALS")
RegisterCommand("+nsrp_freecam", function(source, args, command)
	if not exports.user:IsMod() then return end

	if Freecam.active then
		Freecam:Deactivate()
	else
		Freecam:Activate()
	end
end, true)