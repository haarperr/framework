QBCore = nil
ESX = nil
PlayerData = {}

--- will return player data
function GetPlayerData()
    return PlayerData
end

function RefreshPlayerData()
    if Framework.Active == 1 then
        PlayerData = ESX.GetPlayerData()
    elseif Framework.Active == 2 then
        PlayerData = UpdatePlayerDataForQBCore()
    end
    return PlayerData
end

function IsPlayerWorkingAtCasino()
    return (PlayerData.job and PlayerData.job.name == Config.JobName)
end

--- @param job string
--- @param GradeArray table
--- will return true/False if player is in this grade.
function IsAtJob(job, GradeArray, MinGrade, MaxGrade)
    if PlayerData == nil or PlayerData.job == nil then
        return false
    end

    if not MaxGrade then
        MaxGrade = MinGrade
    end

    local gradeLevel = PlayerData.job.grade
    if not gradeLevel then
        gradeLevel = 0
    end

    if GradeArray == nil then
        return PlayerData.job.name == job and gradeLevel >= MinGrade and gradeLevel <= MaxGrade
    end

    return PlayerData.job.name == job and (GradeArray[PlayerData.job.grade_name] or (gradeLevel >= MinGrade and gradeLevel <= MaxGrade))
end

function RemovePlayerHunger(itemName)
    if Framework.Active == 1 then
        TriggerEvent('esx_status:add', 'hunger', 200000)
    end
    if Framework.Active == 2 then
        TriggerEvent("consumables:client:Eat", itemName)
    end
end

function RemovePlayerThirst(itemName)
    if Framework.Active == 1 then
        TriggerEvent('esx_status:add', 'thirst', 200000)
    end
    if Framework.Active == 2 then
        TriggerEvent("consumables:client:Drink", itemName)
    end
end

if Framework.Active == 1 then
    CreateThread(function()
        GetCoreObject(Framework.Active, Framework.ES_EXTENDED_RESOURCE_NAME, function(object)
            ESX = object
            if ESX and ESX.IsPlayerLoaded() then
                PlayerData = ESX.GetPlayerData()
                TriggerEvent("rcore_casino:PlayerDataLoaded")
            end
        end)
    end)

    RegisterNetEvent(Events.ES_PLAYER_LOADED, function(data)
        PlayerData = data
        TriggerEvent("rcore_casino:DataHasChanged")
    end)

    RegisterNetEvent(Events.ES_PLAYER_JOB_UPDATE, function(data)
        PlayerData.job = data
        TriggerEvent("rcore_casino:DataHasChanged")
    end)
end

if Framework.Active == 2 then
    function UpdatePlayerDataForQBCore()
        local pData = QBCore.Functions.GetPlayerData()

        local jobLabel = "none"
        local jobName = "none"
        local gradeName = "none"
        local grade = 0

        local grade_label = "none"
        local grade_salary = 0

        if pData.job then
            jobName = pData.job.name or "none"
            jobLabel = pData.job.label or "none"

            -- I am not sure if I should check if its nil or not so I will just make sure so it wont break anything.
            if pData.job.grade then
                local gradeData = pData.job.grade
                gradeName = gradeData.name

                if gradeData.level then
                    grade = gradeData.level
                end

                if gradeData.grade_label then
                    grade_label = gradeData.grade_label or "none"
                end

                if gradeData.grade_salary then
                    grade_salary = gradeData.grade_salary or 0
                end
            elseif pData.job.grades then
                grade = GetGreatestNumber(pData.job.grades)
            end
        end

        local stacked = {}
        local inventory = {}

        if pData.items then
            for slot = 1, 50, 1 do
                local v = pData.items[slot]
                if v then
                    if stacked[v.name] then
                        stacked[v.name] = stacked[v.name] + v.amount
                    else
                        stacked[v.name] = v.amount
                    end
                end
            end
        end
        for k, v in pairs(stacked) do
            table.insert(inventory, {
                name = k,
                count = v
            })
        end

        local accounts = {}
        for k, v in pairs(pData.money or {}) do
            table.insert(accounts, {
                money = v,
                name = k,
                label = k
            })
        end

        local x = {
            job = {
                id = -1,
                name = jobName,
                label = jobLabel,

                grade_name = gradeName,
                grade_label = grade_label,
                grade_salary = grade_salary,
                grade = grade,

                skin_male = {},
                skin_female = {}
            },
            inventory = inventory,
            accounts = accounts
        }
        return x
    end

    CreateThread(function()
        GetCoreObject(Framework.Active, Framework.QB_CORE_RESOURCE_NAME, function(object)
            QBCore = object
            if QBCore and QBCore.Functions.GetPlayerData() then
                PlayerData = UpdatePlayerDataForQBCore()
                TriggerEvent("rcore_casino:PlayerDataLoaded")
            end
        end)
    end)

    RegisterNetEvent(Events.QB_PLAYER_LOADED, function()
        PlayerData = UpdatePlayerDataForQBCore()
        TriggerEvent("rcore_casino:DataHasChanged")
    end)

    RegisterNetEvent(Events.QB_PLAYER_JOB_UPDATE, function()
        PlayerData = UpdatePlayerDataForQBCore()
        TriggerEvent("rcore_casino:DataHasChanged")
    end)
end

-- Built-In HUD
function RegisterBuiltInHud()
    if not Framework.BUILTIN_HUD_CHIPS then
        return
    end

    if Framework.Active == 1 then
        local chipTpl = '<div><img src="img/accounts/' .. Framework.BUILTIN_HUD_CHIPS_ICON .. '"/>&nbsp;{{chips}}</div>'
        ESX.UI.HUD.RegisterElement('casinochips', 0, 0, chipTpl, {
            chips = ESX.Math.GroupDigits(PLAYER_CHIPS)
        })
    end
end

function UpdateBuiltInHud()
    if not Framework.BUILTIN_HUD_CHIPS then
        return
    end
    if Framework.Active == 1 then
        ESX.UI.HUD.UpdateElement("casinochips", {
            chips = ESX.Math.GroupDigits(PLAYER_CHIPS)
        })
    end
end

function UnregisterBuiltInHud()
    if not Framework.BUILTIN_HUD_CHIPS then
        return
    end
    if Framework.Active == 1 then
        ESX.UI.HUD.RemoveElement("casinochips")
    end
end
