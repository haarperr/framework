function PlaySound3D(coords, name, volume, distance)
	exports.players:Broadcast(coords, "playSound3D", name, coords, volume or 1.0, distance or 0.3)
end

function PlaySoundEntity(entity, ...)
	if not DoesEntityExist(entity) then return end

	PlaySound3D(GetEntityCoords(entity), ...)
end

function PlaySoundPlayer(source, ...)
	local ped = GetPlayerPed(source)
	
	PlaySoundEntity(ped, ...)
end

--[[ Events ]]--
AddEventHandler("playSound", function(...)
	TriggerClientEvent("playSound", -1, ...)
end)

--[[ Events: Net ]]--
RegisterNetEvent("playSound3D", function(name)
	local source = source

	-- Check cooldonw.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Check input.
	if type(name) ~= "string" or name:len() > 64 then return end

	-- Print.
	print(("[%s] is playing sound: %s"):format(source, name))

	-- Play sound.
	PlaySoundPlayer(source, name)
end)

--[[ Exports ]]--
exports("PlaySoundEntity", function(...)
	PlaySoundEntity(...)
end)

exports("PlaySound3D", function(...)
	PlaySound3D(...)
end)

exports("PlaySoundPlayer", function(source, ...)
	PlaySoundPlayer(source, ...)
end)