Banking = {
    toggleMenu = false,
    isUsingAtm = false,
    nearestAtm = nil,
	accounts = {},
}


function Banking:ToggleMenu(toggle, info)
    self.toggleMenu = toggle

    SetNuiFocus(self.toggleMenu, self.toggleMenu)
    SetNuiFocusKeepInput(false)

    SendNUIMessage({ open = self.toggleMenu })

    if not info then
        info = {}
    end

    local bills = exports.inventory:CountMoney()

    info.name = exports.character:GetName(PlayerId())
    info.bank = (Config.BankTypes[info.bank or ""] or {}).name
    info.cash = bills

	TriggerServerEvent("banking:requestData")

    SendNUIMessage({
        info = info
    })

    self.isUsingAtm = self.toggleMenu
end

function Banking:RegisterAtms()
    for k, atm in ipairs(Config.Atms) do
		local id = ("atm-%s"):format(k)
		
		exports.interact:Register({
			id = id,
			text = "Use ATM",
			model = atm.Model
		})

		AddEventHandler("interact:on_"..id, function()
			Banking:ToggleMenu(true, {
				bank = atm.Type,
			})
		end)
	end
end

function Banking:RegisterDesks()
	for k, desk in ipairs(Config.Desks) do
		local id = ("bankDesk-%s"):format(k)
		
		exports.interact:Register({
			id = id,
			embedded = {
				{
					id = "bank-card",
					text = Config.Cards.Item,
					items = {
						{ name = "Bills", amount = Config.Cards.Price },
					}
				},
				{
					id = "bank-coin",
					text = "Trade Coins",
				},
			},
			coords = desk.Coords,
			radius = desk.Radius,
		})
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	Banking:RegisterAtms()
	Banking:RegisterDesks()
end)

-- [[ NUI ]] --
RegisterNUICallback("transaction", function(payload)
    TriggerServerEvent("banking:transaction", payload.data)
end)

RegisterNUICallback("createAccount", function(payload)
	TriggerServerEvent("banking:createAccount", GetPlayerServerId(PlayerId()), exports.character:Get("id"), payload.data.account_name, payload.data.type)
end)

RegisterNUICallback("closeMenu", function()
    Banking:ToggleMenu(false)
end)

-- [[ Events ]] --
--[[ Resource Events ]]--
AddEventHandler("banking:clientStart", function()
	for k, bank in ipairs(Config.Banks) do
		local id = "bank-"..tostring(k)
		local kiosk = "kiosk-"..tostring(k)
		if not bank.NoBlip then
			exports.blips:CreateBlip(bank.Coords, Config.Blips.Bank, id)
		end
		exports.interact:Register({
			id = kiosk,
			embedded = {
				{
					id = id,
					text = Config.Interact.Text,
				},
				{
					id = "bank-card",
					text = Config.Cards.Item,
					items = {
						{ name = "Bills", amount = Config.Cards.Price },
					}
				},
				{
					id = "bank-coin",
					text = "Trade Coins",
				},
			},
			coords = bank.Coords,
			radius = Config.Interact.Radius,
		})
		
		bank.isBank = true

		AddEventHandler("interact:on_"..id, function()
			Banking:ToggleMenu(true, bank)
		end)
	end
end)

RegisterNetEvent("banking:initAccounts")
AddEventHandler("banking:initAccounts", function(data, insert)
	if insert then
		Banking.accounts[data.account_id] = data
	else
		Banking.accounts = data
	end
    SendNUIMessage({ commit = Banking.accounts, type="accounts" })
end)

RegisterNetEvent("banking:updateBank")
AddEventHandler("banking:updateBank", function(account, key, value)
	if Banking.accounts[tonumber(account)] then
		Banking.accounts[tonumber(account)][key] = value
		SendNUIMessage({ commit = Banking.accounts, type="accounts" })
	end
end)

RegisterNetEvent("banking:addTransaction")
AddEventHandler("banking:addTransaction", function(account, transaction)
	table.insert(Banking.accounts[account].transactions, 1, transaction)
	SendNUIMessage({ commit = Banking.accounts, type="accounts" })
end)