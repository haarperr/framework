RegisterServerEvent("sound:play")
AddEventHandler("sound:play", function(soundFile, soundVolume)
	TriggerClientEvent("sound:play", source, soundFile, soundVolume)
end)

AddEventHandler("sound:playAll", function(soundFile, soundVolume)
	TriggerClientEvent("sound:playAll", -1, soundFile, soundVolume)
end)