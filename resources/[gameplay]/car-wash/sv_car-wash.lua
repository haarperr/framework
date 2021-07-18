local cooldowns = {}

RegisterNetEvent("car-wash:wash")
AddEventHandler("car-wash:wash", function()
	local source = source

	if os.time() - (cooldowns[source] or 0) < 2 then return end
	cooldowns[source] = os.time()

	if exports.inventory:CanAfford(source, Config.Price, 1, true) then
		exports.inventory:TakeBills(source, Config.Price, 1, true)
		
		TriggerClientEvent("car-wash:wash", source)
	end
end)