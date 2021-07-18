Cams = {}
local Viewers = {}
local Spectating = {}

Citizen.CreateThread(function()
	while true do
		for viewer, _ in pairs(Viewers) do
			TriggerClientEvent("a-t:u", viewer, Cams)
		end
		for spectator, spectating in pairs(Spectating) do
			TriggerClientEvent("a-t:s", spectator, spectating, Cams[spectating])
		end
		Citizen.Wait(50)
	end
end)

Citizen.CreateThread(function()
	while true do
		for player, cam in pairs(Cams) do
			if GetPlayerLastMsg(player) >= 16384 then
				Cams[player] = nil
			end
		end
		Citizen.Wait(1000)
	end
end)

RegisterNetEvent("a-t:u")
AddEventHandler("a-t:u", function(coords, rotation)
	local source = source
	if type(coords) ~= "vector3" or type(rotation) ~= "vector3" then return end

	if not Cams[source] then
		Cams[source] = {}
	end
	Cams[source][1] = coords
	Cams[source][2] = rotation
end)

RegisterNetEvent("admin-tools:viewCams")
AddEventHandler("admin-tools:viewCams", function(value)
	local source = source
	local user = exports.user:GetUser(source)
	if not user then return end
	if user.power_level < 75 then return end

	if value then
		Viewers[source] = true
	else
		Viewers[source] = nil
		TriggerClientEvent("a-t:u", source, nil)
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	local cam = Cams[source]
	if cam then
		TriggerEvent("admin-tools:lastCam", cam)
		Cams[source] = nil
	end
end)

exports.chat:RegisterCommand("a:spectate", function(source, args, rawCommand)
	local target = tonumber(args[1])
	if not target or target <= 0 or GetPlayerEndpoint(target) == nil or target == Spectating[source] then
		Spectating[source] = nil
		TriggerClientEvent("a-t:s", source)
		return
	end

	Spectating[source] = target
end, {
	help = "Spectate somebody.",
	params = {
		{ name = "ID", help = "ID of the player" },
	}
}, paramCount or -1, 25)