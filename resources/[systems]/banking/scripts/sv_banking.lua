Cooldowns = {}
Attempts = {}
BankAccounts = {}

-- [[ Functions ]] --

function Get(account, key)
    return BankAccounts[account][key]
end
exports("Get", Get)

function Set(source, account, key, value)
    BankAccounts[account][key] = value
    exports.GHMattiMySQL:QueryAsync("UPDATE bank_accounts SET "..key.." = "..value.." WHERE account_id = @account_id", {
        ["@account_id"] = account
    })
    TriggerClientEvent("banking:updateBank", source, account, key, value)
end
exports("Set", Set)

function AddTransaction(source, data)
    -- local result = {}
    -- result = exports.GHMattiMySQL:QueryResult("INSERT INTO bank_accounts_transactions SET transaction.note", {
    --     [""] = ,
    -- })[1]
    -- TriggerClientEvent("banking:addTransaction", source, account, result)
end

function AddBank(source, account, amount, notify)
    if type(amount) ~= number then return end

    local balance = Get(account, "balance")
    if not balance then return end
        
    Set(source, account, "balance", balance + amount)
   
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

-- [[ Events: Net ]] --
RegisterNetEvent("banking:transaction")
AddEventHandler("banking:transactions", function(data)
    if data.type == 1 then -- Deposit
        if exports.inventory:CountCash() >= data.amount then
            -- Task Cash
            AddBank(data.amount)
        else
            -- Anti Cheat BAn
        end
    elseif data.type == 2 then -- Withdraw
        if BankAccounts[data.id].account_balance >= data.amount then
            AddBank(source, data.amount * -1)
            -- Add Cash
        else
            -- Anti Cheat Ban
        end
    elseif data.type == 3 then -- Transfer
        if BankAccounts[data.id].account_balance >= data.amount then
            AddBank(source, data.id, data.amount * -1)
            AddBank(source, data.target, data.amount)
        end
    else return end

    AddTransaction(source, data)
end)

RegisterNetEvent("banking:initAccounts")
AddEventHandler("banking:initAccounts", function(source, character_id)
    local ownedAccounts = exports.GHMattiMySQL:QueryResult("SELECT bank_accounts.id, bank_accounts.account_id, bank_accounts.account_name, bank_accounts.account_type, bank_accounts.account_balance, bank_accounts.character_id from bank_accounts WHERE character_id = @character_id", {
        ["@character_id"] = character_id,
    })

    local sharedAccounts = exports.GHMattiMySQL:QueryResult("SELECT bank_accounts.id, bank_accounts.account_id, bank_accounts.account_name, bank_accounts.account_type, bank_accounts.account_balance, bank_accounts.character_id FROM bank_accounts_shared INNER JOIN bank_accounts WHERE bank_accounts.id = bank_accounts_shared.account_id AND bank_accounts_shared.character_id = @character_id", {
        ["@character_id"] = character_id,
    })
    
    local clientAccounts = {}

    for k, v in pairs(ownedAccounts) do
        if not BankAccounts[v.id] then
            BankAccounts[v.id] = v
            table.insert(clientAccounts, v)
        end
    end

    for k, v in pairs(sharedAccounts) do
        if not BankAccounts[v.id] then
            BankAccounts[v.id] = v
            table.insert(clientAccounts, v)
        end
    end

    TriggerClientEvent("banking:initAccounts", source, clientAccounts)
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