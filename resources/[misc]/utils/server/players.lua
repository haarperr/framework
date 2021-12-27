PlayerUtil = {
	cooldowns = {},
}

--[[ Functions: PlayerUtil ]]--
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

--[[ Functions ]]--
function GetActivePlayers()
	local i = 0
	local n = GetNumPlayerIndices()

	return function()
		i = i + 1
		
		if i <= n then
			return tonumber(GetPlayerFromIndex(i - 1))
		end
	end
end

--[[ Events ]]--
AddEventHandler("playerDropped", function(reason)
	local source = source

	PlayerUtil.cooldowns[source] = nil
end)