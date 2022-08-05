--[[ Threads ]]--
Citizen.CreateThread(function()
	for k, vendor in ipairs(Config.Vendors) do
		if not vendor.Items then goto skip end
		
		local interactions = {}
		local embedded = {}

		for _k, item in ipairs(vendor.Items) do
			embedded[_k] = {
				id = ("vendor-%s-%s"):format(k, _k),
				text = item.Name,
				cash = exports.inventory:CountMoney() or 0.0,
				event = "vendor",
			}
		end

		for __k, model in ipairs(vendor.Models) do
			exports.interact:Register({
				id = ("vendor-%s"):format(k),
				embedded = embedded,
				model = model,
			})
		end
		
		::skip::
	end
end)

--[[ Events ]]--
AddEventHandler("interact:on_vendor", function(interactable)
	TriggerServerEvent("vendor:purchase", source)
end)

--[[Animation]]--
function playAnim(animDict, animName)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)
	RemoveAnimDict(animDict)
end