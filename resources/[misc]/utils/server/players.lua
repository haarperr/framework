PlayerUtil = {
	cooldowns = {},
}

function PlayerUtil:CheckCooldown(source, duration, update)
	local cooldown = self.cooldowns[source]
	local isValid = not cooldown or os.clock() - cooldown > duration

	if update then
		self:UpdateCooldown(source)
	end
	
	return isValid
end

function PlayerUtil:UpdateCooldown(source)
	self.cooldowns[source] = os.clock()
end

AddEventHandler("playerDropped", function(reason)
	local source = source

	PlayerUtil.cooldowns[source] = nil
end)