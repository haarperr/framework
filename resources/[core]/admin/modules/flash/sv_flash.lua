local canFlash = true

exports.chat:RegisterCommand("a:flash", function(source, args, rawCommand)
	local target = tonumber(args[1])
	local reason = table.concat(args, " ")
	reason = reason:sub(args[1]:len() + 2)
	if not target then return end
	if not canFlash then return end

	canFlash = false

	exports.log:Add({
		source = source,
		target = target,
		verb = "flashed",
		extra = ("[%s] %s - %s"):format(target, exports.user:GetIdentifier(target, "steam"), reason),
		channel = "admin",
	})

	TriggerClientEvent("chat:addMessage", source, "You flashed ["..target.."]!")
	if reason:len() > 0 then TriggerClientEvent("chat:addMessage", target, reason) end

	SetTimeout(5000, function()
		canFlash = true
	end)

	TriggerClientEvent("admin-tools:flash", -1, target)

end, {
	description = "Flash a shitlord.",
	parameters = {
		{ name = "ID", help = "ID of the player" },
		{ name = "Reason", help = "Reason for the flash" },
	}
}, "Mod")