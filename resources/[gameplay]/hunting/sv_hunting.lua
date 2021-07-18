Harvested = {}

RegisterNetEvent("hunting:harvest")
AddEventHandler("hunting:harvest", function(netId, model)
	local source = source
	
	local ped = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(ped) then return end

	if Harvested[ped] then return end
	for ped, _ in pairs(Harvested) do
		if not DoesEntityExist(ped) then
			Harvested[ped] = nil
		end
	end

	local animal = Config.Animals[model]
	if not animal then return end

	exports.log:Add({
		source = source,
		verb = "skinned",
		noun = animal.Name or "?",
		extra = ("net id: %s"):format(netId),
	})

	TriggerClientEvent("hunting:harvested", source, netId)

	for k, item in ipairs(animal.Items) do
		math.randomseed(math.floor(os.clock() * 1000.0) - k)
		if math.random() <= item[3] then
			local amount = item[2]
			if type(amount) == "table" then
				math.randomseed(math.floor(os.clock() * 1000.0) + k)
				amount = math.random(amount[1], amount[2])
			end
			exports.inventory:GiveItem(source, item[1], amount)
		end
	end

	Harvested[ped] = true
end)