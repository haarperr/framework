local lines = {}
local lastUpdate = 0
local lineSize = 100.0

--[[ Functions ]]--
local function fromRotation(x, y, z)
	local pitch, yaw = (x % 360.0) / 180.0 * math.pi, (z % 360.0) / 180.0 * math.pi

	return
		math.cos(yaw) * math.cos(pitch),
		math.sin(yaw) * math.cos(pitch),
		math.sin(pitch)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local pos = GetFinalRenderedCamCoord()
		local rot = GetFinalRenderedCamRot()

		SendNUIMessage({
			cam = { pos.x, pos.y, pos.z, rot.x, rot.y, rot.z + 90.0 }
		})

		Citizen.Wait(50)
	end
end)

Citizen.CreateThread(function()
	while true do
		if GetGameTimer() - lastUpdate < 1000 then
			for serverId, data in pairs(lines) do
				DrawLine(data[1], data[2], data[3], data[4], data[5], data[6], 0, 255, 255, 128)
			end
		end

		Citizen.Wait(0)
	end
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("draw", function(data, cb)
	cb(true)

	lines = {}

	for serverId, camera in pairs(data) do
		local x0, y0, z0 = camera[1], camera[2], camera[3]
		local x1, y1, z1 = fromRotation(camera[4], camera[5], camera[6])

		lines[tonumber(serverId)] = { x0, y0, z0, x0 + x1 * lineSize, y0 + y1 * lineSize, z0 + z1 * lineSize }
	end
	
	lastUpdate = GetGameTimer()
end)