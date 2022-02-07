Nui = {}

RegisterNUICallback("init", function(data, cb)
	cb(true)
	Nui.ready = true
end)

RegisterNetEvent("admin:sendNui", function(...)
	SendNUIMessage(...)
end)

RegisterNetEvent("admin:auth", function(port, token)
	SendNUIMessage({
		connect = {
			serverId = GetPlayerServerId(PlayerId()),
			endpoint = GetCurrentServerEndpoint(),
			port = port,
			token = token,
		}
	})
end)