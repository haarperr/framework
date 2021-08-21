exports.chat:RegisterCommand("a:revive", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "revived",
	})

	TriggerClientEvent("health:revive", target)
end, {
	description = "Revive somebody.",
	parameters = {
		{ name = "Target", help = "Who to revive?" },
	}
}, -1, 25)

exports.chat:RegisterCommand("a:slay", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "slayed",
	})

	TriggerClientEvent("health:slay", target)
end, {
	description = "Slay somebody.",
	parameters = {
		{ name = "Target", help = "Who to slay?" },
	}
}, -1, 25)