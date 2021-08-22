exports.chat:RegisterCommand("a:revive", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	exports.log:Add({
		source = source,
		target = target > 0 and target or nil,
		verb = "revived",
		noun = target == -1 and "all" or nil,
	})

	TriggerClientEvent("health:revive", target, true)
end, {
	description = "Revive somebody.",
	parameters = {
		{ name = "Target", help = "Who to revive?" },
	}
}, -1, 25)

exports.chat:RegisterCommand("a:slay", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	exports.log:Add({
		source = source,
		target = target > 0 and target or nil,
		verb = "slayed",
		noun = target == -1 and "all" or nil,
	})

	TriggerClientEvent("health:slay", target)
end, {
	description = "Slay somebody.",
	parameters = {
		{ name = "Target", help = "Who to slay?" },
	}
}, -1, 25)