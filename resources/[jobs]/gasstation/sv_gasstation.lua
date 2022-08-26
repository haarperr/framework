Config.BankAccount = "354724871"
Config.CostPerGallon = 1.13
Config.TaxPerGallon = 0.07

function CalculateFuelCost(fuel)
	local amount = math.floor(fuel * Config.CostPerGallon)
	local tax = CalculateTax(amount)
	local total = math.floor(amount + tax)
	return total, amount, tax
end

function CalculateTax(amount)
	local tax = Config.TaxPerGallon * amount
	return math.floor(tax)
end


function PayBusinessAccount(amount)
	exports.banking:AddBank(nil, tonumber(Config.BankAccount), amount, false)
end

RegisterServerEvent("gasstation:canAfford", function(currentFuel, purchaseMethod)
	local source = source

	if purchaseMethod == "bank" then
		local bankAccount = exports.character:Get(source, "bank")
		if bankAccount ~= nil then
			local total, amount, tax = CalculateFuelCost(currentFuel)
			if exports.banking:CanAfford(bankAccount, total) then
				TriggerClientEvent("gasstation:startPump", source)
				exports.banking:AddBank(source, bankAccount, total, true)
				exports.banking:StateTax(tax)
				PayBusinessAccount(amount)
			else
				TriggerClientEvent("chat:notify", source, { class="error", text="You cannot afford this amount! ($"..amount..")" })
			end
		else
			TriggerClientEvent("chat:notify", source, { class="error", text="You do not have a primary bank account!" })
		end
	elseif purchaseMethod == "cash" then
		local total, amount, tax = CalculateFuelCost(currentFuel)
			if exports.inventory:CanAfford(source, total) then
				TriggerClientEvent("gasstation:startPump", source)
				exports.inventory:TakeMoney(source, total)
				exports.banking:StateTax(tax)
				PayBusinessAccount(amount)
			else
				TriggerClientEvent("chat:notify", source, { class="error", text="You cannot afford this amount! ($"..amount..")" })
			end
	else return end
end)

RegisterServerEvent("gasstation:takeJerry", function()
	local source = source

	exports.inventory:TakeItem(source, "Jerry Can", 1)
end)