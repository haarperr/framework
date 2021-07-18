Main = Main or {}

--[[ Events ]]--
AddEventHandler("onClientResourceStart", function(resourceName)
	TriggerEvent(resourceName..":clientStart")
	TriggerServerEvent(resourceName..":ready")
end)

AddEventHandler("onClientResourceStop", function(resourceName)
	TriggerEvent(resourceName..":clientStop")
end)