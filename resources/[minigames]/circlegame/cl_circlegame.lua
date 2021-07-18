Callback = nil

SetNuiFocus(false, false)

AddEventHandler("circlegame:create", function(data, callback)
    SendNUIMessage({type = "open", payload = data})
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
	SetPlayerControl(PlayerPedId(), false, 0)
    Callback = callback
end)

RegisterNetEvent("circlegame:syncFire")
AddEventHandler("circlegame:syncFire", function(Coords)
    StartScriptFire(Coords.x, Coords.y, Coords.z - 0.9, 10, 1, 1)
    StartScriptFire(Coords.x - 1, Coords.y - 1, Coords.z - 0.9, 10, 0, 1)
    StartScriptFire(Coords.x + 1, Coords.y + 1, Coords.z - 0.9, 10, 0, 1)
end)

RegisterNUICallback("closeGame", function(data, cb)
    Callback(data.won)
    SetNuiFocus(false, false)
	SetPlayerControl(PlayerPedId(), true, 0)
    if data.won then
        print("I won :)")
    else
        TriggerServerEvent("circlegame:createFire", GetEntityCoords(PlayerPedId(), false))
        print("I lost sadge")
    end
    cb('ok')
end)