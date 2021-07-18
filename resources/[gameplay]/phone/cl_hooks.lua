AppHooks["options"] = function(content)
	local payload = {
		number = exports.character:Get("phone_number")
	}

	return payload
end