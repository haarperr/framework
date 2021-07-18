RegisterCommand("businesses", function(source, args, command)
	local message = ""
	local businesses = exports.character:Get("businesses")
	local hasBusiness = false

	if businesses then
		for k, v in ipairs(businesses) do
			hasBusiness = true
			TriggerEvent("chat:addMessage", ("%s (%s) - $%s"):format(v.name, v.id, v.bank))
		end
	end

	if not hasBusiness then
		TriggerEvent("chat:addMessage", "You don't own any businesses!")
	end
end)