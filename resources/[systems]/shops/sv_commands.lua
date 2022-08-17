exports.chat:RegisterCommand("a:stockshop", function(source, args, command, cb)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	
	local stocked
	for id, shop in pairs(Main.shops) do
		local storage = shop.info.Storage
		if storage and #(coords - storage.Coords) < storage.Radius then
			if shop:StockContainer() then
				cb("success", "Stocked up!")
				stocked = id
			else
				cb("error", "Failed to stock.")
				stocked = false
			end
			break
		end
	end

	if stocked == nil then
		cb("error", "No shop to stock.")
	elseif stocked then
		exports.log:Add({
			source = source,
			verb = "stocked",
			noun = "storage",
			extra = stocked,
			channel = "admin",
		})
	end
end, {
	description = "Fill a shop with compatible items.",
}, "Admin")

exports.chat:RegisterCommand("a:stockshopall", function(source, args, command, cb)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	
	local stocked = 0
	for id, shop in pairs(Main.shops) do
		local storage = shop.info.Storage
		if storage then
			if shop:StockContainer() then
				cb("success", "Stocked up "..id.."!")
				stocked = stocked + 1
				exports.log:Add({
					source = source,
					verb = "stocked",
					noun = "storage",
					extra = id,
					channel = "admin",
				})
			else
				cb("error", "Failed to stock "..id.."!")
				stocked = false
			end
		end
		Citizen.Wait(500)
	end

	if stocked == nil then
		cb("error", "No shop to stock.")
	end
end, {
	description = "Fill all shops with compatible items.",
}, "Admin")