RegisterCommand("a:ban", function(source, args, command)
	local target, duration, reason = table.unpack(args)
	Main:Ban(target, duration, reason)
end)

RegisterCommand("mimic", function(source, args, command)
	if source ~= 0 then return end

	local endpoint, user = args[1], tonumber(args[2])

	Main:Mimic(endpoint, user)
end, true)