RegisterNetEvent("playSound", function(name, volume)
	SendNUIMessage({
		playSound = {
			name = name,
			volume = volume,
		},
	})
end)