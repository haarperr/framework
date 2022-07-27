NearestAtm = nil
IsUsingAtm = false
Bank = {
	Accounts = {

	},

}

--[[ Functions ]]--
function ToggleMenu(toggle, info)
	SetNuiFocus(toggle, toggle)
	SetNuiFocusKeepInput(false)

	if not toggle then
		SendNUIMessage({
			open = false
		})

		return
	end

	if not info then
		info = {}
	end

	local bills, counterfeit, marked = exports.inventory:CountMoney() or 0.0

	info.name = exports.character:GetName(PlayerId())
	info.balance = exports.character:Get("bank")
	info.bank = (Config.BankTypes[info.bank or ""] or {}).Name
	info.available = bills
	-- info.unavailable = counterfeit + marked

	SendNUIMessage({
		open = toggle,
		info = info
	})

	IsUsingAtm = toggle
end
exports("ToggleMenu", ToggleMenu)

function RegisterAtms()
	for k, atm in ipairs(Config.Atms) do
		local id = ("atm-%s"):format(k)
		
		exports.interact:Register({
			id = id,
			text = "Use ATM",
			model = atm.Model
		})

		AddEventHandler("interact:on_"..id, function()
			ToggleMenu(true, {
				bank = atm.Type,
			})
		end)
	end
end

function RegisterDesks()
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
	RegisterAtms()
	RegisterDesks()
end)

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
			ToggleMenu(true, bank)
		end)
	end
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("toggle", function(data)
	ToggleMenu(false)
end)

RegisterNUICallback("transfer", function(data)
	ToggleMenu(false)
	TriggerServerEvent("banking:transfer", data.type, data.amount, data.target)
end)

RegisterNUICallback("createAccount", function(data)

end)

RegisterNUICallback("deleteAccount", function(data)

end)