Containers = {}

--[[ Functions ]]--
function CreateShops()
	for k, shop in ipairs(Config.Shops) do
		local settings = Config.Types[shop.Type]
		local slots = {}
		
		for k, slot in ipairs(settings.Items) do
			local item = exports.inventory:GetItem(slot[1])
			if item then
				slots[k] = {item.id, -1, 1.0, {slot[2], slot[3]}}
			end
		end
		
		local container = exports.inventory:CreateContainer(shop.Coords, "shop", slots, shop.Name, true, settings.Conditions)
		Containers[k] = container
	end
end
AddEventHandler("inventory:loaded", CreateShops)

--[[ Events ]]--
AddEventHandler("shops:start", function()
	if exports.inventory:IsLoaded() then
		CreateShops()
	end
end)