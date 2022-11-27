Cooldowns = {}
Attempts = {}
BankAccounts = {}
SourceBankAccounts = {}

-- [[ Functions ]] --

function RequestAccounts(source)
    local accounts = {}
    if ( SourceBankAccounts[source] == nil ) then
        SourceBankAccounts[source] = {}
    end
    for k, v in pairs(SourceBankAccounts[source]) do
        if BankAccounts[v.account_id] then
            accounts[v.account_id] = BankAccounts[v.account_id]
        end
    end

    return accounts
end

function Get(account, key)
    if BankAccounts[account] then
        return BankAccounts[account][key]
    else
        local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM bank_accounts WHERE account_id = @account_id", { ["@account_id"] = tonumber(account) })
        if #result > 0 then
            BankAccounts[account] = result[1]
            BankAccounts[account].transactions = GetTransactions(account)
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
    if source ~= nil then
        TriggerClientEvent("banking:updateBank", source, account, key, value)
    end
end
exports("Set", Set)

function CanAfford(account, amount)
    local bankAccount = Get(account, "account_balance")
    if not bankAccount or bankAccount == nil then return false end

    if Get(account, "account_balance") >= amount then
        return true
    end
    
    return false
end
exports("CanAfford", CanAfford)

function GetTransactions(account)
    if not account then return end
    local transactions = {}

    transactions = exports.GHMattiMySQL:QueryResult("SELECT * from bank_accounts_transactions WHERE account_id = @account_id ORDER BY transaction_date DESC LIMIT 50", {
        ["@account_id"] = account
    })

    return transactions
end

function AddTransaction(source, data, amount)
    local result = {}
    if data.type == 3 then
        if Get(data.target_account, "account_balance") then
            result = exports.GHMattiMySQL:QueryResult("INSERT INTO bank_accounts_transactions SET transaction_amount = @transaction_amount, transaction_from = @transaction_from, transaction_person = @transaction_person, transaction_type = @transaction_type, transaction_date = CURRENT_TIMESTAMP(), transaction_note = @transaction_note, account_id = @account_id; SELECT * FROM `bank_accounts_transactions` WHERE id=LAST_INSERT_ID() LIMIT 1", {
                ["@account_id"] = data.target_account,
                ["@transaction_type"] = data.type,
                ["@transaction_person"] = exports.character:GetName(source),
                ["@transaction_note"] = data.note,
                ["@transaction_amount"] = amount,
                ["@transaction_from"] = data.account_id
            })[1]
            table.insert(BankAccounts[tonumber(data.target_account)].transactions, 1, result)
            result = exports.GHMattiMySQL:QueryResult("INSERT INTO bank_accounts_transactions SET transaction_to = @transaction_to, transaction_amount = @transaction_amount, transaction_person = @transaction_person, transaction_type = @transaction_type, transaction_date = CURRENT_TIMESTAMP(), transaction_note = @transaction_note, account_id = @account_id; SELECT * FROM `bank_accounts_transactions` WHERE id=LAST_INSERT_ID() LIMIT 1", {
                ["@account_id"] = data.account_id,
                ["@transaction_type"] = data.type,
                ["@transaction_person"] = exports.character:GetName(source),
                ["@transaction_note"] = data.note,
                ["@transaction_amount"] = amount * -1,
                ["@transaction_to"] = data.target_account
            })[1]
            table.insert(BankAccounts[data.account_id].transactions, 1, result)
        end
    else
        result = exports.GHMattiMySQL:QueryResult("INSERT INTO bank_accounts_transactions SET transaction_amount = @transaction_amount, transaction_person = @transaction_person, transaction_type = @transaction_type, transaction_date = CURRENT_TIMESTAMP(), transaction_note = @transaction_note, account_id = @account_id; SELECT * FROM `bank_accounts_transactions` WHERE id=LAST_INSERT_ID() LIMIT 1", {
            ["@account_id"] = data.account_id,
            ["@transaction_type"] = data.type,
            ["@transaction_person"] = exports.character:GetName(source),
            ["@transaction_note"] = data.note,
            ["@transaction_amount"] = amount,
        })[1]
        table.insert(BankAccounts[data.account_id].transactions, 1, result)
    end
    TriggerClientEvent("banking:addTransaction", source, data.account_id, result)
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
        TriggerClientEvent("chat:notify", source, { class="inform", text=notify})
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
    --  TriggerClientEvent("chat:notify", source, notify, "inform")
	-- end
end
exports("Transfer", Transfer)

function StateTax(amount)
    AddBank(nil, 1, amount, nil)
end
exports("StateTax", StateTax)

-- [[ Events: Net ]] --
RegisterNetEvent("banking:transaction")
AddEventHandler("banking:transaction", function(data)
    local source = source
    local amount = tonumber(data.amount)
    if data.type == 1 then -- Deposit
        if exports.inventory:CanAfford(source, amount) then
            exports.inventory:TakeMoney(source, amount)
            AddBank(source, data.account_id, amount)
            AddTransaction(source, data, amount)
        else
            TriggerClientEvent("chat:notify", source, "You cannot afford that!", "error")
        end
    elseif data.type == 2 then -- Withdraw
        if BankAccounts[data.account_id].account_balance >= amount then
            local retval = exports.inventory:GiveMoney(source, amount)
	        if type(retval) == "number" and retval > 0.001 then
                AddBank(source, data.account_id, amount * -1)
                AddTransaction(source, data, amount * -1)
            else
                TriggerClientEvent("chat:notify", source, "You cannot hold that much money!", "error")
            end
        else
            TriggerClientEvent("chat:notify", source, "Your bank account doesn't have that much money!", "error")
        end
    elseif data.type == 3 then -- Transfer
        if BankAccounts[data.account_id].account_balance >= amount then
            if Transfer(source, data.target_account, amount) then
                AddBank(source, data.account_id, amount * -1)
                AddTransaction(source, data, amount)
            end
        end
    else return end
end)

RegisterNetEvent("banking:initAccounts")
AddEventHandler("banking:initAccounts", function(source, character_id)
    local source = source
    SourceBankAccounts[source] = {}
    local ownedAccounts = exports.GHMattiMySQL:QueryResult("SELECT * from bank_accounts WHERE character_id = @character_id", {
        ["@character_id"] = character_id,
    })

    local sharedAccounts = exports.GHMattiMySQL:QueryResult("SELECT bank_accounts.id, bank_accounts.account_id, bank_accounts.account_name, bank_accounts.account_type, bank_accounts.account_balance, bank_accounts.character_id FROM bank_accounts_shared INNER JOIN bank_accounts WHERE bank_accounts.id = bank_accounts_shared.account_id AND bank_accounts_shared.character_id = @character_id", {
        ["@character_id"] = character_id,
    })

    for k, v in pairs(ownedAccounts) do
        if v.account_primary == 1 then
            exports.character:Set(source, "bank", v.account_id)
        end
        SourceBankAccounts[source][v.account_id] = v
        if not BankAccounts[v.account_id] then
            BankAccounts[v.account_id] = v
            BankAccounts[v.account_id].transactions = GetTransactions(v.account_id)
        end
    end

    for k, v in pairs(sharedAccounts) do
        SourceBankAccounts[source][v.account_id] = v
        if not BankAccounts[v.account_id] then
            BankAccounts[v.account_id] = v
            BankAccounts[v.account_id].transactions = GetTransactions(v.account_id)
        end
    end
   
    local accounts = {}
    for k, v in pairs(SourceBankAccounts[source]) do
        if BankAccounts[v.account_id] then
            accounts[v.account_id] = BankAccounts[v.account_id]
        end
    end

    TriggerClientEvent("banking:initAccounts", source, accounts)
end)

RegisterNetEvent("banking:createAccount")
AddEventHandler("banking:createAccount", function(source, character_id, accountName, accountType, isPrimary)
    if SourceBankAccounts[source] == nil then
        SourceBankAccounts[source] = {}
    end

    if isPrimary then
        local account = exports.GHMattiMySQL:QueryResult([[INSERT INTO `bank_accounts` SET character_id = @character_id, account_name = @account_name, account_type = @account_type, account_primary = 1; SELECT * FROM `bank_accounts` WHERE id=LAST_INSERT_ID() LIMIT 1]], { ["@character_id"] = character_id, ["@account_name"] = accountName, ["@account_type"] = accountType })[1]
        exports.GHMattiMySQL:QueryResult("UPDATE `characters` SET bank = @bank WHERE id = @character_id", {["@bank"] = account.account_id, ["@character_id"] = character_id})
        BankAccounts[account.account_id] = account
        BankAccounts[account.account_id].transactions = {}
        SourceBankAccounts[source][account.account_id] = account
        TriggerClientEvent("banking:initAccounts", source, account, true)
    else
        if exports.inventory:CanAfford(source, Config.NewAccountPrice) then
            local account = exports.GHMattiMySQL:QueryResult([[INSERT INTO `bank_accounts` SET character_id = @character_id, account_name = @account_name, account_type = @account_type; SELECT * FROM `bank_accounts` WHERE id=LAST_INSERT_ID() LIMIT 1]], { ["@character_id"] = character_id, ["@account_name"] = accountName, ["@account_type"] = accountType })[1]
            BankAccounts[account.account_id] = account
            BankAccounts[account.account_id].transactions = {}
            SourceBankAccounts[source][account.account_id] = account
            TriggerClientEvent("banking:initAccounts", source, account, true)
            exports.inventory:TakeMoney(source, Config.NewAccountPrice)
            StateTax(Config.NewAccountPrice)
        else
            TriggerClientEvent("chat:notify", source, "You cannot afford a new bank account! ($"..Config.NewAccountPrice..")", "error")
        end
    end
end)

RegisterNetEvent("banking:deleteAccount")
AddEventHandler("banking:deleteAccount", function(account)
    local source = source
    local character_id = exports.character:Get(source, "id")
    if account ~= 1 and character_id then
        if BankAccounts[account] then
            if exports.GHMattiMySQL:Query("DELETE FROM bank_accounts WHERE character_id = "..character_id.." AND account_primary = 0 AND account_id = "..account, {}) then
                BankAccounts[account] = nil
            else
                TriggerClientEvent("chat:notify", source, "You cannot delete your primary account.", "error")
            end
        end

        local accounts = RequestAccounts(source)
        TriggerClientEvent("banking:initAccounts", source, accounts)
    end
end)

RegisterNetEvent("banking:shareAccount")
AddEventHandler("banking:shareAccount", function(accountNumber, stateID)
    local source = source
    local character_id = exports.character:Get(stateID, "id") 
    if character_id then
        local bankAccount = BankAccounts[accountNumber]
        if bankAccount ~= nil then
            if Config.AccountTypes[bankAccount.account_type].Shareable then
                if bankAccount.character_id ~= character_id then 
                    local sharedAccount = exports.GHMattiMySQL:QueryResult("SELECT * FROM bank_accounts_shared WHERE account_id = "..bankAccount.account_id)
                    local account = Get(tonumber(accountNumber), "id")
                    print(account)
                    if account then
                        if #sharedAccount < Config.AccountTypes[bankAccount.account_type].MaxShares then
                            SourceBankAccounts[stateID][account] = BankAccounts[accountNumber]
                            exports.GHMattiMySQL:QueryResult("INSERT INTO bank_accounts_shared SET account_id = @account_id, character_id = @character_id", {
                                ["@account_id"] = account,
                                ["@character_id"] = character_id
                            })
                        else
                            TriggerClientEvent("chat:notify", source, "You cannot share this account anymore! Max "..Config.AccountTypes[bankAccount.account_type].MaxShares.."!", "error")
                        end
                    end
                else
                    TriggerClientEvent("chat:notify", source, "You cannot share with yourself!", "error")
                end
            else
                TriggerClientEvent("chat:notify", source, "You cannot share this type of account!", "error")
            end
        else
            TriggerClientEvent("chat:notify", source, "Invalid Account!", "error")
        end
    else
        TriggerClientEvent("chat:notify", source, "Invalid Character!", "error")
    end
end)

RegisterNetEvent("banking:requestData")
AddEventHandler("banking:requestData", function()
    local source = source
    local accounts = RequestAccounts(source)
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

		exports.inventory:TakeMoney(source, Config.Cards.Price)
	end
end)

exports.chat:RegisterCommand("a:createbaccount", function(source, args, command, cb)
    local stateID = tonumber(args[1])
    local accountName = args[2]
    local character_id = exports.character:Get(stateID, "id")

    if character_id and accountName then
        TriggerEvent("banking:createAccount", stateID, character_id, accountName, 4, false)
    end
end, {
	description = "Create Business Account!",
	parameters = {
		{ name = "Source", help = "Who to give it to" },
        { name = "Account Name", help = "Account Name" }
	}
}, "Admin")

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    local stateAccount = exports.GHMattiMySQL:QueryResult("SELECT * FROM bank_accounts WHERE account_id = 1", {})
    if #stateAccount > 0 then
        BankAccounts[stateAccount[1].account_id] = stateAccount[1]
        BankAccounts[stateAccount[1].account_id].transactions = GetTransactions(stateAccount[1].accound_id)
    end
end)