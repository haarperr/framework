exports.chat:RegisterCommand("a:goto", function(source, args, rawCommand, cb)
	local target = args[1]
	if target == "*" then
		target = -1
	else
		target = tonumber(target)
	end

	-- Self check.
	if source == target then
		cb("error", "You cannot goto yourself!")
		return
	end

	-- Check target.
	if type(target) ~= "number" or target <= 0 or not DoesEntityExist(GetPlayerPed(target)) then
		cb("error", "Target does not exist!")
		return
	end

	local ped = GetPlayerPed(target)
	if not DoesEntityExist(ped) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "teleported to",
		channel = "admin",
	})

	TriggerClientEvent(Admin.event.."goto", source, GetEntityCoords(ped), exports.instances:Get(target) or false, target)
end, {
	description = "Go to another player.",
	parameters = {
		{ name = "Target", description = "Person to go to." },
	}
}, "Mod")

exports.chat:RegisterCommand("a:bring", function(source, args, rawCommand, cb)
	local target = args[1]
	if target == "*" then
		target = -1
	else
		target = tonumber(target)
	end
	
	-- Self check.
	if source == target then
		cb("error", "You cannot bring yourself!")
		return
	end

	-- Check target.
	if type(target) ~= "number" or target == 0 or (target ~= -1 and not DoesEntityExist(GetPlayerPed(target))) then
		cb("error", "Target does not exist!")
		return
	end

	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "brought",
		channel = "admin",
	})

	TriggerClientEvent(Admin.event.."goto", target, GetEntityCoords(ped), exports.instances:Get(source) or false, source)
end, {
	description = "Bring another player to you.",
	parameters = {
		{ name = "Target", description = "Person to bring." },
	}
}, "Mod")