FlagEnums = {
	["CAN_PLAY_ANIMAL"] = 1,
	["CAN_PLAY_PEDS"] = 2,
	
	["IS_OWNER"] = 100,
	["IS_ADMIN"] = 101,
	["IS_MOD"] = 102,
	["IS_DEV"] = 103,
}

function User:HasFlag(flag)
	if not self.flags then
		return false
	end

	if type(flag) == "string" then
		flag = FlagEnums[flag]
	end

	if type(flag) ~= "number" then
		return false
	end

	local mask = 1 << flag

	return self.flags & mask ~= 0
end