function User:SetFlag(flag, value)
	if type(flag) == "string" then
		flag = FlagEnums[flag]
	end

	if type(flag) ~= "number" then return end

	local flags = self.flags
	local mask = 1 << flag

	if not flags then
		flags = 0
	end

	if value and value ~= 0 then
		flags = flags | mask
	else
		flags = flags | (~mask)
	end

	self:Set("flags", flags)
end

function Main:SetFlag(source, ...)
	local user = self:GetUser(source)
	if not user then return end

	user:SetFlag(...)
end
Export(Main, "SetFlag")

function Main:HasFlag(source, ...)
	local user = self:GetUser(source)
	if not user then return false end

	return user:HasFlag(...)
end
Export(Main, "HasFlag")