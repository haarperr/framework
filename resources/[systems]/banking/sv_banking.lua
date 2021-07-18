Cooldowns = {}
Attempts = {}

RegisterNetEvent("banking:transfer")
AddEventHandler("banking:transfer", function(typeof, amount, target)
	local source = source

	if (os.clock() - (Cooldowns[source] or 0.0)) < 3.0 then
		TriggerEvent("chat:addMessage", source, "Slow down!")
		Attempts[source] = (Attempts[source] or 0) + 1

		if Attempts[source] >= 15 then
			exports.sv_test:Report(source, "15 bank transfers in 3 seconds", false)
			Attempts[source] = nil
		end

		return
	end

	Attempts[source] = nil
	Cooldowns[source] = os.clock()

	if type(typeof) ~= "number" then return end
	amount = tonumber(amount)
	if not amount or amount <= 0 then
		TriggerEvent("chat:addMessage", source, "Amount must be a number!")
		return
	end
	amount = math.floor(amount)

	local bank = exports.character:Get(source, "bank")
	if not bank then return end

	if typeof == 0 then
		-- Withdraw.
		if bank - amount >= 0 then
			bank = bank - amount
			exports.log:Add({
				source = source,
				verb = "withdrew",
				noun = "money",
				extra = ("$%s"):format(amount),
			})
			exports.inventory:GiveItem(source, "Bills", amount)
			TriggerEvent("chat:addMessage", source, ("Withdrew $%s!"):format(amount))
		else
			TriggerEvent("chat:addMessage", source, ("Missing $%s!"):format(math.abs(bank - amount)))
		end
	elseif typeof == 1 then
		-- Deposit.
		local bills = table.unpack(exports.inventory:CountBills(source, true))
		if bills - amount >= 0 then
			bank = bank + amount
			exports.log:Add({
				source = source,
				target = target,
				verb = "deposited",
				noun = "money",
				extra = ("$%s"):format(amount),
			})
			exports.inventory:TakeBills(source, amount, 0)
			TriggerEvent("chat:addMessage", source, ("Deposited $%s!"):format(amount))
		else
			TriggerEvent("chat:addMessage", source, ("Missing $%s!"):format(math.abs(bills - amount)))
		end
	elseif typeof == 3 then
		-- Transfer.
		-- TODO.
	end
	exports.character:Set(source, "bank", bank)
	exports.character:Save(source, "bank")
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

RegisterNetEvent("interact:on_bank-coin")
AddEventHandler("interact:on_bank-coin", function()
	local source = source
	local total = 0

	local container = exports.inventory:GetPlayerContainer(source)
	if not container then return end

	for k, coin in ipairs(Config.Coins) do
		local count = exports.inventory:CountItem(container, coin.Name)
		local amount = math.floor(count / coin.OneDollar)

		if amount > 0 then
			exports.inventory:TakeItem(source, coin.Name, amount * coin.OneDollar)
			total = total + amount
		end
	end

	if total <= 0 then return end
	
	exports.log:Add({
		source = source,
		verb = "exchanged",
		noun = "coins",
		extra = ("$%s"):format(total),
	})

	exports.inventory:GiveItem(source, "Bills", total)
end)