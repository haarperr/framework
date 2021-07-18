Pos = vector3(0.0, 0.0, 0.0)
Playback = nil
Interval = 1
Intervals = {
	{ "minute", 60 },
	{ "hour", 3600 },
	{ "day", 86400 },
	{ "week", 604800 },
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not Playback do
			Citizen.Wait(1000)
		end

		Pos = GetFinalRenderedCamCoord()

		local rot = GetFinalRenderedCamRot(0)
		local fov = GetFinalRenderedCamFov()
		
		if IsDisabledControlJustPressed(0, 172) then
			Interval = math.min(Interval + 1, #Intervals)
			UpdateInterval()
		elseif IsDisabledControlJustPressed(0, 173) then
			Interval = math.max(Interval - 1, 1)
			UpdateInterval()
		end

		local target = Pos + exports.misc:FromRotation(rot + vector3(0, 0, 90))

		SendNUIMessage({
			camera = {
				pos = Pos,
				fov = fov,
				target = target,
			}
		})

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		while not Playback do
			Citizen.Wait(1000)
		end

		local scrollSpeed = Intervals[Interval][2]

		if IsDisabledControlPressed(0, 174) then
			Playback.time = Playback.time - scrollSpeed
			UpdateTime()
		elseif IsDisabledControlPressed(0, 175) then
			Playback.time = Playback.time + scrollSpeed
			UpdateTime()
		end
		
		if
			math.abs(Playback.time - (Playback.lastRequestTime or 0.0)) > 60.0 or
			(Playback.lastRequestPos and #(Playback.lastRequestPos - Pos) > 150.0)
		then
			Playback.lastRequestTime = Playback.time
			Playback.lastRequestPos = Pos
			TriggerServerEvent("playback:request", Pos, math.floor(Playback.time))
		end

		Citizen.Wait(500)
	end
end)

function UpdateTime()
	SendNUIMessage({ time = Playback.time })
end

function UpdateInterval()
	SendNUIMessage({ interval = Intervals[Interval][1] })
end

--[[ Events ]]--
RegisterNetEvent("playback:receive")
AddEventHandler("playback:receive", function(time, data)
	-- Citizen.CreateThread(function()
	-- 	while true do
	-- 		for k, v in ipairs(data) do
	-- 			local coords = GetEntityCoords(PlayerPedId())
	-- 			DrawLine(coords.x, coords.y, coords.z, v.pos_x, v.pos_y, v.pos_z, 255, 0, 0, 255)
	-- 		end

	-- 		Citizen.Wait(0)
	-- 	end
	-- end)

	SendNUIMessage({
		logs = data
	})
end)

RegisterNetEvent("playback:toggle")
AddEventHandler("playback:toggle", function(toggle, data)
	if data then
		Playback = {
			data = {},
			time = data.time,
		}

		UpdateTime()
	else
		Playback = nil
	end

	SendNUIMessage({ toggle = toggle })
end)