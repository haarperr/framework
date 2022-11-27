-- cashier UI selection
local menu_TradeInListIndex = 1
local menu_AcquireListIndex = 1
local menu_confirmedIndex = -1
local moneyOptions = {0}
local chipsOptions = {0}
local dailyBonusUsed = false
local dailyDesc = nil
local vipItemDescription = nil
local vipItemEnabled = false
local confirmMessage = nil
local moneyPercentage = 100
local withdrawBadge = RageUI.BadgeStyle.None
local withdrawDesc = Translation.CASHIER_TRADEIN_DESC
local canPurchaseVIP = true
local extraTransferInfo = nil

local function RefreshCashierVIPItem()
    vipItemEnabled = false
    if PLAYER_IS_VIP then
        vipItemDescription = string.format(Translation.CASHIER_VIP_PURCHASE_COMPLETE,
            CommaValue(Config.CASHIER_VIP_PRICE), Config.PRICES_CURRENCY)
        vipItemDescription = vipItemDescription ..
                                 string.format(" " .. Translation.CASHIER_VIP_VALID_FOR,
                FormatTimestamp(PLAYER_CACHE.vipUntil - SERVER_TIMER))
    else
        if PLAYER_MONEY < Config.CASHIER_VIP_PRICE then
            vipItemDescription = Translation.CASHIER_VIP_NO_MONEY
        else
            vipItemEnabled = true
            vipItemDescription = string.format(Translation.CASHIER_VIP_MEMBERSHIP_DESC,
                CommaValue(Config.CASHIER_VIP_PRICE), Config.PRICES_CURRENCY)
        end
    end

    if not canPurchaseVIP then
        vipItemEnabled = false
        vipItemDescription = Translation.CASHIER_VIP_PASS_ERROR
    end
end

function ResetCashierUISelection(moneyLimit)
    moneyPercentage = moneyLimit
    menu_TradeInListIndex = 1
    menu_AcquireListIndex = 1
    menu_confirmedIndex = -1
    moneyOptions = CashierGetMoneyBalanceOptions(PLAYER_MONEY)
    chipsOptions = CashierGetBalanceOptions(PLAYER_CHIPS)

    withdrawBadge = moneyPercentage == 100 and RageUI.BadgeStyle.None or RageUI.BadgeStyle.Alert
    withdrawDesc = Translation.CASHIER_TRADEIN_DESC
    if moneyPercentage == 0 then
        withdrawDesc = Translation.SOCIETY_CASHIER_MONEY_LIMIT_3
    elseif moneyPercentage < 100 then
        withdrawDesc = withdrawDesc .. " " .. string.format(Translation.SOCIETY_CASHIER_MONEY_LIMIT, moneyPercentage)
    end

    dailyBonusUsed = PLAYER_CACHE.lastDailyBonus and PLAYER_CACHE.lastDailyBonus == SERVER_DATE
    dailyDesc = dailyBonusUsed and Translation.CASHIER_DAILY_BONUS_USED or
                    string.format(Translation.CASHIER_DAILY_BONUS_DESC, Config.CASHIER_DAILY_BONUS)
end

-- show cashier ui
function Cashier_ShowMenu(moneyLimit, vipAllowed)
    canPurchaseVIP = vipAllowed
    ResetCashierUISelection(moneyLimit)
    InfoPanel_UpdateNotification(nil)

    local cashierMenu = RageUI.CreateMenu("", Translation.CASHIER_CAPT, 25, 25, "shopui_title_casino_banner",
        "shopui_title_casino_banner")
    local exchangeRateDesc = nil
    if Config.ExchangeRate ~= 1 then
        exchangeRateDesc = string.format(Translation.CASHIER_EXCHANGE_RATE_DESC,
            FormatPrice(math.ceil(10 * Config.ExchangeRate)))
    end

    function RageUI.PoolMenus:CashierUI()
        cashierMenu:IsVisible(function(i)
            RefreshCashierVIPItem()
            if not Config.UseOnlyMoney then
                i:AddList(Translation.CASHIER_ACQUIRE_CAPT, moneyOptions, menu_AcquireListIndex,
                    (menu_AcquireListIndex == menu_confirmedIndex and confirmMessage or Translation.CASHIER_ACQUIRE_DESC),
                    {
                        IsDisabled = moneyOptions[menu_AcquireListIndex] == 0
                    }, function(Index, onSelected, onListChange)
                        if (onListChange) then
                            menu_AcquireListIndex = Index;
                            menu_confirmedIndex = -1
                        end
                        if onSelected then
                            if moneyOptions[Index] == nil then
                                return
                            end
                            if menu_confirmedIndex ~= Index then
                                menu_confirmedIndex = Index
                                local amount = CommaValue(moneyOptions[Index])
                                local realChipsValue = math.ceil(moneyOptions[Index] * Config.ExchangeRate)

                                confirmMessage = string.format(Translation.CASHIER_YOU_SURE_ACQUIRE, amount,
                                    FormatPrice(realChipsValue))

                                if Config.ExchangeRate ~= 1 then
                                    confirmMessage = string.format(Translation.CASHIER_TRANSFER_INFO,
                                        CommaValue(amount), FormatPrice(realChipsValue)) .. confirmMessage
                                end
                                return
                            end
                            Cashier_AcquireChips(moneyOptions[Index])
                        end
                    end)
                i:AddList(Translation.CASHIER_TRADEIN_CAPT, chipsOptions, menu_TradeInListIndex,
                    (menu_TradeInListIndex == menu_confirmedIndex and confirmMessage or withdrawDesc), {
                        IsDisabled = chipsOptions[menu_TradeInListIndex] == 0 or moneyPercentage <= 0,
                        LeftBadge = withdrawBadge
                    }, function(Index, onSelected, onListChange)
                        if (onListChange) then
                            menu_TradeInListIndex = Index;
                            menu_confirmedIndex = -1
                        end
                        if onSelected then
                            if chipsOptions[Index] == nil then
                                return
                            end

                            if menu_confirmedIndex ~= Index then
                                menu_confirmedIndex = Index
                                local amount = CommaValue(chipsOptions[Index])
                                local realChipsValue = math.ceil(chipsOptions[Index] * Config.ExchangeRate)
                                confirmMessage = string.format(Translation.CASHIER_YOU_SURE_TRADE_IN, amount)

                                if Config.ExchangeRate ~= 1 then
                                    confirmMessage = string.format(Translation.CASHIER_TRANSFER_INFO,
                                        CommaValue(amount), FormatPrice(realChipsValue)) .. confirmMessage
                                end

                                if moneyPercentage < 100 then
                                    local reducedMoney = math.ceil((realChipsValue / 100) * moneyPercentage)
                                    confirmMessage = confirmMessage .. " " ..
                                                         string.format(Translation.SOCIETY_CASHIER_MONEY_LIMIT_2,
                                            CommaValue(reducedMoney), Config.PRICES_CURRENCY, amount, moneyPercentage)
                                end
                                return
                            end
                            Cashier_TradeInChips(chipsOptions[Index])
                        end
                    end)
            end

            if Config.CASHIER_DAILY_BONUS ~= 0 then
                i:AddButton(Translation.CASHIER_DAILY_BONUS_CAPT, dailyDesc, {
                    IsDisabled = dailyBonusUsed,
                    RightLabelColor = RageUI.ItemsColour.White
                }, nil, function()
                    Cashier_DailyBonus()
                end)
            end

            i:AddButton(Translation.CASHIER_VIP_MEMBERSHIP_CAPT, vipItemDescription, {
                IsDisabled = vipItemEnabled == false,
                RightLabelColor = RageUI.ItemsColour.White,
                RightBadge = RageUI.BadgeStyle.CasinoVIP
            }, nil, function()
                Cashier_RequestVIP()
            end)

            if exchangeRateDesc then
                i:AddSeparator(exchangeRateDesc, RageUI.ItemsColour.Yellow)
            end

        end, function(Panels)
        end)
    end
    RageUI.Visible(cashierMenu, true)
end

-- opens up sitting menu (choose from snacks to eat/drink while sitting at the bar)
function DrinkingBar_ShowSittingMenu()
    InfoPanel_UpdateNotification(nil)
    local sittingMenu = RageUI.CreateMenu("", Translation.BAR_SNACKS_CAPT, 25, 25, "shopui_title_casino_banner",
        "shopui_title_casino_banner")
    function RageUI.PoolMenus:DrinksUI()
        sittingMenu:IsVisible(function(i)
            for x = 1, #CasinoInventoryItems do
                local v = CasinoInventoryItems[x]
                if v.itemType == 1 then
                    local key = v.key
                    if PLAYER_ITEMS[key] and PLAYER_ITEMS[key] > 0 then
                        i:AddButton(v.title, Translation.BAR_SNACKS_DESC, {
                            IsDisabled = false,
                            RightLabel = PLAYER_ITEMS[key],
                            RightLabelColor = RageUI.ItemsColour.White
                        }, nil, function()
                            SittingMenu_SnackSelected(key)
                        end)
                    end
                end
            end
        end, function(Panels)
        end)
    end
    RageUI.Visible(sittingMenu, true)
end

function DrinkingBar_ShowMenu()
    -- CAN_MOVE = false
    InfoPanel_UpdateNotification(nil)
    local drinksMenu = RageUI.CreateMenu("", Translation.BAR_MENU_TITLE, 25, 25, "shopui_title_casino_banner",
        "shopui_title_casino_banner")
    function RageUI.PoolMenus:DrinksUI()
        drinksMenu:IsVisible(function(i)

            if Config.BarShowSnacks then
                i:AddSeparator(Translation.BAR_SNACKS_SEPARATOR_DRINKS)
            end

            for x = 1, #CasinoInventoryItems do
                local v = CasinoInventoryItems[x]
                local k = v.key
                if v.itemType == 2 then
                    local price = FormatPrice(v.price)
                    local forFree = v.luckyWheelAffected and PLAYER_CACHE.freeDrinksUntil and SERVER_TIMER <
                                        PLAYER_CACHE.freeDrinksUntil
                    if forFree then
                        price = Translation.BAR_SNACKS_PRICE_FREE
                    end
                    local itemDescription = PLAYER_MONEY >= v.price and Translation.BAR_MENU_DESC or
                                                string.format(Translation.BAR_MENU_NO_MONEY, price)
                    local itemDisabled = (forFree == false and PLAYER_MONEY < v.price)
                    if v.vip and not PLAYER_IS_VIP then
                        itemDisabled = true
                        itemDescription = Translation.BUYING_ITEMS_VIP_RESTRICTION
                    end
                    i:AddButton(v.title, itemDescription, {
                        IsDisabled = itemDisabled,
                        RightLabel = price,
                        RightLabelColor = RageUI.ItemsColour.GreenLight
                    }, nil, function()
                        DrinksMenu_DrinkSelected(k)
                    end)
                end
            end

            if Config.BarShowSnacks then
                i:AddSeparator(Translation.BAR_SNACKS_SEPARATOR_SNACKS)

                for x = 1, #CasinoInventoryItems do
                    local v = CasinoInventoryItems[x]
                    local k = v.key

                    if v.itemType == 1 and x ~= 10 then
                        local price = FormatPrice(v.price)
                        i:AddButton(v.title, PLAYER_MONEY >= v.price and Translation.BAR_MENU_DESC2 or
                            string.format(Translation.BAR_MENU_NO_MONEY, price), {
                            IsDisabled = PLAYER_MONEY < v.price,
                            RightLabel = FormatPrice(v.price),
                            RightLabelColor = RageUI.ItemsColour.OrangeLight
                        }, nil, function()
                            DrinksMenu_DrinkSelected(k)
                        end)
                    end
                end
            end

        end, function(Panels)
        end)
    end
    RageUI.Visible(drinksMenu, true)
end

function GameStates_ShowMenu()
    InfoPanel_UpdateNotification(nil)
    CloseAllMenus()
    local statesMenu = RageUI.CreateMenu("", Translation.GAME_STATE_MENU_TITLE, 25, 25, "shopui_title_casino_banner",
        "shopui_title_casino_banner")

    function RageUI.PoolMenus:CashierUI()
        statesMenu:IsVisible(function(i)
            for n = 1, #GameStates do
                local v = GameStates[n]
                i:AddButton(v.title, nil, {
                    IsDisabled = false,
                    RightLabelColor = RageUI.ItemsColour.White,
                    RightBadge = v.enabled and RageUI.BadgeStyle.Tick or RageUI.BadgeStyle.Lock
                }, nil, function()
                    if v.enabled then
                        v.enabled = false
                    else
                        v.enabled = true
                    end
                    TriggerServerEvent("Casino:AdminUpdateStates", GameStates)
                end)
            end
            i:AddSeparator(" ")
            i:AddButton(Translation.BTN_CLOSE, nil, {
                IsDisabled = false,
                RightLabelColor = RageUI.ItemsColour.White,
                RightBadge = RageUI.BadgeStyle.Alert
            }, nil, function()
                CloseAllMenus()
            end)

        end, function(Panels)
        end)
    end
    RageUI.Visible(statesMenu, true)
end

function CloseAllMenus()
    RageUI.CloseAll()
end

function OnMenusClosed()
    -- print("Menus were closed.")
end
