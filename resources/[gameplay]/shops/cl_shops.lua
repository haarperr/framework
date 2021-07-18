Blips = {}
TextEntries = {}

AddEventHandler("shops:clientStart", function()
	if GetResourceState("cache") ~= "started" then return end

	for k, shop in pairs(Config.Shops) do
		local settings = Config.Types[shop.Type]
		local blip = settings.Blip
		if blip then
			local handle = AddBlipForCoord(shop.Coords.x, shop.Coords.y, shop.Coords.z)
			SetBlipSprite(handle, blip.id or 66)
			SetBlipAsShortRange(handle, true)
			SetBlipScale(handle, blip.scale or 1.0)
			SetBlipColour(handle, blip.color or 0)

			local label = blip.name or "Unknown"
			local key = "Markers_"..label

			if not TextEntries[label] then
				TextEntries[key] = label
				AddTextEntry(key, label)
			end

			BeginTextCommandSetBlipName(key)
			EndTextCommandSetBlipName(handle)
		end
	end
end)

exports("GetShops", function()
	return Config.Shops
end)

-- AddEventHandler("shops:stop", function()
	
-- end)