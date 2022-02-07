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

local function drawText(x, y, z, offsetX, offsetY, textInput, fontId, scale, padding, offset)
	if not offset then
		offset = vector2(0.0, 0.0)
	end

	SetTextColour(255, 255, 255, 255)
	SetTextScale(scale, scale)
	SetTextFont(fontId)
	SetTextCentre(true)

	SetDrawOrigin(x, y, z, 0)
	SetScriptGfxAlignParams(offsetX, offsetY, 1.0, 1.0)

	BeginTextCommandWidth("STRING")
	AddTextComponentString(textInput)
	
	local height = GetTextScaleHeight(scale, fontId)
	local width = EndTextCommandGetWidth(4)
	padding = (padding or 0.0) * scale
	
	SetTextEntry("STRING")
	AddTextComponentString(textInput)
	EndTextCommandDisplayText(0.0, 0.0)
	DrawRect(0.0, height * 0.6, width + padding, height + padding, 0, 255, 255, 64)

	ClearDrawOrigin()
	ResetScriptGfxAlign()
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local pos = GetFinalRenderedCamCoord()
		local rot = GetFinalRenderedCamRot()

		SendNUIMessage({
			cam = { pos.x, pos.y, pos.z, rot.x, rot.y, rot.z + 90.0 }
		})

		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	local lastFrame

	while true do
		local deltaTime = lastFrame and (GetGameTimer() - lastFrame) / 1000.0 or 0

		if GetGameTimer() - lastUpdate < 1000 then
			for serverId, data in pairs(lines) do
				local x, y, z = data[1], data[2], data[3]
				
				if #data >= 9 then
					data[10] = (data[10] or x) + data[7] * deltaTime
					data[11] = (data[11] or y) + data[8] * deltaTime
					data[12] = (data[12] or z) + data[9] * deltaTime

					x = data[10]
					y = data[11]
					z = data[12]
				end

				DrawLine(x, y, z, data[4], data[5], data[6], 0, 255, 255, 200)
				drawText(x, y, z + 0.2, 0, -0.01, serverId, 2, 0.3, 0.01)
			end
		end

		lastFrame = GetGameTimer()

		Citizen.Wait(0)
	end
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("draw", function(data, cb)
	cb(true)

	local newLines = {}
	local deltaTime = lastUpdate and (GetGameTimer() - lastUpdate) / 1000.0 or 0

	for serverId, camera in pairs(data) do
		serverId = tonumber(serverId)
		
		local x0, y0, z0 = camera[1], camera[2], camera[3]
		local x1, y1, z1 = fromRotation(camera[4], camera[5], camera[6])
		local x2, y2, z2

		local lastLine = lines[serverId]
		if lastLine and deltaTime > 0 then
			x2 = (x0 - lastLine[1]) / deltaTime
			y2 = (y0 - lastLine[2]) / deltaTime
			z2 = (z0 - lastLine[3]) / deltaTime
		end

		newLines[serverId] = {
			x0, y0, z0,
			x0 + x1 * lineSize, y0 + y1 * lineSize, z0 + z1 * lineSize,
			x2, y2, z2
		}
	end
	
	lines = newLines
	lastUpdate = GetGameTimer()
end)