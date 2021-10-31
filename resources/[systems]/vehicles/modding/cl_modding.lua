Modding = {
	items = {},
}

--[[ Functions ]]--
function Modding:RegisterItem(name, callback)
	self.items[name] = callback
end

function Modding:InitCam()
	local vehicle = self.vehicle
	local coords = GetEntityCoords(vehicle)
	local camera = Camera:Create({
		lookAt = vehicle,
		fov = 70.0,
		shake = {
			type = "HAND_SHAKE",
			amount = 0.1,
		}
	})

	camera:Activate()
	
	self.center = coords
	self.camera = camera

	self:UpdateCam()
end

function Modding:UpdateCam()
	local camera = self.camera
	if not camera then return end
	
	-- Calculate offset.
	local horizontal = math.rad(self.horizontal or 0.0)
	local vertical = self.vertical or 0.5
	local height = (self.height or 0.5) * 2.0 + 0.5
	local radius = self.length * (1.5 + vertical * 0.5)
	local offset = vector3(math.cos(horizontal) * radius, math.sin(horizontal) * radius, height)

	-- Set coords.
	camera.coords = self.center + offset

	-- Left and right.
	if IsDisabledControlPressed(0, 35) then
		self.horizontal = (self.horizontal or 0.0) + 90.0 * GetFrameTime()
	elseif IsDisabledControlPressed(0, 34) then
		self.horizontal = (self.horizontal or 0.0) - 90.0 * GetFrameTime()
	end

	-- Forward and back.
	if IsDisabledControlPressed(0, 32) then
		self.vertical = math.max((self.vertical or 0.5) - 1.0 * GetFrameTime(), 0.0)
	elseif IsDisabledControlPressed(0, 33) then
		self.vertical = math.min((self.vertical or 0.5) + 1.0 * GetFrameTime(), 1.0)
	end

	-- Up and down.
	if IsDisabledControlPressed(0, 44) then
		self.height = math.min((self.height or 0.5) + 1.0 * GetFrameTime(), 1.0)
	elseif IsDisabledControlPressed(0, 46) then
		self.height = math.max((self.height or 0.5) - 1.0 * GetFrameTime(), 0.0)
	end

	-- Disable controls.
	DisableControlAction(0, 30)
	DisableControlAction(0, 31)
	DisableControlAction(0, 44)
	DisableControlAction(0, 46)

	-- Lights!
	DrawLightWithRange(self.center.x, self.center.y, self.center.z + 10.0, 255, 255, 255, 20.0, 2.0)
end

--[[ Events ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	if not NearestVehicle then return end

	local callback = Modding.items[item.name]
	if not callback then return end

	callback(Modding, NearestVehicle, "notepad")
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Modding:UpdateCam()
		Citizen.Wait(0)
	end
end)