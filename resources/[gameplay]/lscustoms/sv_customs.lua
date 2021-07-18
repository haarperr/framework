RegisterNetEvent("lscustoms:purchase")
AddEventHandler("lscustoms:purchase", function(id, price)
	local source = source
	if type(price) ~= "number" or type(id) ~= "string" then return end
	if price < 0 then
		exports.log:Add({
			source = source,
			verb = "purchased",
			noun = "repairs/upgrades",
			extra = ("price: %s"):format(price),
			channel = "cheat",
		})
		return
	end

	local canAfford = exports.inventory:CanAfford(source, price, SharedConfig.Purchases.Flag, SharedConfig.Purchases.UseCard)
	if not canAfford then return end

	exports.log:Add({
		source = source,
		verb = "purchased",
		noun = "repairs/upgrades",
		extra = ("price: %s"):format(price),
	})

	exports.inventory:TakeBills(source, price, SharedConfig.Purchases.Flag, SharedConfig.Purchases.UseCard)
end)