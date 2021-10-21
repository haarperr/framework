function GetHex(identifier)
	if not identifier then return end

	if identifier:match(":") then
		local key, value = GetIdentifiers(identifier)
		if value then
			identifier = value
		else
			return
		end
	end
	
	local len = identifier:len()
	if len == 15 and identifier:sub(1, 7) == "1100001" then
		return identifier
	elseif len == 17 then
		return GetHex(string.format("%X", identifier))
	end
end

function GetIdentifiers(identifier)
	return identifier:match("([^:]+):([^:]+)")
end