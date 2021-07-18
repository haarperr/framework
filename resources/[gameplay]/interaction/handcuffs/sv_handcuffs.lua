local Handcuffed = {}

Functions["handcuff"] = function(source, target, value)
	if value and Handcuffed[target] then
		return false
	elseif not value and Handcuffed[target] then
		exports.inventory:GiveItem(source, "Handcuffs", 1)
		Handcuffed[target] = nil

		return true
	elseif not value then
		return false
	end

	if not exports.inventory:HasItem(exports.inventory:GetPlayerContainer(source), "Handcuffs") then
		return false
	end

	exports.inventory:TakeItem(source, "Handcuffs", 1)

	Handcuffed[target] = true

	return true
end

Functions["handcuff-breakout"] = function(source, target, value)
	if not Handcuffed[source] then
		return
	end

	exports.inventory:GiveItem(target, "Handcuffs", 1)

	Handcuffed[source] = false
end