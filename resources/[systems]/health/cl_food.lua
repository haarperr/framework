local function RegisterItems()
	exports.inventory:RegisterAction("Eat", Config.Eating)
	exports.inventory:RegisterAction("Drink", Config.Drinking)
	exports.inventory:RegisterAction("Alcohol", Config.Alcohol)
end

function UseFoodItem(item)
	local attributes = item.attributes
	if not attributes then return end

	if attributes.thirst then
		AddEffect("Thirst", -attributes.thirst)
	end
	if attributes.hunger then
		AddEffect("Hunger", -attributes.hunger)
	end
	if attributes.bac then
		AddEffect("Bac", attributes.bac)
	end
end

--[[ Events ]]--
RegisterNetEvent("inventory:use_Eat")
AddEventHandler("inventory:use_Eat", function(item, slot)
	UseFoodItem(item)
end)

RegisterNetEvent("inventory:use_Drink")
AddEventHandler("inventory:use_Drink", function(item, slot)
	UseFoodItem(item)
end)

RegisterNetEvent("inventory:use_Alcohol")
AddEventHandler("inventory:use_Alcohol", function(item, slot)
	UseFoodItem(item)
end)

AddEventHandler("inventory:loaded", function()
	RegisterItems()
end)

AddEventHandler("health:start", function()
	RegisterItems()
end)