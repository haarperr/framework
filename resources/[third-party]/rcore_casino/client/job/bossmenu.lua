CreateThread(function()
    local bossMenu = createMarker()
    bossMenu.setType(1)
    bossMenu.setPosition(OfficeBossMarkerPosition)
    bossMenu.setScale(vector3(1, 1, 1))
    bossMenu.setInRadius(1.3)
    bossMenu.setColor({
        r = 255,
        g = 255,
        b = 255,
        a = 35
    })

    bossMenu.setRotation(true)
    bossMenu.setKeys({38})

    bossMenu.on("enter", function()
        ShowHelpNotification(Translation.PRESS_TO_OPEN_BOSSMENU)
    end)

    bossMenu.on("leave", function()
        if ESX then
            if ESX.UI then
                ESX.UI.Menu.CloseAll()
            end
        end

        -- I didnt found any way to close the qbcore menu seems like there isnt anything for this?
        -- if you know the answer please contact us support and dont hesitate to help us!
        if QBCore then

        end
    end)

    bossMenu.setRenderJob(Config.JobName)
    bossMenu.setGrades({
        [Config.BossName] = true
    })
    bossMenu.setMinGrade(Config.BossGrade)
    bossMenu.on("key", function()
        if Framework.Active == 1 then
            TriggerEvent(Events.ES_BOSS_MENU, Config.JobName, function(data, menu)
                menu.close()
            end, {
                withdraw = true,
                deposit = true,
                wash = true,
                employees = true,
                grades = true
            })
        elseif Framework.Active == 2 then
            TriggerEvent(Events.QB_BOSS_MENU)
        end
    end)

    local vehReplacenent = createMarker()
    vehReplacenent.setType(36)
    vehReplacenent.setPosition(vector3(934.481, -1.952, 78.764))
    vehReplacenent.setScale(vector3(1, 1, 1))
    vehReplacenent.setRotation(true)
    vehReplacenent.setOnlyVehicle(1)
    vehReplacenent.setInRadius(3.0)
    vehReplacenent.setKeys({38})
    vehReplacenent.setColor({
        r = 255,
        g = 255,
        b = 255,
        a = 125
    })
    vehReplacenent.setRenderJob(Config.JobName)
    vehReplacenent.setGrades({
        [Config.BossName] = true
    })
    vehReplacenent.setMinGrade(1)

    vehReplacenent.on("enter", function()
        ShowHelpNotification(Translation.PRESS_TO_GIFT_LUCKYWHEEL_VEH)
    end)

    vehReplacenent.on("key", function(key)
        CasinoGarage_OnInteraction()
    end)

    vehReplacenent.on("leave", function()
        if ESX then
            if ESX.UI then
                ESX.UI.Menu.CloseAll()
            end
        end

        -- I didnt found any way to close the qbcore menu seems like there isnt anything for this?
        -- if you know the answer please contact us support and dont hesitate to help us!
        if QBCore then

        end
    end)

    if Config.LeaveThroughTeleport then
        local enterTeleport = createMarker()
        enterTeleport.setActivity("casinoteleporter")
        enterTeleport.setType(0)
        enterTeleport.setPosition(Config.EnterCheckpointPosition)
        enterTeleport.setScale(vector3(0.5, 0.5, 0.5))
        enterTeleport.setRotation(true)
        enterTeleport.setInRadius(1.0)
        enterTeleport.setKeys({38})
        enterTeleport.setColor({
            r = 255,
            g = 255,
            b = 255,
            a = 125
        })

        enterTeleport.on("enter", function()
            ShowHelpNotification(Translation.PRESS_TO_ENTER_CASINO)
        end)

        enterTeleport.on("key", function(key)
            CreateThread(function()
                DoScreenFadeOut(500)
                Wait(500)
                SetEntityCoordsNoOffset(PlayerPedId(), Config.EnterPosition)
            end)
        end)
    end
end)
