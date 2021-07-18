RegisterNetEvent("interaction:dice")
AddEventHandler("interaction:dice", function()
	local ped = PlayerPedId()

	exports.emotes:PerformEmote({
		Dict = "gestures@miss@fra_0",
		Name = "lamar_fkn0_cjae_01_g2",
		Flag = 48,
	})
end)

for k, itemName in ipairs({ "Penny", "Nickel", "Dime", "Quarter" }) do
	local eventName = "inventory:use_"..itemName

	RegisterNetEvent(eventName)
	AddEventHandler(eventName, function(item, slotId)
		ExecuteCommand("coin")
	end)
end

for k, itemName in ipairs({ "Die", "Even Die", "Odd Die" }) do
	local eventName = "inventory:use_"..itemName:gsub("%s", "")

	RegisterNetEvent(eventName)
	AddEventHandler(eventName, function(item, slotId)
		local words = {}
		for word in itemName:gmatch("%w+") do
			table.insert(words, word)
		end

		if #words > 1 then
			ExecuteCommand("roll 6 "..words[1])
		else
			ExecuteCommand("roll 6")
		end
	end)
end

RegisterNetEvent("inventory:use_ScratchOff")
AddEventHandler("inventory:use_ScratchOff", function(item, slotId)
	local shops = exports.shops:GetShops()
	local coords = GetEntityCoords(PlayerPedId())
	local isNear = false
	for k, shop in ipairs(shops) do
		if shop.Type == "Convenience" then
			local dist = #(coords - shop.Coords)
			if dist < 5.0 then
				isNear = true
				break
			end
		end
	end
	if not isNear then
		exports.mythic_notify:SendAlert("error", "I have to do this at a convenience store...", 7000)
		return
	end

	exports.emotes:PerformEmote({
		Dict = "amb@world_human_clipboard@male@idle_a",
		Name = "idle_c",
		Flag = 49,
	})

	TriggerEvent("quickTime:begin", "linear", GetRandomFloatInRange(15.0, 25.0), function(status)
		exports.emotes:CancelEmote()
		TriggerServerEvent("interaction:scratchOff", slotId, status)
		if status then
			exports.mythic_notify:SendAlert("success", "You've won!", 7000)
		else
			exports.mythic_notify:SendAlert("error", "You've lost...", 7000)
		end
	end)
end)