--[[ Commands ]]--
exports.chat:RegisterCommand("a:goto", function(source, args, rawCommand)
	local target = tonumber(args[1])
	if type(target) ~= "number" or target <= 0 or not DoesEntityExist(GetPlayerPed(target)) then return end

	local ped = GetPlayerPed(target)
	if not DoesEntityExist(ped) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "teleported to",
		channel = "admin",
	})
	TriggerClientEvent("admin-tools:goto", source, GetEntityCoords(ped), exports.instances:GetPlayerInstance(target))
end, {
	help = "",
	params = {
		{ name = "Target", help = "" },
	}
}, 1, Config.Teleport.PowerLevel)

exports.chat:RegisterCommand("a:bring", function(source, args, rawCommand)
	local target = args[1]
	if target == "*" then
		target = -1
	else
		target = tonumber(target)
	end
	if type(target) ~= "number" or target == 0 or (target ~= -1 and not DoesEntityExist(GetPlayerPed(target))) then return end

	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "brought",
		channel = "admin",
	})
	TriggerClientEvent("admin-tools:goto", target, GetEntityCoords(ped), exports.instances:GetPlayerInstance(source))
end, {
	help = "",
	params = {
		{ name = "Target", help = "" },
	}
}, 1, Config.Teleport.PowerLevel)