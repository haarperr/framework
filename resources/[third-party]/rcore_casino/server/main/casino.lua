-- players inside casino
CasinoPlayers = {}
local CasinoPlayerCount = 0

-- cashiers
local Cashiers = {}

-- seating
local Seatings = {}

-- office chair
local OfficeChairUsed = false

-- other
LUCKY_LEVEL = 0 -- 0 none, 1 lucky player, 2 lucky player & peds
DAY_OF_WEEK = 0 -- *fake* day of the week inside casino

function GetPlayerIdentifier(playerId)
    DebugStart("GetPlayerIdentifier")
    local id = exports.user:GetIdentifier(playerId, "steam") or -1
    if id == -1 then
        print("^1[Casino] Error finding player identifier of id: " .. tostring(playerId) .. "^7")
    end
    return id
end

-- get cashier instance from coords
local function GetCashierFromCoords(coords)
    if not coords then
        return nil
    end
    DebugStart("GetCashierFromCoords")
    for _, o in pairs(Cashiers) do
        if #(coords - o.coords) < 0.2 then
            return o
        end
    end
    return nil
end

local function GetOrCreateCashierInstance(coords)
    if not coords then
        return
    end
    DebugStart("GetOrCreateCashierInstance")
    local cashier = GetCashierFromCoords(coords)
    if not cashier then
        cashier = {}
        cashier.coords = coords
        cashier.playerId = -1
        table.insert(Cashiers, cashier)
    end
    return cashier
end

local function Cashier_Leave(playerId)
    DebugStart("Cashier_Leave")
    if Config.CASHIER_MULTITASK then
        return
    end
    for _, o in pairs(Cashiers) do
        if o.playerId and o.playerId == playerId then
            o.playerId = -1
            BroadcastCasino("Cashier:Quit", o.coords)
        end
    end
end

local function GetCasinoMoneyWithdrawPercentage()
    local moneyLimit = 100
    if Config.EnableSociety then
        local money = GetMoneyFromSociety()
        if money and money <= Config.SocietyLimitFromBalance then
            moneyLimit = Config.SocietyLimitPayoutPercentage
        end
    end
    return moneyLimit
end

local function Cashier_SendSessions(playerId)
    DebugStart("Cashier_SendSessions")
    TriggerClientEvent("Cashier:Sessions", playerId, Cashiers)
end

local function PlayerQuitSeating(playerId)
    DebugStart("PlayerQuitSeating")
    for k, v in pairs(Seatings) do
        if v == playerId then
            Seatings[k] = nil
            BroadcastCasino("Casino:QuitSeating", playerId, k)
            Cache:SetPlayerState(playerId, "Game", nil)
        end
    end
end

local function RecountCasinoPlayers()
    CasinoPlayerCount = tableLength(CasinoPlayers)
    if CasinoPlayerCount == 0 then
        DAY_OF_WEEK = Repeat(DAY_OF_WEEK + 1, 7)
    end
end

RegisterNetEvent("Cashier:Use")
AddEventHandler("Cashier:Use", function(coords, usedBefore, isDrunk)
    local playerId = source

    if not coords then
        return
    end

    local cashier = GetOrCreateCashierInstance(coords)

    if not cashier then
        return
    end

    if cashier.playerId ~= -1 then
        return
    end

    if not Config.CASHIER_MULTITASK then
        cashier.playerId = playerId
    end

    local greetingsType = "WELCOME"
    if usedBefore then
        greetingsType = "WELCOME_BACK"
    end
    if isDrunk then
        greetingsType = "WELCOME_DRUNK"
    end

    local moneyPercentage = GetCasinoMoneyWithdrawPercentage()
    local canPurchaseVIP = true
    if Config.CASHIER_VIP_PASS_ITEM and Config.CASHIER_VIP_PASS_ITEM ~= "" and Config.CASHIER_VIP_PASS_ITEM ~= 0 then
        canPurchaseVIP = (GetPlayerCasinoItemCount(playerId, Config.CASHIER_VIP_PASS_ITEM) ~= 0)
    end
    if Config.CASHIER_MULTITASK then
        TriggerClientEvent("Cashier:Use", playerId, coords, playerId, greetingsType, moneyPercentage, canPurchaseVIP)
    else
        BroadcastCasino("Cashier:Use", coords, playerId, greetingsType, moneyPercentage, canPurchaseVIP)
    end
end)

RegisterNetEvent("Cashier:Quit")
AddEventHandler("Cashier:Quit", function()
    local playerId = source
    Cashier_Leave(playerId)
end)

RegisterNetEvent("Casino:UseSeating")
AddEventHandler("Casino:UseSeating", function(seatIndex)
    local playerId = source
    if not Seatings[seatIndex] then
        BroadcastCasino("Casino:UseSeating", playerId, seatIndex)
        Cache:SetPlayerState(playerId, "Game", {
            type = "Sitting",
            chair = seatIndex
        })
        Seatings[seatIndex] = playerId
    end
end)

RegisterNetEvent("Casino:QuitSeating")
AddEventHandler("Casino:QuitSeating", function()
    local playerId = source
    PlayerQuitSeating(playerId)
end)

RegisterNetEvent("CasinoOffice:EnterChair")
AddEventHandler("CasinoOffice:EnterChair", function(netId)
    local playerId = source
    if not OfficeChairUsed then
        OfficeChairUsed = playerId
        -- resave the current netId of the player's ped
        Cache.PedNetIdCache[playerId] = netId

        BroadcastCasino("CasinoOffice:EnterChair", OfficeChairUsed, netId)
    end
end)

RegisterNetEvent("CasinoOffice:LeaveChair")
AddEventHandler("CasinoOffice:LeaveChair", function()
    local playerId = source
    if OfficeChairUsed ~= playerId then
        return
    end
    OfficeChairUsed = false
    local netId = Cache:PlayerToNet(playerId)
    BroadcastCasino("CasinoOffice:LeaveChair", playerId, netId)
end)

RegisterNetEvent("CasinoOffice:ToggleComputer")
AddEventHandler("CasinoOffice:ToggleComputer", function(toggle)
    local playerId = source
    if OfficeChairUsed ~= playerId then
        return
    end
    local netId = Cache:PlayerToNet(playerId)
    BroadcastCasino("CasinoOffice:ToggleComputer", playerId, toggle, netId)
end)

-- get server time in ms
RegisterNetEvent("Casino:GetTime")
AddEventHandler("Casino:GetTime", function()
    local playerId = source
    TriggerClientEvent("Casino:GetTime", playerId, GetGameTimer())
end)

-- adds casino inventory item
function AddCasinoItem(playerId, item, count)
    DebugStart("AddCasinoItem")
    exports.inventory:GiveItem(playerId, item, count)
end

-- removes casino inventory item
function RemoveCasinoItem(playerId, item, count)
    DebugStart("RemoveCasinoItem")
    exports.inventory:TakeItem(playerId, item, count)
end

-- get player casino inventory item count (chips, snacks...)
function GetPlayerCasinoItemCount(playerId, item)
    DebugStart("GetPlayerCasinoItemCount")
    return exports.inventory:CountItem(playerId, item) or 0
end

-- gets player chips from DB
function GetPlayerChips(playerId)
    DebugStart("GetPlayerChips")
    return exports.inventory:CountItem(playerId, Config.ChipsInventoryItem) or 0
end

-- gets player money from DB
function GetPlayerMoney(playerId)
    DebugStart("GetPlayerMoney")
    return exports.inventory:GetTotalMoney(playerId, true, true) or 0
end

-- add player money
function AddPlayerMoney(playerId, money, ignoreSociety)
    DebugStart("AddPlayerMoney")
    local account = exports.character:Get(playerId, "bank")
    if not account then return false end
    exports.banking:AddBank(playerId, account, money, true)
    local transaction = {
        account_id = account,
        type = 1,
        note = "Casino payout."
    }
    exports.banking:AddTransaction(playerId, transaction, money)
    return true
end

-- remove player money
function RemovePlayerMoney(playerId, money)
    DebugStart("RemovePlayerMoney")
    local account = exports.character:Get(playerId, "bank")
    if not account then return false end
    if not exports.inventory:CanAfford(source, money, true, true) then return false end
    if exports.inventory:TakeMoney(playerId, money, true) then
        local transaction = {
            account_id = account,
            type = 2,
            note = "Casino purchase."
        }
        exports.banking:AddTransaction(playerId, transaction, -money)
        return true
    else
        return false
    end
end

-- Is Player admin?
function IsPlayerAdmin(playerId)
    DebugStart("IsPlayerAdmin")
    return exports.user:IsAdmin(playerId)
end

-- check if player works at casino
function IsPlayerAtJob(playerId, job, GradeArray, MinGrade, MaxGrade)
    DebugStart("IsPlayerAtJob")
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        return false
    end

    local xJob = xPlayer.getJob()
    if not xJob then
        return false
    end

    if not MaxGrade then
        MaxGrade = MinGrade
    end

    local gradeLevel = xJob.grade
    if not gradeLevel then
        gradeLevel = 0
    end

    if GradeArray == nil then
        return xJob.name == job and gradeLevel >= MinGrade and gradeLevel <= MaxGrade
    end
    return xJob.name == job and (GradeArray[xJob.grade_name] or (gradeLevel >= MinGrade and gradeLevel <= MaxGrade))
end

-- resend player their balance
function SendPlayerChipsBalance(playerId, playerChips)
    DebugStart("SendPlayerChipsBalance")
    TriggerClientEvent("Casino:GetChips", playerId, playerChips)
end

-- resend player their money
function SendPlayerMoneyBalance(playerId, playerMoney)
    DebugStart("SendPlayerMoneyBalance")
    TriggerClientEvent("Casino:GetMoney", playerId, playerMoney)
end

local function SendPlayerInventory(playerId)
    DebugStart("SendPlayerInventory")
    local items = {}
    local xPlayer = ESX.GetPlayerFromId(playerId)

    for k, v in pairs(CasinoInventoryItems) do
        if v.itemType == 1 then
            local key = v.key

            local item = xPlayer.getInventoryItem(key)
            local count = item and item.count or 0
            items[key] = count
        end
    end
    TriggerClientEvent("Casino:GetItems", playerId, items)
end

-- pay for spin/bet
function Pay(playerId, item, chips, game)
    DebugStart("Pay")
    local playerChips = GetPlayerChips(playerId)

    if playerChips == nil then
        print("^1[Casino] Error getting chips of player " .. tostring(playerId) .. "^7")
    end
    -- if playerChips == nil then playerChips = 0 end

    if chips <= 0 or (playerChips - chips) < 0 then
        return -1
    end

    Debug("Player " .. playerId .. " paid " .. chips .. " for item '" .. item .. "' in game '" .. game .. "'")
    -- SetPlayerChips(playerId, playerChips - chips)
    if Config.UseOnlyMoney then
        RemovePlayerMoney(playerId, chips)
    else
        RemoveCasinoItem(playerId, Config.ChipsInventoryItem, chips)
    end

    if game ~= "Cashier" then
        local logMessage = "Paid for: " .. item .. " in " .. game
        AddLogEvent(playerId, logMessage, -chips, true)
    end

    Cache:IncrementPlayerState(playerId, "Score", -chips)
    return playerChips - chips
end

-- win price
function Win(playerId, item, chips, game)
    DebugStart("Win")
    local playerChips = GetPlayerChips(playerId)
    local playerIdentifier = GetPlayerIdentifier(playerId)
    if playerChips == nil then
        print("^1[Casino] Error getting chips of player " .. tostring(playerId) .. ", Identifier: " ..
                  tostring(playerIdentifier) .. "^7")
    end

    Debug("Player " .. playerId .. " won " .. chips .. " from item '" .. item .. "' in game '" .. game .. "'")
    -- SetPlayerChips(playerId, playerChips + chips)
    if Config.UseOnlyMoney then
        if not AddPlayerMoney(playerId, chips) then
            print("^1[Casino] Casino couldn't pay player " .. tostring(playerId) ..
                      ", because there is not enough money in the society account! (" .. chips ..
                      "). Player identifier: " .. tostring(playerIdentifier) .. "^7")
        end
    else
        AddCasinoItem(playerId, Config.ChipsInventoryItem, chips)
    end

    if game ~= "Cashier" then
        local logMessage = "Won: " .. item .. " in " .. game
        AddLogEvent(playerId, logMessage, chips, true)
    end

    Cache:IncrementPlayerState(playerId, "Score", chips)
    return playerChips + chips
end

-- broadcast player at table
function BroadcastTable(casinoTable, command, ...)
    DebugStart("BroadcastTable")
    for i = 1, 4 do
        if casinoTable.chairs[i] ~= -1 then
            TriggerClientEvent(command, casinoTable.chairs[i], ...)
        end
    end
end

function BroadcastCasino(eventName, ...)
    for k, v in pairs(CasinoPlayers) do
        TriggerClientEvent(eventName, k, ...)
    end
end

-- player wants to refresh his balance
RegisterNetEvent("Casino:TradeInChips")
AddEventHandler("Casino:TradeInChips", function(chips)
    local playerId = source
    local playerChips = GetPlayerChips(playerId)
    local getMoneyPercentage = GetCasinoMoneyWithdrawPercentage()
    local originalChips = chips
    if getMoneyPercentage <= 0 then
        return
    end

    local tradedIn = false
    local paid = Pay(playerId, "Trade In Chips", chips, "Cashier")
    if paid and paid ~= -1 then
        chips = math.ceil(chips * Config.ExchangeRate)
        local reducedMoney = math.ceil((chips / 100) * getMoneyPercentage)

        if AddPlayerMoney(playerId, reducedMoney) then
            local moneyNow = GetPlayerMoney(playerId)
            local comment = "TRANSACTION_EXCHANGE"
            if chips > 100000 then
                comment = "CASH_DESK_SELL_LARGE"
            elseif chips < 100 then
                comment = "CASH_DESK_SELL_SMALL"
            end
            local percentageNow = GetCasinoMoneyWithdrawPercentage()
            TriggerClientEvent("Casino:TradeResults", playerId, paid, moneyNow, "TRANSACTION_EXCHANGE", percentageNow)
            tradedIn = true
            AddLogEvent(playerId, "Trade-In Chips", -chips, false)
        else
            -- couldn't add that much money (society?), returning chips
            AddCasinoItem(playerId, Config.ChipsInventoryItem, originalChips)
        end

    end

    if not tradedIn then
        local societyMoney = GetMoneyFromSociety()
        TriggerClientEvent("Casino:TradeResults", playerId, false, societyMoney)
    end
end)

-- player wants to refresh his balance
RegisterNetEvent("Casino:AcquireChips")
AddEventHandler("Casino:AcquireChips", function(chips)
    local playerId = source
    chips = math.ceil(chips)
    local money = GetPlayerMoney(playerId)
    local chipsNow = GetPlayerChips(playerId)
    local realChipsValue = math.ceil(chips * Config.ExchangeRate)
    if money >= realChipsValue and chips >= 10 then
        chipsNow = Win(playerId, "Acquire Chips", chips, "Cashier")
        RemovePlayerMoney(playerId, realChipsValue)
        local percentageNow = GetCasinoMoneyWithdrawPercentage()
        TriggerClientEvent("Casino:TradeResults", playerId, chipsNow, money - realChipsValue, "CASH_DESK_REQUEST_CHIPS",
            percentageNow)
        AddLogEvent(playerId, "Acquire Chips", chips, false)
    else
        TriggerClientEvent("Casino:TradeResults", playerId, -1)
    end
end)

-- player wants to refresh his balance
RegisterNetEvent("Casino:DailyBonus")
AddEventHandler("Casino:DailyBonus", function(chips)
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId)
    Cache:Get(identifier, function(p)
        if not p then
            return
        end
        local today = os.date("%x")
        if p.lastDailyBonus and p.lastDailyBonus == today then
            return
        end
        p.lastDailyBonus = today

        local chipsNow = Win(playerId, "Daily Bonus", Config.CASHIER_DAILY_BONUS, "Cashier")
        local money = GetPlayerMoney(playerId)
        local percentageNow = GetCasinoMoneyWithdrawPercentage()

        TriggerClientEvent("Casino:TradeResults", playerId, chipsNow, money, "VICTIMIZED_REACT", percentageNow, p)
    end)
end)

-- player wants to refresh his balance
RegisterNetEvent("Casino:BecomeVIP")
AddEventHandler("Casino:BecomeVIP", function()
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId)

    local money = GetPlayerMoney(playerId)
    if money < Config.CASHIER_VIP_PRICE then
        return
    end

    Cache:Get(identifier, function(p)
        RemovePlayerMoney(playerId, Config.CASHIER_VIP_PRICE)
        if Config.CASHIER_VIP_PASS_ITEM and Config.CASHIER_VIP_PASS_ITEM ~= "" and Config.CASHIER_VIP_PASS_ITEM ~= 0 then
            -- RemoveCasinoItem(playerId, Config.CASHIER_VIP_PASS_ITEM, 1)
        end
        local vipUntil = os.time() + Config.CASHIER_VIP_DURATION
        p.vipUntil = vipUntil
        BroadcastCasino("Casino:BecomeVIP", playerId, vipUntil)
    end)
end)

-- player wants to refresh his balance
RegisterNetEvent("Casino:GetChips")
AddEventHandler("Casino:GetChips", function()
    local playerId = source
    local playerChips = GetPlayerChips(playerId)
    SendPlayerChipsBalance(playerId, playerChips)
end)

-- player wants to refresh his money balance
RegisterNetEvent("Casino:GetMoney")
AddEventHandler("Casino:GetMoney", function()
    local playerId = source
    local playerMoney = GetPlayerMoney(playerId)
    SendPlayerMoneyBalance(playerId, playerMoney)
end)

-- player wants to refresh his balance
RegisterNetEvent("Casino:GetItems")
AddEventHandler("Casino:GetItems", function()
    local playerId = source
    SendPlayerInventory(playerId)
end)

RegisterNetEvent("Casino:SaveAmbientPeds")
AddEventHandler("Casino:SaveAmbientPeds", function(buffer)
    local playerId = source
    if not IsPlayerAdmin(playerId) then
        return
    end
    local fileNames = {"peddata.txt", "peddata_gabz.txt", "peddata_gabz.txt", "peddata_k4mb1.txt"}
    local fileName = fileNames[Config.MapType]
    if not fileName then
        return
    end
    local filePath = "client/interior/" .. fileName
    SaveResourceFile(GetCurrentResourceName(), filePath, buffer, #(buffer))
    print("Ambient peds saved.")
end)

-- replace the podium vehicle props
RegisterNetEvent("Casino:PodiumReplace")
AddEventHandler("Casino:PodiumReplace", function(vehicleModel, vehicleProps)
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId)
    local error = -1

    local hasAbility = IsPlayerAtJob(playerId, Config.JobName, nil, 1, 3) or IsPlayerAdmin(playerId)
    if not hasAbility then
        error = 1
    end
    if hasAbility and Config.JOB_PODIUMCAR_OWNERSHIP_CHECK == true and
        not Cache:PlayerOwnsVehicle(identifier, vehicleProps.plate) then
        error = 2
    end
    TriggerClientEvent("Casino:PodiumReplace", playerId, error)
    if error == -1 then
        if Config.JOB_PODIUMCAR_OWNERSHIP_CHECK and Config.JOB_PODIUMCAR_OWNERSHIP_DELETE_ORIGINAL then
            if Config.MongoDB then
                MongoDB:Delete("player_vehicles", {
                    plate = vehicleProps.plate
                })
            else
                local vehTable = "owned_vehicles" -- ES
                if Framework.Active == 2 then -- QB
                    vehTable = "player_vehicles"
                end

                MySQL.Sync.execute('DELETE FROM ' .. vehTable .. ' WHERE plate = @plate LIMIT 1', {
                    ['@plate'] = vehicleProps.plate
                })
            end
        end

        vehicleProps.plate = nil
        vehicleProps.podiumName = vehicleModel
        Cache:UpdateSetting("PodiumPriceProps", json.encode(vehicleProps))
    end
end)

-- replace the podium vehicle props
RegisterNetEvent("Casino:PodiumRemove")
AddEventHandler("Casino:PodiumRemove", function()
    local playerId = source

    if not IsPlayerAtJob(playerId, Config.JobName, nil, 2) then
        return
    end

    Cache:UpdateSetting("PodiumPriceProps", "")
    BroadcastCasino("Casino:PodiumVehicleChanged", "")
end)

-- player tells server he entered casino
function Casino_ResendPlayerProgress(playerId)
    DebugStart("Casino_ResendPlayerProgress")
    local identifier = GetPlayerIdentifier(playerId)
    -- Win(playerId, "-", 10, "-")
    -- RemoveCasinoItem(playerId, Config.ChipsInventoryItem, 15)
    Cache:Get(identifier, function(p)

        -- transfer old vips to new 
        if p.vip and not p.vipUntil then
            local vipUntil = os.time() + Config.CASHIER_VIP_DURATION
            p.vipUntil = vipUntil
            p.vip = nil
        end

        local playerBalance = {
            money = GetPlayerMoney(playerId),
            chips = GetPlayerChips(playerId)
        }
        local playerAdmin = IsPlayerAdmin(playerId)
        TriggerClientEvent("Casino:Progress", playerId, playerBalance, os.time(), os.date("%x"), p, GameStates,
            playerAdmin)
        p.firstTime = false
        SendPlayerInventory(playerId)
    end)
end

-- player entered casino, send his progress & balance
RegisterNetEvent("Casino:Enter")
AddEventHandler("Casino:Enter", function()
    local playerId = source
    local stamp = {
        name = "Unnamed",
        identifier = "Unknown"
    }

    stamp.name = exports.character:GetName(playerId)
    stamp.identifier = exports.user:GetIdentifier(playerId, "steam")

    CasinoPlayers[playerId] = stamp
    RecountCasinoPlayers()
    local identifier = GetPlayerIdentifier(playerId)
    Cache:SetPlayerState(playerId, "EnterTime", GetGameTimer())
    Cache:Get(identifier, function(p)
        p.logins = p.logins + 1
        Slots_SendSessions(playerId)
        LuckyWheel_SendState(playerId)
        DrinkingBar_SendSessions(playerId)
        Cashier_SendSessions(playerId)
        TriggerClientEvent("Casino:UsedSeatings", playerId, Seatings)
        Casino_ResendPlayerProgress(playerId)

        -- send interior properties (podium spinner car, etc..)
        local podiumProps = Cache.Settings["PodiumPriceProps"]
        local wallBroken = Cache.Settings["WallBroken"]
        TriggerClientEvent("Casino:Interior", playerId, podiumProps, wallBroken)
        TriggerEvent("PlayerJoinedCasino", playerId)
        AddLogEvent(playerId, "Entered Casino")
    end)
end)

function EndEverything(playerId)
    ScenePed_EndForPlayer(playerId)
    InsideTrack_PlayerDropped(playerId)
    LuckyWheel_PlayerDropped(playerId)
    Slots_PlayerDropped(playerId)
    DrinkingBar_PlayerDropped(playerId)
    Roulette_LeaveChair(playerId)
    Poker_LeaveChair(playerId)
    Blackjack_LeaveChair(playerId)
    Cashier_Leave(playerId)
    Cache:RemovePlayerState(playerId)
end

function PrintInfo()
    local mysqlRes = "mysql-async"
    if Config.MongoDB then
        mysqlRes = "mongoDB"
    elseif Config.Ghmattimysql then
        mysqlRes = "ghmattimysql"
    end
    local mapNames = {"rcore_casino/DLCiplLoader", "Gabz Casino", "NoPixel Casino", "k4mb1"}

    print("^3")
    print("rcore_casino")
    print(string.format("^7version: ^3%s", GetResourceMetadata(GetCurrentResourceName(), "version")))
    print(string.format("^7database: ^3%s", mysqlRes))
    print(string.format("^7map: ^3%s", mapNames[Config.MapType]))
    print(string.format("^7society: ^3%s", Config.SocietyName))
    print("https://documentation.rcore.cz/paid-resources/rcore_casino")
    print("^7")
end

function CheckSociety()
    if not Config.EnableSociety then
        return
    end
    local checkDone = false
    CreateThread(function()
        GiveMoneyToSociety(1)
        Wait(500)
        if GetMoneyFromSociety() == 0 then
            print("^3Casino won't work unless you set up the society account.^7")
        else
            RemoveMoneyFromSociety(1)
        end
        checkDone = true
    end)
    CreateThread(function()
        Wait(3000)
        if not checkDone then
            print("")
            print("^1Error checking the society.^7")
            print("Please check file ^3/server/main/society.lua^7. You may have to change the event names.^7")
        end
    end)
end

-- player wants to refresh his balance
RegisterNetEvent("Casino:Leave")
AddEventHandler("Casino:Leave", function()
    local playerId = source
    if CasinoPlayers[playerId] then
        AddLogEvent(playerId, "Left Casino")
    end
    CasinoPlayers[playerId] = nil
    RecountCasinoPlayers()
    EndEverything(playerId)
    TriggerEvent("PlayerLeftCasino", playerId)
end)

-- Admin: Update game states
RegisterNetEvent("Casino:AdminUpdateStates")
AddEventHandler("Casino:AdminUpdateStates", function(states)
    local playerId = source
    if not IsPlayerAdmin(playerId) then
        return
    end

    GameStates = states
    TriggerClientEvent("Casino:NewGameStates", -1, states)
end)

-- Admin: Request admin panel
RegisterNetEvent("Casino:AdminShowMenu")
AddEventHandler("Casino:AdminShowMenu", function()
    local playerId = source
    if not IsPlayerAdmin(playerId) then
        return
    end

    TriggerClientEvent("Casino:AdminShowMenu", playerId, GameStates)
end)

-- Admin: Kick player
RegisterNetEvent("Casino:AdminKick")
AddEventHandler("Casino:AdminKick", function(kickId)
    local playerId = source
    if not IsPlayerAdmin(playerId) then
        return
    end
    TriggerClientEvent("Casino:BouncerKicked", kickId)
end)

-- Guidebook: Having to ask a server to open a page on a client??? Okay.
RegisterNetEvent("GuideBook:ShowItToMe")
AddEventHandler("GuideBook:ShowItToMe", function(pageKey)
    local playerId = source
    TriggerEvent('rcore_guidebook:openSpecificPage', playerId, pageKey)
end)

-- player wants to get his serverid
RegisterNetEvent("Casino:GetServerId")
AddEventHandler("Casino:GetServerId", function()
    local playerId = source
    TriggerClientEvent("Casino:GetServerId", playerId, playerId)
end)

-- player disconnected, deleting their casino progress
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    if CasinoPlayers[playerId] then
        AddLogEvent(playerId, "Left Casino (Disconnected)")
        RecountCasinoPlayers()
    end

    CasinoPlayers[playerId] = nil
    EndEverything(playerId)
    TriggerEvent("PlayerLeftCasino", playerId)
end)

-- player gets casino info after joining the server
RegisterNetEvent("Casino:GetInfo")
AddEventHandler("Casino:GetInfo", function()
    local playerId = source
    local isAdmin = IsPlayerAdmin(playerId)
    TriggerClientEvent("Casino:InitialInfo", playerId, GameStates, isAdmin, playerId)
end)

-- start fuse box
RegisterNetEvent("Casino:StartFuseBox")
AddEventHandler("Casino:StartFuseBox", function()
    local playerId = source

    local playerId = source
    if not Jobs.Enabled then
        return
    end

    -- not a worker
    if not IsPlayerAtJob(playerId, Jobs.Electrician.JobName, nil, Jobs.Electrician.MinGrade, Jobs.Electrician.MaxGrade) then
        return
    end

    local wallBroken = Cache.Settings["WallBroken"]
    if not wallBroken or wallBroken == false then
        return
    end

    -- use one of the circuit boards in inventory
    if Jobs.Electrician.CircuitBoardNeedsPurchase then
        local boards = GetPlayerCasinoItemCount(playerId, Jobs.Electrician.CircuitBoardItemName)
        if boards < 1 then
            TriggerClientEvent("Casino:StartFuseBox", playerId, 0)
            return
        end
        RemoveCasinoItem(playerId, Jobs.Electrician.CircuitBoardItemName, 1)
    end

    -- run circuit board game on client
    TriggerClientEvent("Casino:StartFuseBox", playerId, 1)
end)

-- player fixed fuse box
RegisterNetEvent("Casino:FuseBoxFixed")
AddEventHandler("Casino:FuseBoxFixed", function()
    local playerId = source

    local playerId = source
    if not Jobs.Enabled then
        return
    end

    -- not a worker
    if not IsPlayerAtJob(playerId, Jobs.Electrician.JobName, nil, Jobs.Electrician.MinGrade, Jobs.Electrician.MaxGrade) then
        return
    end
    Cache:UpdateSetting("WallBroken", false)
    Cache:UpdateSetting("NoElectricity", false)

    BroadcastCasino("Casino:FuseBoxStateChanged", false)
end)

RegisterCommand("casinoversion", function()
    PrintInfo()
end, false)

PrintInfo()

