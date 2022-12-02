Cache = {}

--[[ Initialization ]]--
for k, dealer in ipairs(Config.Dealers) do
	for vehicleModel, vehicleData in pairs(dealer.Vehicles) do
		local vehicle = vehicleModel
		if type(vehicleModel) == "number" then vehicle = vehicleData end

		Cache[vehicle] = true
	end
end

--[[ Events ]]--
RegisterNetEvent("car-dealer:purchase")
AddEventHandler("car-dealer:purchase", function(dealer, name, class)
	local source = source
	
	if not Cache[name] then return end

	local dealerSettings = Config.Dealers[dealer]
	if not dealerSettings then return end

	local vehicleSettings = exports.vehicles:GetSettings(name)
	if not vehicleSettings then return end

	local tax = vehicleSettings.Value * Config.Tax
	local price = math.floor(vehicleSettings.Value + tax)

	-- Take money.
	local primaryAccount = exports.character:Get(source, "bank")
	if not primaryAccount then
		TriggerClientEvent("chat:notify", source, "You don't have a bank account?", "error")
		return true
	end

	if exports.inventory:CanAfford(source, price, true, true) then
		exports.inventory:TakeMoney(source, price, true)
		exports.banking:StateTax(tax)
		TriggerClientEvent("chat:notify", source, "You spent $"..price.."!", "success")
		exports.garages:AddVehicle(source, name, dealerSettings.Garage or Config.Garages[class] or 1, function(vehicle)
			TriggerClientEvent("car-dealer:confirmPurchase", source, vehicle)
		end)
	else
		TriggerClientEvent("chat:notify", source, "You don't have enough for that!", "error")
	end
end)

RegisterNetEvent("car-dealer:sellBack")
AddEventHandler("car-dealer:sellBack", function(netId)
	local source = source
	local entity = NetworkGetEntityFromNetworkId(netId)
	local vehicle = (exports.garages:GetVehicle(exports.garages:GetId(entity)) or {}).vehicle
	local characterId = exports.character:Get(source, "id")
	if vehicle == nil or vehicle.character_id ~= characterId then
		TriggerClientEvent("chat:notify", source, "This doesn't belong to you!", "error")
		return
	end

	local value = math.floor(((exports.vehicles:GetSettings(vehicle.model) or {}).Value or 0) * Config.Buyer.Delimiter)

	exports.interact:SendConfirm(source, source, "You are about to sell this vehicle for $"..exports.misc:FormatNumber(value), function(wasAccepted)
		if not wasAccepted then return end
		if characterId ~= exports.character:Get(source, "id") then return end

		local character = exports.character:GetCharacter(source)
		if not character then return end

		local bankAccount = exports.character:Get(source, "bank")
		if not bankAccount then
			return
		end

		if not exports.banking:Get(bankAccount, "account_id") then
			return
		end

		if exports.garages:DeleteVehicle(vehicle.id) then
			exports.log:Add({
				source = source,
				verb = "sold",
				noun = "vehicle",
				extra = ("id: %s - money: $%s"):format(vehicle.id, value),
			})
			TriggerClientEvent("chat:notify", source, { text = "Your vehicle was sold for $"..exports.misc:FormatNumber(value).." and the money was transferred to your account.", class = "inform" })
			exports.banking:AddBank(source, bankAccount, value)
			--exports.log:AddEarnings(source, "Vehicles", value)
		end
	end)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("vehicle:transfer", function(source, args, rawCommand)
	local fee = 250
	local vehicleId, target = tonumber(args[1]), tonumber(args[2])

	-- Self check.
	if source == target then return end

	-- Get character ids.
	local sourceId = exports.character:Get(source, "id")
	local targetId = target and exports.character:Get(target, "id")

	-- Check target.
	if not targetId then
		TriggerClientEvent("chat:addMessage", source, "Target not found!")
		return
	end

	-- Get vehicle.
	local sourceVehicles = exports.character:Get(source, "vehicles")
	if not sourceVehicles then return end

	local vehicle = vehicleId and sourceVehicles[vehicleId]

	-- Check vehicle.
	if not vehicle then
		TriggerClientEvent("chat:addMessage", source, "Vehicle not found!")
		return
	end

	-- Chat message.
	TriggerClientEvent("chat:notify", source, "Showing paperwork...", "inform")

	-- Send confirmation.
	exports.interact:SendConfirm(source, target, "A vehicle transfer requires your signature. There will be a $"..fee.." fee", function(didAccept)
		if not didAccept then
			TriggerClientEvent("chat:notify", source, "They didn't sign...", "error")
			return
		end

		-- Check vehicles.
		local sourceVehicles = exports.character:Get(source, "vehicles")
		if not sourceVehicles or not sourceVehicles[vehicleId] then
			return
		end

		-- Get target vehicles.
		local targetVehicles = exports.character:Get(target, "vehicles")
		if not targetVehicles then return end

		-- Check characters.
		if
			exports.character:Get(source, "id") ~= sourceId or
			exports.character:Get(target, "id") ~= targetId
		then
			return
		end

		-- Check money.
		if not exports.inventory:CanAfford(target, fee, true, true) then
			for _, player in ipairs({ source, target }) do
				TriggerClientEvent("chat:notify", source, "Transaction failed...", "error")
			end

			return
		end

		exports.inventory:TakeMoney(target, fee, 0, true)

		-- Log.
		exports.log:Add({
			source = source,
			target = target,
			verb = "transferred",
			noun = "vehicle",
			extra = ("id: %s"):format(vehicleId),
		})

		-- Set targets.
		exports.ghmattimysql:QueryAsync("UPDATE vehicles SET character_id=@newId WHERE id=@id AND character_id=@oldId", {
			["@id"] = vehicleId,
			["@newId"] = targetId,
			["@oldId"] = sourceId,
		})

		-- Update vehicles.
		targetVehicles[vehicleId] = vehicle
		sourceVehicles[vehicleId] = nil

		exports.character:Set(source, "vehicles", sourceVehicles)
		exports.character:Set(target, "vehicles", targetVehicles)

		-- Chat message.
		TriggerClientEvent("chat:addMessage", source, ("Transferred vehicle %s to [%s]!"):format(vehicleId, target))
		TriggerClientEvent("chat:addMessage", target, ("Received vehicle %s!"):format(vehicleId))
	end, true)
end, {
	description = "Transfer one of your vehicles to another person.",
	parameters = {
		{ name = "Vehicle", description = "The vehicle to transfer, use the identification number found in the phone." },
		{ name = "Target", description = "The person to transfer to, using their server ID." },
	}
}, 2)