Nui = {}

RegisterNUICallback("init", function(data, cb)
	cb(true)
	Nui.ready = true
end)

RegisterNetEvent("admin:sendNui", function(...)
	SendNUIMessage(...)
end)