Cooldowns = {}
Attempts = {}
BankAccounts = {}
SourceBankAccounts = {}

-- [[ Functions ]] --

function Get(account, key)
    if BankAccounts[account] then
        return BankAccounts[account][key]
    else
        local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM bank_accounts WHERE account_id = @account_id", { ["@account_id"] = tonumber(account) })
        if #result > 0 then
            BankAccounts[account] = result[1]
            return BankAccounts[account][key]
        end
    end

    return false
end
exports("Get", Get)

function Set(source, account, key, value)
    if BankAccounts[account] then 
        BankAccounts[account][key] = value
    end
    exports.GHMattiMySQL:QueryAsync("UPDATE bank_accounts SET "..key.." = "..value.." WHERE account_id = @account_id", {
        ["@account_id"] = account
    })
    TriggerClientEvent("banking:updateBank", source, account, key, value)
end
exports("Set", Set)

function AddTransaction(source, data)
    local result = {}
    if data.transaction_type == 3 then
        result = exports.GHMattiMySQL:QueryResult("INSERT INTO bank_accounts_transactions SET transaction_person = @transaction_person, transaction_type = @transaction_type, transaction_date = CURRENT_TIMESTAMP(), transaction_note = @transaction_note, account_id = @account_id; SELECT * FROM `bank_accounts` WHERE id=LAST_INSERT_ID() LIMIT 1", {
            ["@account_id"] = data.account_id,
            ["@transaction_type"] = data.transaction_type,
            ["@transaction_person"] = data.transaction_person,
            ["@transaction_note"] = data.transaction_note,
        })[1]
    else
        result = exports.GHMattiMySQL:QueryResult("INSERT INTO bank_accounts_transactions SET transaction_from = @transaction_from, transaction_person = @transaction_person, transaction_type = @transaction_type, transaction_date = CURRENT_TIMESTAMP(), transaction_note = @transaction_note, account_id = @account_id; SELECT * FROM `bank_accounts` WHERE id=LAST_INSERT_ID() LIMIT 1", {
            ["@account_id"] = data.account_id,
            ["@transaction_type"] = data.transaction_type,
            ["@transaction_person"] = data.transaction_person,
            ["@transaction_note"] = data.transaction_note,
            ["@transaction_from"] = data.transaction_from,
        })[1]
    end
    TriggerClientEvent("banking:addTransaction", source, account, result)
end

function AddBank(source, account, amount, notify)
    if type(amount) ~= "number" then return end

    local balance = Get(account, "account_balance")
    if not balance then return end
        
    Set(source, account, "account_balance", balance + amount)
   
    if notify then
		if amount > 0 then
			notify = "$"..tostring(exports.misc:FormatNumber(amount)).." has been added to your account!"
		else
			notify = "$"..tostring(exports.misc:FormatNumber(math.abs(amount))).." has been deducted from your account!"
		end
		TriggerClientEvent("notify:sendAlert", source, "inform", notify, 7000)
	end
end
exports("AddBank", AddBank)

function Transfer(source, account, amount, notify)
    if type(amount) ~= "number" then return end

    local balance = Get(tonumber(account), "account_balance")
    if not balance then return end
        
    Set(source, tonumber(account), "account_balance", balance + amount)
   
    return true
    -- if notify then
	-- 	if amount > 0 then
	-- 		notify = "$"..tostring(exports.misc:FormatNumber(amount)).." has been added to your account!"
	-- 	else
	-- 		notify = "$"..tostring(exports.misc:FormatNumber(math.abs(amount))).." has been deducted from your account!"
	-- 	end
	-- 	TriggerClientEvent("notify:sendAlert", source, "inform", notify, 7000)
	-- end
end
exports("Transfer", Transfer)

-- [[ Events: Net ]] --
RegisterNetEvent("banking:transaction")
AddEventHandler("banking:transaction", function(data)
    local amount = tonumber(data.amount)
    if data.type == 1 then -- Deposit
        if exports.inventory:CanAfford(source, amount) then
            exports.inventory:TakeMoney(source, amount)
            AddBank(source, data.account_id, amount)
        else
            -- Anti Cheat BAn
        end
    elseif data.type == 2 then -- Withdraw
        if BankAccounts[data.account_id].account_balance >= amount then
            AddBank(source, data.account_id, amount * -1)
            exports.inventory:GiveMoney(source, amount)
        else
            -- Anti Cheat Ban
        end
    elseif data.type == 3 then -- Transfer
        if BankAccounts[data.account_id].account_balance >= amount then
            if Transfer(source, data.target_account, amount) then
                AddBank(source, data.account_id, amount * -1)
            end
        end
    else return end

    AddTransaction(source, data)
end)

RegisterNetEvent("banking:initAccounts")
AddEventHandler("banking:initAccounts", function(source, character_id)
    local source = source
    SourceBankAccounts[source] = {}
    local ownedAccounts = exports.GHMattiMySQL:QueryResult("SELECT bank_accounts.id, bank_accounts.account_id, bank_accounts.account_name, bank_accounts.account_type, bank_accounts.account_balance, bank_accounts.character_id from bank_accounts WHERE character_id = @character_id", {
        ["@character_id"] = character_id,
    })

    local sharedAccounts = exports.GHMattiMySQL:QueryResult("SELECT bank_accounts.id, bank_accounts.account_id, bank_accounts.account_name, bank_accounts.account_type, bank_accounts.account_balance, bank_accounts.character_id FROM bank_accounts_shared INNER JOIN bank_accounts WHERE bank_accounts.id = bank_accounts_shared.account_id AND bank_accounts_shared.character_id = @character_id", {
        ["@character_id"] = character_id,
    })

    for k, v in pairs(ownedAccounts) do
        if not BankAccounts[v.account_id] then
            BankAccounts[v.account_id] = v
            SourceBankAccounts[source][v.account_id] = v
        end
    end

    for k, v in pairs(sharedAccounts) do
        if not BankAccounts[v.account_id] then
            BankAccounts[v.account_id] = v
            SourceBankAccounts[source][v.account_id] = v
        end
    end
end)

RegisterNetEvent("banking:createAccount")
AddEventHandler("banking:createAccount", function(source, character_id, accountName, accountType, isPrimary)
    local account = exports.GHMattiMySQL:QueryResult([[INSERT INTO `bank_accounts` SET character_id = @character_id, account_name = @account_name, account_type = @account_type; SELECT * FROM `bank_accounts` WHERE id=LAST_INSERT_ID() LIMIT 1]], { ["@character_id"] = character_id, ["@account_name"] = accountName, ["@account_type"] = accountType })[1]
    if isPrimary then
        exports.GHMattiMySQL:QueryResult("UPDATE `characters` SET bank = @bank WHERE id = @character_id", {["@bank"] = account.id, ["@character_id"] = character_id})
    end
    BankAccounts[account.id] = account
    TriggerClientEvent("banking:initAccounts", source, account, true)
end)

RegisterNetEvent("banking:getAccountTransactions")
AddEventHandler("banking:getAccountTransactions", function(account)
    if not account then return end

    local transactions = exports.GHMattiMySQL:QueryResult("SELECT * from bank_accounts_transactions WHERE account_id = @account_id", {
        ["@account_id"] = account
    })
end)

RegisterNetEvent("banking:requestData")
AddEventHandler("banking:requestData", function()
    local source = source
    local accounts = {}
    for k, v in pairs(SourceBankAccounts[source]) do
        if BankAccounts[v.account_id] then
            accounts[v.account_id] = BankAccounts[v.account_id]
        end
    end
    TriggerClientEvent("banking:initAccounts", source, accounts)
end)

RegisterNetEvent("interact:on_bank-card")
AddEventHandler("interact:on_bank-card", function()
	local source = source
	local canAfford = exports.inventory:CanAfford(source, Config.Cards.Price)
	if not canAfford then return end
	
	if exports.inventory:GiveItem(source, Config.Cards.Item) then
		exports.log:Add({
			source = source,
			verb = "bought",
			noun = Config.Cards.Item,
		})

		exports.inventory:TakeBills(source, Config.Cards.Price)
	end
end)