RegisterCommand("a:ban", function(source, args, command)
	local target, duration, reason = table.unpack(args)
	Main:Ban(target, duration, reason)
end)

RegisterCommand("mimic", function(source, args, command)
	if source ~= 0 then return end

	local endpoint, user = args[1], tonumber(args[2])

	Main:Mimic(endpoint, user)
end, true)

RegisterCommand("whitelist", function(source, args, command)
	if source ~= 0 then return end

	local action = args[1]
	local hex = GetHex(args[2])

	local toAdd = action == "add"
	local toRemove = not toAdd and action == "remove"

	if hex and (toAdd or toRemove) then
		if Main:Whitelist(hex, toAdd) then
			print(("steam:%s %s whitelist"):format(hex, toAdd and "added to" or "removed from"))
		else
			print(("%s is already %s"):format(hex, toAdd and "whitelisted" or "unwhitelisted"))
		end
	else
		print("Invalid format: whitelist <add/remove> <Steam hex or decimal>")
	end
end)