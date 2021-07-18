--[[ Functions ]]--
function Mine(slotId)
	local site = nil
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for siteId, _site in ipairs(Config.Sites) do
		if #(coords - _site.Coords) < _site.Radius then
			site = siteId
			break
		end
	end

	if not site then
		exports.mythic_notify:SendAlert("error", "You can't mine here!", 7000)
		return
	end

	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = table.unpack(exports.oldutils:Raycast())

	if not retval or not Config.Materials[materialHash] or #(hitCoords - coords) > 2.0 then
		exports.mythic_notify:SendAlert("error", "You can't mine that!", 7000)
		return
	end

	local wasCanceled = false

	exports.mythic_notify:SendAlert("inform", "Mining...", 6000)

	exports.emotes:PerformEmote(Config.Anim, function()
		wasCanceled = true
	end)

	TriggerEvent("disarmed")

	Citizen.Wait(GetRandomIntInRange(6000, 8000))

	if wasCanceled then return end
	
	TriggerEvent("quickTime:begin", "linear", GetRandomFloatInRange(60.0, 80.0), function(status)
		exports.emotes:CancelEmote()
		
		if not status then return end
		
		TriggerServerEvent("mining:mine", site, slotId)
	end)
end

--[[ Events ]]--
RegisterNetEvent("inventory:use_Pickaxe")
AddEventHandler("inventory:use_Pickaxe", function(item, slotId)
	Mine(slotId)
end)