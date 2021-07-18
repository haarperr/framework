exports.chat:RegisterCommand("fingerprint", function(source, args, rawCommand)
	if exports.jobs:GetGroup(source) ~= "Emergency" then
		TriggerClientEvent("notify:sendAlert", source, "error", "You must be on duty!")
		return
	end

	local target = tonumber(args[1])
	if not target then return end

	local character = exports.character:GetCharacter(target)
	if not character then return end

	local message = ("[%s] comes back to %s %s, %s."):format(target, character.first_name, character.last_name, character.license_text)
	TriggerClientEvent("chat:addMessage", source, message, "emergency")
end, {
	help = "",
	params = {
		{ name = "Target", help = "ID of the target." },
	}
}, 1)