RegisterNetEvent("sound:play")
AddEventHandler("sound:play", function(soundFile, soundVolume)
	SendNUIMessage({
		transactionType = "playSound",
		transactionFile = soundFile,
		transactionVolume = soundVolume or 1.0
	})
end)