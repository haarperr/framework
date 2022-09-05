local cooldowns = {}

RegisterNetEvent("car-wash:wash")
AddEventHandler("car-wash:wash", function()
	local source = source

	if exports.inventory:CanAfford(source, Config.Price, true, true) then
		exports.inventory:TakeBills(source, Config.Price, true, true)
		
		TriggerClientEvent("car-wash:wash", source)
	end
end)