--[[ Functions ]]--
AppHooks["lifeinvader"] = function(content)
	content = content or {}

	TriggerServerEvent("phone:loadAds")
	
	return false
end

RegisterNetEvent("phone:loadAds")
AddEventHandler("phone:loadAds", function(ads)
	LoadApp("lifeinvader", {
		messages = ads
	})
end)

RegisterNUICallback("updateAd", function(data)
	local message
	if data then
		message = data.message
	end
	TriggerServerEvent("phone:updateAd", message)
end)