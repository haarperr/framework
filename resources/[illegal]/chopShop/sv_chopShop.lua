LastListTime = 0
NextListTime = 0
Seed = 0
List = nil
Cooldowns = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Seed = os.time()
		math.randomseed(Seed)

		local delay = math.random(Config.ListDuration.Min, Config.ListDuration.Max)
		LastListTime = os.time()
		NextListTime = os.time() + delay * 60
		List = GetList(Seed)
		
		math.randomseed(GetGameTimer())

		TriggerClientEvent("chopShop:updateSeed", -1, Seed)

		Citizen.Wait(delay * 60000)
	end
end)

--[[ Functions ]]--
function FindCar(index, list)
	if not list then list = GetList(Seed) end

	for k, v in ipairs(list) do
		if index == v.index then
			return v.car
		end
	end
	return nil
end

function FindComponent(componentType, componentIndex)
	for k, v in ipairs(Config.Components) do
		if componentType == v.Type and componentIndex == v.Index then
			return v
		end
	end
	return nil
end

--[[ Events ]]--
RegisterNetEvent("chopShop:requestSeed")
AddEventHandler("chopShop:requestSeed", function()
	TriggerClientEvent("chopShop:updateSeed", source, Seed)
end)

RegisterNetEvent("chopShop:requestTime")
AddEventHandler("chopShop:requestTime", function()
	TriggerClientEvent("chopShop:receiveTime", source, NextListTime - os.time())
end)

RegisterNetEvent("chopShop:beginScrapping")
AddEventHandler("chopShop:beginScrapping", function(vehicle, plate, zone)
	local source = source
	local owned = exports.garages:GetVehicleByPlate(plate)

	if owned then
		TriggerClientEvent("notify:sendAlert", source, "error", "That's one hot whip.. try something else.", 10000)
		return
	end

	TriggerClientEvent("chopShop:beginScrapping", source, vehicle, zone)
end)

RegisterNetEvent("chopShop:chopVehicle")
AddEventHandler("chopShop:chopVehicle", function(index, modifier, netId)
	local source = source

	local vehicle = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
	if not DoesEntityExist(vehicle) then return end

	-- Cooldown to prevent spam.
	if Cooldowns[source] then
		TriggerClientEvent("chopShop:chopResult", source, 2)
		return
	end

	Cooldowns[source] = true
	Citizen.CreateThread(function()
		Citizen.Wait(10000)
		Cooldowns[source] = nil
	end)

	-- Find car from index.
	local car = FindCar(index, List)
	if not car then
		TriggerClientEvent("chopShop:chopResult", source, 3)
		return
	end

	print(index)

	modifier = math.min(math.max(modifier, 0.0), 1.0)

	-- Chop the car.
	local presence = exports.jobs:CountActiveDuty("ChopShop")
	local result = 1
	if presence >= Config.Presence.Min then
		local price = math.floor(car.BasePrice * math.min(1.0 + (presence - Config.Presence.Min + 1) / (Config.Presence.Max - Config.Presence.Min + 1), Config.Presence.MaxRate) * modifier)
		if price == 0 or exports.inventory:GiveMoney(source, price) then
			exports.log:Add({
				source = source,
				verb = "chopped",
				noun = "vehicle",
				extra = ("for: $%s"):format(price),
			})
			DeleteEntity(vehicle)
			result = 0
		else
			result = 4
		end
	else
		result = 1
	end
	TriggerClientEvent("chopShop:chopResult", source, result)
end)

RegisterNetEvent("chopShop:chopPayout")
AddEventHandler("chopShop:chopPayout", function(index, choppedVehicle, carClass, componentType, componentIndex, netId)
	local source = source

	local vehicle = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
	if not DoesEntityExist(vehicle) then return end
	
	local presence = exports.jobs:CountActiveDuty("ChopShop")
	if presence >= Config.Presence.Min then
		-- Find car from index.
		local car = FindCar(index, List)
		if not car then
			TriggerClientEvent("chopShop:chopResult", source, 3)
			return
		end

		-- Find the component.
		local part = FindComponent(componentType, componentIndex)
		
		if not part or not part.Items then return end

		local totalChance = 0.0
		for item, settings in pairs(part.Items) do
			totalChance = totalChance + settings.Chance
		end

		local seed = math.floor(os.clock() * 1000)
		for item, settings in pairs(part.Items) do
			totalChance = totalChance - settings.Chance

			math.randomseed(seed)
			local random = math.random() * totalChance
			print(totalChance, settings.Chance, random)
			if settings.Chance > random then
				local amount = math.floor(math.random(settings.Amount[1], settings.Amount[2]) * Config.Classes[carClass])
				exports.inventory:GiveItem(source, item, amount)
				goto endLoop
			end
			seed = seed + 1
		end
		::endLoop::
		
		TriggerClientEvent("chopShop:updateComponent", source, choppedVehicle, componentType, componentIndex)
	else
		TriggerClientEvent("chopShop:chopResult", source, 1)
	end
end)