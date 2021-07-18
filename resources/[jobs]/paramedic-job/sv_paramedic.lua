exports.chat:RegisterCommand("doa", function(source, args, rawCommand)
	if not exports.jobs:IsInEmergency(source) then
		TriggerClientEvent("notify:sendAlert", source, "error", "You must be on duty!")
		return
	end

	local target = tonumber(args[1])
	local character = exports.character:GetCharacter(target or 0)
	
	if not character then
		TriggerClientEvent("notify:sendAlert", source, "error", "Invalid target!")
		return
	end

	exports.interaction:SendConfirm(source, target, "You are being reported dead", function(response)
		if response then
			exports.character:Kill(target)

			TriggerClientEvent("notify:sendAlert", source, "error", "They're dead now...")
		else
			TriggerClientEvent("notify:sendAlert", source, "error", "They've refused to die!")
		end
	end, true)

	-- TriggerClientEvent("chat:addMessage", source, message, "emergency")
end, {
	help = "Send a confirmation to kill somebody.",
	params = {
		{ name = "Target", help = "Person to report dead." },
	}
}, 1)