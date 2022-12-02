-- whether to use okokbanking
local okokbanking = false

local function OkOk_GetBalance()
    local balance = nil
    local result = MySQL.Sync.fetchAll('SELECT `value` FROM `okokbanking_societies` WHERE society = @society', {
        ['@society'] = Config.SocietyName
    })

    if result and #result == 1 then
        balance = result[1]["value"]
    end

    if not balance then
        print(string.format("^1[%s][ERROR]^7 Society ^1'%s'^7 in okokbanking_societies does not exist!", GetCurrentResourceName(), Config.SocietyName))
        balance = 0
    end

    return balance
end

local function OkOk_UpdateBalance(newBalance)
    MySQL.Sync.execute('UPDATE `okokbanking_societies` SET value = @newBalance WHERE society = @society', {
        ['@newBalance'] = tostring(newBalance),
        ['@society'] = Config.SocietyName
    })
end

function RemoveMoneyFromSociety(money)
    if okokbanking then
        local b = OkOk_GetBalance()
        b = b - money
        if b < 0 then
            b = 0
        end
        OkOk_UpdateBalance(b)
        return
    end
    if Framework.Active == 2 then
        local moneyNow = GetMoneyFromSociety()
        if (moneyNow - money) < 0 then
            money = moneyNow
        end
        xpcall(function()
            local societyMoney = exports["qb-bossmenu"]:GetAccount(Config.SocietyName)
            -- if societyMoney >= money then
            TriggerEvent("qb-bossmenu:server:removeAccountMoney", Config.SocietyName, money)
            -- end
        end, function(error)
            local societyMoney = exports["qb-management"]:GetAccount(Config.SocietyName)
            -- if societyMoney >= money then
            exports["qb-management"]:RemoveMoney(Config.SocietyName, money)
            -- end
        end)
    end

    if Framework.Active == 1 then
        TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
            if account then
                -- if account.money >= money then
                account.removeMoney(money)
                -- end
            else
                print(string.format("^1[%s][ERROR]^7 Society ^1'%s'^7 does not exist! The Cashier will not work. Either create a society account for casino, or disable society in config.lua.", GetCurrentResourceName(), Config.SocietyName))
            end
        end)
    end
end

function GiveMoneyToSociety(money)
    if okokbanking then
        local b = OkOk_GetBalance()
        b = b + money
        OkOk_UpdateBalance(b)
        return
    end
    if Framework.Active == 2 then
        xpcall(function()
            exports["qb-management"]:AddMoney(Config.SocietyName, money)
        end, function(error)
            TriggerEvent("qb-bossmenu:server:addAccountMoney", Config.SocietyName, money)
        end)
    end

    if Framework.Active == 1 then
        TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
            if account then
                account.addMoney(money)
            else
                print(string.format("^1[%s][ERROR]^7 Society ^1'%s'^7 does not exist! The Cashier will not work. Either create a society account for casino, or disable society in config.lua.", GetCurrentResourceName(), Config.SocietyName))
            end
        end)
    end
end

function GetMoneyFromSociety()
    if okokbanking then
        return OkOk_GetBalance()
    end
    local result = nil
    local promise = promise:new()

    if Framework.Active == 2 then
        xpcall(function()
            local societyMoney = exports["qb-bossmenu"]:GetAccount(Config.SocietyName)
            result = societyMoney
            promise:resolve(result)
        end, function(error)
            local societyMoney = exports["qb-management"]:GetAccount(Config.SocietyName)
            result = societyMoney
            promise:resolve(result)
        end)
    end

    if Framework.Active == 1 then
        TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
            if account then
                result = account.money
                promise:resolve(result)
            else
                print(string.format("^1[%s][ERROR]^7 Society ^1'%s'^7 does not exist! The Cashier will not work. Either create a society account for casino, or disable society in config.lua.", GetCurrentResourceName(), Config.SocietyName))
                result = 0
                promise:resolve(result)
            end
        end)
    end

    Citizen.Await(promise)
    return result
end
