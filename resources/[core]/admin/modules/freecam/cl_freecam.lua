Freecam = {
	speed = 0.2,
}

function Freecam:Update()
	local camera = self.camera
	if not camera then return end

	local ped = PlayerPedId()
	local delta = GetFrameTime()

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

	-- Speeds.
	self.speed = math.min(math.max(self.speed + ((IsDisabledControlPressed(0, 241) and 0.1) or (IsDisabledControlPressed(0, 242) and -0.1) or 0.0), 0.1), 1.0)

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
		SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true)
		SetEntityHeading(ped, rotation.z)
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
		fov = 70.0,
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