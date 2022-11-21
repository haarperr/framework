local blip = 0

CreateThread(function()
    blip = AddBlipForCoord(-1654.08, -1101.47, 17.36)

    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 0)
    SetBlipSprite(blip, 266)
    SetBlipScale(blip, 0.6)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.BlipName)
    EndTextCommandSetBlipName(blip)
end)

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() == name then
        RemoveBlip(blip)
    end
end)