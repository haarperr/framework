function PlaySound3D(source, name, volume, distance)
	local source = source

	-- Get ped.
	local ped = GetPlayerPed(source)
	if not ped or not DoesEntityExist(ped) then return end

	-- Check coords.
	local coords = GetEntityCoords(ped)
	if not coords then return end

	-- Play sound.
	print(("[%s] is playing sound: %s"):format(source, name))
	
	exports.players:Broadcast(source, "playSound3D", name, coords, volume or 1.0, distance or 0.3)
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

	-- Play sound.
	PlaySound3D(source, name)
end)

--[[ Exports ]]--
exports("PlaySound3D", function(...)
	PlaySound3D(...)
end)