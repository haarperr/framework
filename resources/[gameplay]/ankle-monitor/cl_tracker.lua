ActiveMonitors = {}

function HasTracker()
    if exports.inventory:HasItem("Ankle Monitor") then
        return true
    else
        return false
    end
end

function IsBeingTracked(playerId)
    for k, v in pairs(ActiveMonitors) do
        if v.playerId == playerId then
            return true, k
        end
    end
    return false, nil
end

function UpdateMapTracker(playerId)
    for k, v in pairs(ActiveMonitors) do
        if v.playerId == playerId then
            if v.blip == nil then
                local newBlip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
                SetBlipSprite(newBlip, 458)
                SetBlipColour(newBlip, 6)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Ankle Monitor - "..v.name)
                EndTextCommandSetBlipName(newBlip)
                v.blip = newBlip
            else
                SetBlipCoords(v.blip, v.coords.x, v.coords.y, v.coords.z)
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(GetRandomIntInRange(5000, 15000))
        if not exports.jobs:IsOnDuty("lssd") or exports.jobs:IsOnDuty("doc") or exports.jobs:IsOnDuty("dps") or exports.jobs:IsOnDuty("parole") then
            if HasTracker() then
                TriggerServerEvent("tracker:updateTracker", GetPlayerServerId(PlayerId()), GetEntityCoords(PlayerPedId(), false))
            end
        end
    end
end)

RegisterNetEvent("tracker:updateTracker")
AddEventHandler("tracker:updateTracker", function(id, coordinates, charName)
    if exports.jobs:IsOnDuty("lssd") or exports.jobs:IsOnDuty("doc") or exports.jobs:IsOnDuty("dps") or exports.jobs:IsOnDuty("parole") then
        local Tracked, Index = IsBeingTracked(id)
        if Tracked then
            ActiveMonitors[Index].coords = coordinates
        else
            table.insert(ActiveMonitors, {playerId = id, coords = coordinates, name = charName, blip = nil})
        end
        UpdateMapTracker(id)
    end
end)

RegisterNetEvent("tracker:removeTracker")
AddEventHandler("tracker:removeTracker", function(id)
    Citizen.CreateThread(function()
        if exports.jobs:IsOnDuty("lssd") or exports.jobs:IsOnDuty("doc") or exports.jobs:IsOnDuty("dps") or exports.jobs:IsOnDuty("parole") then
            for k, v in pairs(ActiveMonitors) do
                if v.playerId == id then
                    if DoesBlipExist(v.blip) then
                        RemoveBlip(v.blip)
                    end
                    exports.dispatch:Report("Emergency", "Ankle monitor anti-tampering system tripped. "..v.name.." has violated parole!", 0, v.coords, nil, { coords = v.coords, rotation = 0 })
                    ActiveMonitors[k] = nil
                    Wait(1)
                    break
                end
            end
        end
    end)
end)

RegisterNetEvent("inventory:move_AnkleMonitor")
AddEventHandler("inventory:move_AnkleMonitor", function(item, sourceSlotId, targetSlotId, sourceContainerId, targetContainerId)
    if targetContainerId ~= sourceContainerId and exports.inventory:GetContainerId() == sourceContainerId then
        TriggerServerEvent("tracker:removeTracker", GetPlayerServerId(PlayerId()))
    end
end)