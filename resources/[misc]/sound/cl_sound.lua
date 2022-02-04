RegisterNetEvent("playSound", function(name, volume)
	SendNUIMessage({
		playSound = {
			name = name,
			volume = volume,
		},
	})
end)

RegisterNetEvent("playSound3D", function(name, coords, volume, range)
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	local dist = #(coords - pedCoords)

	volume = (1 / (dist / (range or 1.0) + 1.0)) * (volume or 1.0)
	if volume < 0.01 then return end

	SendNUIMessage({
		playSound = {
			name = name,
			volume = volume,
		},
	})
end)