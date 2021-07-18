--[[ Functions ]]--
AppHooks["bleeter"] = function(content)
	content = content or {}

	RequestMessages("bleeter", -1, "tweet", 0)
	
	return false
end