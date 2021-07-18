LastShowed = 0

--[[ Functions ]]--
function ShowLicense(license, source, name, id, info)
	license = Config.Licenses[license]
	if not license then return end

	if GetGameTimer() - LastShowed < 5000 then
		return
	end
	
	if type(id) == "string" and id:len() == 9 then
		id = id:gsub("%x%x%x", " %1")
	end
	
	local text = ([[
		[%s] showed their %s.
		<br>
		<br>Name: %s
		<br>ID: %s
	]]):format(source, license.Text, name, id)
		
	if info then
		for k, v in pairs(info) do
			text = text.."<br>"..k..": "..v
		end
	end
		
	exports.mythic_notify:SendAlert("inform", text, 30000)
	LastShowed = GetGameTimer()
end

--[[ Events ]]--
RegisterNetEvent("license:show")
AddEventHandler("license:show", ShowLicense)

AddEventHandler("license:clientStart", function()
	for k, v in ipairs(Config.Licenses) do
		if v.Coords then
			local callbackId = "InteractionLicense"..k
			exports.markers:CreateUsable(GetCurrentResourceName(), v.Coords, callbackId, ("Purchase %s - $%s"):format(v.Text, v.Price), 5.0, 2.5, v.Blip)
		
			AddEventHandler("markers:use_"..callbackId, function()
				if not exports.inventory:CanAfford(v.Price, 0, true) then return end
				TriggerServerEvent("license:buy", k)
			end)
		end

		RegisterNetEvent("inventory:use_"..v.Item)
		AddEventHandler("inventory:use_"..v.Item, function(item, slotId)
			local slot = exports.inventory:GetSlot(slotId)
			if not slot then return end
			
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local targets = { GetPlayerServerId(PlayerId()) }
			local players = exports.oldutils:GetNearbyPlayers()
			for k, serverId in ipairs(players) do
				local player = GetPlayerFromServerId(serverId)
				local playerPed = GetPlayerPed(player)
				if DoesEntityExist(playerPed) and #(GetEntityCoords(playerPed) - coords) < 6.0 then
					targets[#targets + 1] = serverId
				end
			end

			TriggerServerEvent("license:show", slotId, k, targets)
		end)
	end
end)