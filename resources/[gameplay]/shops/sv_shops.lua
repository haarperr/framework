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

--[[ Commands ]]--
exports.chat:RegisterCommand("a:debugShop", function(source, args, command)
	local ped = GetPlayerPed(source) or 0
	if not DoesEntityExist(ped) then return end
	local coords = GetEntityCoords(ped)

	local items = exports.inventory:GetItems()
	local shops = {}
	local maxSlots = 100

	table.sort(items, function(a, b)
		return ((b or {}).id or 1000000) > ((a or {}).id or 1000000)
	end)

	local slots = {}

	for k, v in pairs(items) do
		print(k,v)
	end

	for k, v in ipairs(items) do
		slots[#slots + 1] = { v.id, -1, 1.0, {0, 0} }
		if #slots >= maxSlots or k == #items - 1 then
			exports.inventory:CreateContainer(coords, "shop", slots, "Debug Shop", true)
			coords = coords + vector3(1.0, 0.0, 0.0)
			slots = {}
		end
	end
end, {}, -1, 255)