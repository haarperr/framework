local Ziptied = {}

Functions["ziptie"] = function(source, target, value)
	if value and Ziptied[target] then
		return false
	elseif not value and Ziptied[target] then
		exports.inventory:GiveItem(source, "Ziptie", 1)
		Ziptied[target] = nil

		return true
	elseif not value then
		return false
	end

	if not exports.inventory:HasItem(exports.inventory:GetPlayerContainer(source), "Ziptie") then
		return false
	end

	exports.inventory:TakeItem(source, "Ziptie", 1)

	Ziptied[target] = true

	return true
end

Functions["ziptie-breakout"] = function(source, target, value)
	if not Ziptied[source] then
		return
	end

	exports.inventory:GiveItem(target, "Ziptie", 1)

	Ziptied[source] = false
end