Players = {}

RegisterNetEvent("drugs:attemptSell")
AddEventHandler("drugs:attemptSell", function(zone, drug)
	local source = source
	zone = Config.Zones[zone]
	if not zone then return end

	local prices = Config.Prices[drug]
	if not prices then return end

	math.randomseed(os.clock())
	local price = math.random(prices.Min, prices.Max)

	-- Cop price bonus.
	local cops = exports.jobs:CountActiveDuty("DrugBonus")
	price = math.floor(price * (1.0 + math.min(math.max(cops / (prices.MaxCops or 4), 0.0), 1.0) * (prices.CopRate or 0.2)))

	-- Territory price bonus.
	-- if GetResourceState("territories") == "started" and exports.territories:HasControlOverCurrentZone(source) then
	-- 	price = math.ceil(price * Config.Slinging.TerritoryBonus)
	-- end

	-- Amount.
	math.randomseed(os.clock() + 42)
	local amount = math.max(math.ceil(math.min(exports.inventory:CountItem(exports.inventory:GetPlayerContainer(source), drug) or 0, prices.Cap) * math.random()), 1)

	Players[source] = { drug = drug, price = price, amount = amount }
	TriggerClientEvent("drugs:attemptSell", source, price, amount)
end)

RegisterNetEvent("drugs:sell")
AddEventHandler("drugs:sell", function()
	local source = source
	local cache = Players[source]
	if not cache then return end

	if exports.inventory:CountItem(source, cache.drug) < cache.amount then
		TriggerClientEvent("drugs:stopSelling", source)
		return
	end
	
	local price = cache.amount * cache.price

	exports.log:Add({
		source = source,
		verb = "sold",
		noun = cache.drug,
		extra = ("%s for $%s"):format(cache.amount, price),
	})

	--exports.log:AddEarnings(source, "Drugs/"..tostring(cache.drug), price)

	exports.inventory:TakeItem(source, cache.drug, cache.amount)
	exports.inventory:GiveMoney(source, price)

	TriggerClientEvent("drugs:sell", source)

	TriggerEvent("drugs:sold", source, cache.drug, cache.amount, price)
	
	Players[source] = nil
end)