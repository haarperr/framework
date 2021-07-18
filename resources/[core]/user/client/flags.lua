function Main:HasFlag(...)
	local user = self:GetUser()
	if not user then return false end

	return user:HasFlag(...)
end
Export(Main, "HasFlag")