Containers = {}
Cooldowns = {}
Grids = {}
Properties = nil
PropertyIds = {}
Seed = 0

--[[ Functions ]]--
local function CheckRealtor(source, target, property)
	if not exports.jobs:IsOnDuty(source, "realtor") then
		TriggerClientEvent("chat:addMessage", source, "Must be on duty!")
		return false
	end

	local targetCharacter = exports.character:Get(target, "id")
	if not targetCharacter then
		TriggerClientEvent("chat:addMessage", source, "Invalid target!")
		return false
	end

	property = Properties[property or -1]
	if not property then
		TriggerClientEvent("chat:addMessage", source, "Invalid property!")
		return false
	end

	local ped = GetPlayerPed(source)
	if not ped then return false end
	
	local targetPed = GetPlayerPed(target)
	if not targetPed then return false end

	local pedCoords = GetEntityCoords(ped)
	local targetCoords = GetEntityCoords(targetPed)

	if #(pedCoords - targetCoords) > 10.0 or #(pedCoords - vector3(property.x, property.y, property.z)) > 10.0 then
		TriggerClientEvent("chat:addMessage", source, "Not close enough!")
		return false
	end

	return true
end

local function CheckCount(source, properties, _type)
	local counts = {}
	for k, property in ipairs(properties) do
		local settings = Config.Types[property.type]
		counts[property.type] = (counts[property.type] or 0) + 1
		if property.type == _type and counts[property.type] >= (settings.Max or 1) then
			TriggerClientEvent("chat:addMessage", source, ("You cannot buy another %s, you have too many!"):format(settings.Name))
			return false
		end
	end
	return true
end

function SetOwnership(source, id, price, lender, downPayment, mortgage)
	local property = Properties[id]
	if not property then return false end

	local settings = Config.Types[property.type]
	if not settings then return end

	local character = exports.character:GetCharacter(source)
	if not character then return false end

	property.character_id = character.id
	local properties = character.properties
	properties[#properties + 1] = property
	
	exports.character:Set(source, "properties", properties)
	TriggerClientEvent("properties:update", -1, property)
	TriggerClientEvent("properties:bought", source, id)

	local transactions = {
		"UPDATE properties SET character_id=@character_id WHERE id=@id",
	}

	if price ~= 0 then
		transactions[#transactions + 1] = "CALL payments_add(@character_id, "..(lender or "NULL")..", @id, NULL, @days, @price, "..(mortgage or "0")..")"
	end
	
	exports.log:Add({
		source = source,
		verb = "purchased",
		noun = "property",
		extra = ("id: %s - price: $%s - down: $%s - mortgage: $%s"):format(id, price or 0, downPayment or 0, mortgage or 0),
	})
	
	exports.GHMattiMySQL:Transaction(transactions, {
		["@character_id"] = character.id,
		["@id"] = id,
		["@days"] = Config.PaymentDays,
		["@price"] = price,
	})
	
	exports.inventory:TakeMoney(source, downPayment or price, settings.PaymentFlag or 0, true)

	return true
end

function HasProperty(source, id)
	if Config.Debug then
		return true
	end

	local property = Properties[id]
	if not property then return false end
	
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	if character.id == property.character_id then
		return true
	end

	if character.keys then
		for k, key in ipairs(character.keys) do
			if key.property_id == id then
				return true
			end
		end
	end

	return false
end
exports("HasProperty", HasProperty)

function ToggleLock(id, value)
	local property = Properties[id]
	if not property then return false end

	if value ~= nil then
		property.open = value
	else
		property.open = not property.open
	end

	TriggerClientEvent("properties:update", -1, property)

	return property.open
end
exports("ToggleLock", ToggleLock)

function Enter(source, id, shouldConfirm)
	if not Properties then return end
	
	local property = Properties[id]
	if not property then return end
	
	local settings = Config.Types[property.type]
	if not settings then return end

	if settings.Custom then return end

	local character = exports.character:GetCharacter(source)
	if not character then return end

	if shouldConfirm and not CanEnter(source, id) then
		TriggerClientEvent("properties:failed", source)
		return
	end

	local instanceId = "p"..tostring(id)

	if exports.oldinstances:DoesInstanceExist(instanceId) then
		exports.oldinstances:JoinInstance(instanceId, source)
	else
		exports.oldinstances:CreateInstance(instanceId, {
			inCoords = settings.Coords,
			outCoords = vector4(property.x, property.y, property.z, property.w),
		}, source)
	end

	--[[if settings.Storage and not Containers[id] then
		local data = {
			property_id = id,
			protected = true,
			type = "property",
		}
		local containerId = exports.inventory:LoadContainer(data).id
		Containers[id] = containerId
		exports.inventory:MoveContainer(containerId, settings.Storage, instanceId)
		exports.inventory:Set(containerId, "conditions", {
			property = id
		})
	end]]
end
exports("Enter", Enter)

function CanEnter(source, id)
	if HasProperty(source, id) then
		return true
	end

	local property = Properties[id]
	if not property then return false end

	return property.open == true
end
exports("CanEnter", CanEnter)

function GetRandomProperty()
	if Seed == 0 then
		Seed = math.floor(os.clock() * 1000)
	else
		math.randomseed(Seed)
		Seed = math.random(0, 2147483647)
	end
	math.randomseed(Seed)
	return Properties[PropertyIds[math.random(1, #PropertyIds)]]
end
exports("GetRandomProperty", GetRandomProperty)

function GetProperty(id)
	return Properties[id]
end
exports("GetProperty", GetProperty)

--[[ Events ]]--
RegisterNetEvent("properties:enter")
AddEventHandler("properties:enter", function(id)
	local source = source
	Enter(source, id, true)
end)

RegisterNetEvent("properties:request")
AddEventHandler("properties:request", function()
	local source = source
	if not Properties then return end
	TriggerClientEvent("properties:receive", source, Properties)
end)

RegisterNetEvent("properties:lock")
AddEventHandler("properties:lock", function(id, breaching)
	local source = source

	if Cooldowns[source] and os.clock() - Cooldowns[source] < 1.0 then return end
	Cooldowns[source] = os.clock()
	
	if (breaching and not exports.jobs:IsInEmergency(source, "CanBreach")) and not HasProperty(source, id) then return end
	
	local open = ToggleLock(id)

	exports.log:Add({
		source = source,
		verb = "toggle",
		noun = "lock",
		extra = tostring(open),
	})

	TriggerClientEvent("properties:locked", source, open)
end)

RegisterNetEvent("properties:breach")
AddEventHandler("properties:breach", function(id)
	local source = source

	if Cooldowns[source] and os.clock() - Cooldowns[source] < 1.0 then return end
	Cooldowns[source] = os.clock()
	
	if not exports.jobs:IsInEmergency(source, "CanBreach") then return end

	local property = Properties[id]
	if not property then return end

	local message = ("You must have probable cause to enter a property or have justification for entry under exigent circumstances. By typing /accept you are taking full responsibility for breaching this property"):format(property.id, property.type)
	exports.interaction:SendConfirm(source, source, message, function(response)
		if not response then return end

		local ped = GetPlayerPed(source)
		if not ped then return false end

		local pedCoords = GetEntityCoords(ped)
	
		if #(pedCoords - vector3(property.x, property.y, property.z)) > 5.0 then
			TriggerClientEvent("chat:addMessage", source, "You're too far from the door!")
			return
		end

		local keys = exports.character:Get(source, "keys")

		table.insert(keys, {
			character_id = exports.character:Get(source, "id"),
			property_id = id,
		})
	
		exports.character:Set(source, "keys", keys)

		local open = ToggleLock(id)

		exports.log:Add({
			source = source,
			verb = "breached",
			noun = "property",
			extra = "id: "..id,
		})

		TriggerClientEvent("chat:addMessage", source, "You breach the door!", "advert")
		TriggerClientEvent("properties:locked", source, open)
	end)
end)

RegisterNetEvent("properties:get")
AddEventHandler("properties:get", function(id)
	local source = source

	if type(id) ~= "number" then return end
	
	exports.log:Add({
		source = source,
		verb = "viewed",
		noun = "property",
		extra = id,
	})
end)

RegisterNetEvent("properties:buy")
AddEventHandler("properties:buy", function(id)
	local source = source
	local property = Properties[id]
	if not property then return end

	if property.character_id ~= nil then return end

	local settings = Config.Types[property.type]
	if not settings then return end

	if not settings.Rent and not property.lender then return end

	local character = exports.character:GetCharacter(source)
	if not character then return end
	
	if not CheckCount(source, character.properties, property.type) then return end

	local price = property.price or settings.Rent or settings.Value
	if not price then return end

	if not exports.inventory:CanAfford(source, price, settings.PaymentFlag, true) then
		TriggerClientEvent("chat:addMessage", source, "You cannot afford this property!")
		return
	end

	SetOwnership(source, id, price)
end)

RegisterNetEvent("properties:pay")
AddEventHandler("properties:pay", function(id)
	local source = source
	local property = Properties[id]
	if not property then return end
	
	local settings = Config.Types[property.type]
	if not settings then return end
	
	local character = exports.character:GetCharacter(source)
	if not character or not character.payments then return end

	if property.character_id ~= character.id then return end
	local payment = nil
	local paymentId = nil

	for k, _payment in ipairs(character.payments) do
		if _payment.property_id == id and _payment.expired ~= 1 then
			payment = _payment
			paymentId = k
			break
		end
	end

	if not payment or os.time() * 1000 <= payment.next_payment - 8.64e+7 * Config.GracePeriod then return end

	-- Check money and take.
	local amount = payment.mortgage
	local isMortgage = true
	if not amount or amount == 0 then
		amount = payment.due
		isMortgage = false
	end
	if not amount then error("no mortgage or due for property "..id) return end

	local bank = exports.character:Get(source, "bank")
	if bank < amount then
		TriggerClientEvent("notify:sendAlert", source, "error", "The bank declined the payment!", 10000)
		return
	end

	-- Log.
	exports.log:Add({
		source = source,
		verb = "made",
		noun = "payment",
		extra = ("id: %s - price: $%s"):format(property.id, amount),
	})
	
	-- Take money.
	exports.character:AddBank(source, -amount, true)
	exports.log:AddEarnings(source, "Mortgage", -amount)

	-- Mortgages.
	if isMortgage then
		payment.payed = payment.payed + payment.mortgage
	end

	-- Update database.
	if isMortgage and payment.payed >= payment.due then
		exports.GHMattiMySQL:QueryAsync([[
			DELETE FROM
				`payments`
			WHERE
				`character_id`=@characterId AND `property_id`=@propertyId AND `expired`=0
		]], {
			["@characterId"] = character.id,
			["@propertyId"] = property.id,
		})

		table.remove(character.payments, paymentId)
	else
		exports.GHMattiMySQL:QueryAsync([[
			UPDATE `payments` SET
				`last_payment`=SYSDATE(),
				`next_payment`=(`next_payment` + INTERVAL @days DAY),
				`payed`=@payed
			WHERE
				`character_id`=@characterId AND `property_id`=@propertyId AND `expired`=0
		]], {
			["@days"] = Config.PaymentDays,
			["@payed"] = payment.payed,
			["@characterId"] = character.id,
			["@propertyId"] = property.id,
		})

		-- Update cache.
		payment.last_payment = os.time() * 1000
		payment.next_payment = payment.next_payment + 8.64e+7 * Config.PaymentDays
	end
	
	exports.character:Set(source, "payments", character.payments)

	-- Load app.
	exports.phone:SendPayload(source, "properties", false, true)
end)

AddEventHandler("properties:start", function()
	local startTime = os.clock()

	-- Update types in the database.
	local query = ""
	local sortedTypes = {}

	for _type, settings in pairs(Config.Types) do
		sortedTypes[#sortedTypes + 1] = _type
	end
	table.sort(sortedTypes)
	
	for k, _type in ipairs(sortedTypes) do
		if k ~= 1 then
			query = query..", "
		end
		query = query..("'%s'"):format(_type)
	end

	query = ([[
		ALTER TABLE `properties`
		CHANGE COLUMN `type` `type` ENUM(%s) NOT NULL DEFAULT 'motel' COLLATE 'utf8_general_ci' AFTER `character_id`
	]]):format(query)

	exports.GHMattiMySQL:Query(query)

	-- Update/insert custom properties.
	for _type, settings in pairs(Config.Types) do
		if settings.Custom and settings.Coords then
			local id = exports.GHMattiMySQL:QueryScalar("SELECT `id` FROM `properties` WHERE `type`=@type LIMIT 1", {
				["@type"] = _type
			})

			if id then
				exports.GHMattiMySQL:Query("UPDATE `properties` SET x=@x, y=@y, z=@z, w=@w WHERE `id`=@id", {
					["@x"] = settings.Coords.x,
					["@y"] = settings.Coords.y,
					["@z"] = settings.Coords.z,
					["@w"] = settings.Coords.w,
					["@id"] = id,
				})
			else
				exports.GHMattiMySQL:Query("INSERT INTO `properties` SET `type`=@type, x=@x, y=@y, z=@z, w=@w", {
					["@x"] = settings.Coords.x,
					["@y"] = settings.Coords.y,
					["@z"] = settings.Coords.z,
					["@w"] = settings.Coords.w,
					["@type"] = _type,
				})
			end
		end
	end

	Citizen.Trace(("Updated properties table in %s ms\n"):format(math.ceil((os.clock() - startTime) * 1000)))
	startTime = os.clock()

	-- Load properties.
	local properties = exports.GHMattiMySQL:QueryResult("SELECT * FROM properties")

	Citizen.Trace(("Loaded %s properties in %s ms\n"):format(#properties, math.ceil((os.clock() - startTime) * 1000)))
	Properties = {}

	for k, property in ipairs(properties) do
		Properties[property.id] = property
		PropertyIds[#PropertyIds + 1] = property.id

		local settings = Config.Types[property.type]
		if not settings then
			print(("property %s is missing type: %s"):format(property.id, tostring(property.type)))
			goto skipProperty
		end
		if settings.Custom then
			-- Load storage if no interior.
			if settings.Storage and not Containers[id] then
				local data = {
					property_id = property.id,
					protected = true,
					type = "property",
				}
				local containerId = exports.inventory:LoadContainer(data)

				if containerId == nil then
					-- Register container.
					print("Create property container: ["..property.id.."]")
					container = exports.inventory:RegisterContainer(data)
				end
				--Containers[property.id] = containerId
				--exports.inventory:MoveContainer(containerId, settings.Storage)
				--exports.inventory:Set(containerId, "conditions", {
					--property = property.id
				--})
			end
		end
		if settings.Doors then
			--RegisterDoors(property, settings.Radius)
		end
		::skipProperty::
	end

	TriggerClientEvent("properties:receive", -1, Properties)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:propertyadd", function(source, args, rawCommand)
	local source = source
	local _type = args[1]

	if not Config.Types[_type] then
		TriggerClientEvent("chat:addMessage", "Invalid type!")
		return
	end

	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)

	local property = {
		type = _type,
		x = coords.x,
		y = coords.y,
		z = coords.z,
		w = heading,
	}

	TriggerClientEvent("chat:addMessage", source, "Adding...")

	exports.GHMattiMySQL:Insert("properties", {
		property
	}, function(id)
		property.id = id

		Properties[id] = property

		TriggerClientEvent("properties:add", -1, property)
		TriggerClientEvent("chat:addMessage", source, ("Added property: %s!"):format(id))
		
		exports.log:Add({
			source = source,
			verb = "added",
			noun = "property",
			extra = ("id: %s"):format(id),
		})
	end, true)
end, {
	help = "Add an apartment.",
	params = {
		{ name = "Type", help = "The type of apartment to add." },
	}
}, "Admin")

exports.chat:RegisterCommand("a:propertyremove", function(source, args, rawCommand)
	local source = source
	local id = tonumber(args[1])

	if not id or not Properties[id] then
		TriggerClientEvent("chat:addMessage", "Property doesn't exist!")
		return
	end
	
	exports.GHMattiMySQL:Query("DELETE FROM properties WHERE id=@id", {
		["@id"] = id,
	})
	
	Properties[id] = nil
	TriggerClientEvent("properties:remove", -1, id)
	TriggerClientEvent("chat:addMessage", source, ("Removed property: %s!"):format(id))

	exports.log:Add({
		source = source,
		verb = "removed",
		noun = "property",
		extra = ("id: %s"):format(id),
	})
end, {
	help = "Remove an apatment.",
	params = {
		{ name = "ID", help = "The ID of the apartment to remove." },
	}
}, "Admin")

exports.chat:RegisterCommand("a:garageadd", function(source, args, rawCommand)
	local source = source
	local property = tonumber(args[1])

	if not Properties[property] then
		TriggerClientEvent("chat:addMessage", "Property not found!")
		return
	end

	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)

	local garage = {
		property_id = property,
		x = coords.x,
		y = coords.y,
		z = coords.z,
		w = heading,
	}

	TriggerClientEvent("chat:addMessage", source, "Adding...")

	exports.garages:AddGarage(garage, function(id)
		TriggerClientEvent("chat:addMessage", source, ("Added garage: %s!"):format(id))
		exports.log:Add({
			source = source,
			verb = "added",
			noun = "garage",
			extra = ("id: %s"):format(id),
		})
	end)
end, {
	help = "Add a garage to existing property.",
	params = {
		{ name = "Property ID", help = "The property ID the garage will be attached to." },
	}
}, "Admin")

exports.chat:RegisterCommand("property:givekey", function(source, args, rawCommand)
	if Cooldowns[source] and os.clock() - Cooldowns[source] < 5.0 then return end
	Cooldowns[source] = os.clock()
	
	local propertyId, target = tonumber(args[1]), tonumber(args[2])
	local property = GetProperty(propertyId or -1)

	-- Self check.
	if target == source then
		TriggerClientEvent("chat:addMessage", source, "Can't give keys to yourself!")
		return
	end
	
	-- Check the property.
	if not property then
		TriggerClientEvent("chat:addMessage", source, "Invalid property!")
		return
	end
	
	local characterId = exports.character:Get(source, "id")
	if not characterId or characterId ~= property.character_id then
		TriggerClientEvent("chat:addMessage", source, "You do not own this property!")
		return
	end
	
	-- Check the target.
	local targetId = exports.character:Get(target, "id")
	if not targetId then
		TriggerClientEvent("chat:addMessage", source, "Invalid target!")
		return
	end

	local ped = GetPlayerPed(source)
	local targetPed = GetPlayerPed(target)

	if not ped or not targetPed or #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) > 10.0 then
		TriggerClientEvent("chat:addMessage", source, "They're not close enough!")
		return
	end
	
	-- Request to get the key.
	local message = ("You are receiving the key to property %s (%s)"):format(property.id, property.type)
	exports.interaction:SendConfirm(source, target, message, function(response)
		if not response then return end

		exports.log:Add({
			source = source,
			target = target,
			verb = "gave",
			noun = "keys",
			extra = ("id: %s"):format(propertyId),
		})
		
		local key = {
			property_id = propertyId,
			character_id = targetId,
		}

		local keys = exports.character:Get(target, "keys")

		for _, _key in ipairs(keys) do
			if _key.property_id == propertyId then
				TriggerClientEvent("chat:addMessage", target, "You already have this key!")
				return
			end
		end
		
		keys[#keys + 1] = key
		
		exports.character:Set(target, "keys", keys)
		exports.GHMattiMySQL:Insert("`keys`", { key })

		for k, v in ipairs({ source, target }) do
			TriggerClientEvent("chat:addMessage", v, "Gave key!")
		end
	end)
end, {
	help = "Give keys to somebody for your property.",
	params = {
		{ name = "Property", help = "ID of the property you're giving keys for." },
		{ name = "Target", help = "The person you're giving keys to." },
	}
}, 2, 0)

exports.chat:RegisterCommand("property:takekey", function(source, args, rawCommand)
	if Cooldowns[source] and os.clock() - Cooldowns[source] < 5.0 then return end
	Cooldowns[source] = os.clock()

	local propertyId, targetId = tonumber(args[1]), tonumber(args[2])
	local property = GetProperty(propertyId or -1)

	-- Check the property.
	if not property then
		TriggerClientEvent("chat:addMessage", source, "Invalid property!")
		return
	end
	
	local characterId = exports.character:Get(source, "id")
	if not characterId or characterId ~= property.character_id then
		TriggerClientEvent("chat:addMessage", source, "You do not own this property!")
		return
	end

	-- Check the target.
	if not targetId then
		TriggerClientEvent("chat:addMessage", source, "Invalid target!")
		return
	end

	exports.log:Add({
		source = source,
		verb = "took",
		noun = "keys",
		extra = ("property id: %s - character id: %s"):format(propertyId, targetId),
	})
	
	local result = exports.GHMattiMySQL:QueryScalar([[
		DELETE FROM `keys` WHERE property_id=@propertyId AND character_id=@targetId;
		SELECT ROW_COUNT();
	]], {
		["@propertyId"] = propertyId,
		["@targetId"] = targetId,
	})
	
	if result == 1 then
		TriggerClientEvent("chat:addMessage", source, "Removed key!")

		local target = exports.character:GetCharacterById(targetId)
		if target then
			local keys = exports.character:Get(target, "keys")

			for i, _key in ipairs(keys) do
				if _key.property_id == propertyId then
					table.remove(keys, i)
					break
				end
			end
			
			exports.character:Set(target, "keys", keys)
		end
	else
		TriggerClientEvent("chat:addMessage", source, "Could not find key!")
	end
end, {
	help = "Take keys from somebody for your property.",
	params = {
		{ name = "Property", help = "ID of the property you're taking keys from." },
		{ name = "Character", help = "Character ID of the person you're taking keys from. NOT server ID." },
	}
}, 2, 0)

exports.chat:RegisterCommand("property:keys", function(source, args, rawCommand)
	if Cooldowns[source] and os.clock() - Cooldowns[source] < 5.0 then return end
	Cooldowns[source] = os.clock()

	local message = "Properties:"
	local properties = exports.character:Get(source, "properties")
	if properties and #properties ~= 0 then
		for _, property in ipairs(properties) do
			local settings = Config.Types[property.type]
			if not settings then goto skip end

			local result = exports.GHMattiMySQL:QueryResult("SELECT `character_id` FROM `keys` WHERE `property_id`=@propertyId", {
				["@propertyId"] = property.id
			})
			
			message = message..("<br>%s (%s): "):format(settings.Name, property.id)
			
			if #result == 0 then
				message = message.."None"
			else
				for i, key in ipairs(result) do
					if i ~= 1 then
						message = message..", "
					end
					local character = exports.GHMattiMySQL:QueryResult("SELECT `first_name`, `last_name` FROM `characters` WHERE `id`=@id", {
						["@id"] = key.character_id
					})[1]
					if character then
						message = message..("%s %s (%s)"):format(character.first_name, character.last_name, key.character_id)
					end
				end
			end
			::skip::
		end
	else
		message = message.."<br>None"
	end

	message = message.."<br><br>Your Keys:"

	local keys = exports.character:Get(source, "keys")
	if keys and #keys ~= 0 then
		for _, key in ipairs(keys) do
			local property = GetProperty(key.property_id)
			if not property then goto skip end
			
			local settings = Config.Types[property.type]
			if not settings then goto skip end

			message = message..("<br>%s (%s)"):format(settings.Name, property.id)

			::skip::
		end
	else
		message = message.."<br>None"
	end
	
	TriggerClientEvent("notify:persistentAlert", source, "START", "property:key", "inform", message, false, true)
end, {
	help = "List the keys for all properties you own.",
}, 0, 0)

exports.chat:RegisterCommand("property:sell", function(source, args, rawCommand)
	local source = source
	local target, propertyId = tonumber(args[1]), tonumber(args[2])

	if not CheckRealtor(source, target, propertyId) then return end
	
	if source == target then
		TriggerClientEvent("chat:addMessage", source, "You cannot sell yourself a property!")
		return
	end
	
	property = Properties[propertyId]
	if not property or property.character_id then
		TriggerClientEvent("chat:addMessage", source, "This property is not available!")
		return
	end

	local settings = Config.Types[property.type]
	if not settings then return end

	local price = settings.Value
	if not price then
		TriggerClientEvent("chat:addMessage", source, "This property is not under your jurisdiction!")
		return
	end

	local discount, downPayment, term = (tonumber(args[3]) or 0.0), (tonumber(args[4]) or 0.0), math.min(math.max(tonumber(args[5]) or 0, 0), 12)
	if discount > 1.0 then
		discount = discount / 100.0
	end
	if downPayment > 1.0 then
		downPayment = downPayment / 100.0
	end
	discount = math.min(math.max(discount, 0.0), 0.1)
	price = math.ceil(price * (1.0 - discount))
	downPayment = math.ceil(price * math.min(math.max(downPayment, 0.1), 0.2))

	local principal = price - downPayment
	local mortgage

	local message
	if term == 0 then
		message = "They hand you a contract for property "..propertyId..". It states you shall make a single payment of $"..exports.misc:FormatNumber(price).." for ownership"
		downPayment = price
	else
		mortgage = math.ceil((principal + (principal * Config.InterestRate * term)) / term)
		message = "They hand you a contract for property "..propertyId..". It states you shall make a down payment of $"..exports.misc:FormatNumber(downPayment).." and will pay $"..exports.misc:FormatNumber(mortgage).." every 30 days for "..term.." months"
	end
	
	exports.interaction:SendConfirm(source, target, message, function(response)
		if not response then
			TriggerClientEvent("chat:addMessage", target, "They refused to sign.")
			return
		end
		local bank = exports.character:Get(target, "bank")
		if not bank or bank < downPayment then
			TriggerClientEvent("chat:addMessage", target, "Their bank has declined the payment.")
			return
		end
		local sourceId = exports.character:Get(source, "id")
		if not sourceId then return end

		local amount
		if term == 0 then
			amount = 0
		else
			amount = mortgage * term
		end

		if not CheckCount(source, exports.character:Get(target, "properties"), property.type) then return end

		if SetOwnership(target, propertyId, amount, sourceId, downPayment, mortgage) then
			local commission = math.min(downPayment, math.floor(price * Config.Commission))

			exports.log:Add({
				source = source,
				verb = "getting",
				noun = "comission",
				extra = ("$%s"):format(comission),
			})
			
			exports.character:AddBank(source, commission, true)
			exports.log:AddEarnings(source, "Property Commission", commission)
		end
	end, false)
end, {
	help = "Realtor command: sell properties to people",
	params = {
		{ name = "Target", help = "Who you're selling to" },
		{ name = "Property", help = "What property you're selling (using /property:get)" },
		{ name = "Discount", help = "How much to take off the property value, up to 10%" },
		{ name = "Down Payment", help = "Percentage of the down payment they will pay, from 10 to 20(%)" },
		{ name = "Term", help = "How many months the mortgage lasts, from 1 to 12 months (optional)" },
	}
}, -1, 0)

exports.chat:RegisterCommand("property:lookup", function(source, args, rawCommand)
	-- Check distance.
	local ped = GetPlayerPed(source) or 0
	local pedCoords = GetEntityCoords(ped)

	if #(pedCoords - Config.LookupCoords) > 5.0 then
		TriggerClientEvent("chat:addMessage", source, "You can't look that up here!", "advert")
		return
	end

	-- Cooldown.
	if os.clock() - (Cooldowns[source] or 0.0) < 10.0 then
		TriggerClientEvent("chat:addMessage", source, "Slow down!", "advert")
		return
	end

	Cooldowns[source] = os.clock()

	-- Check property.
	local id = tonumber(args[1]) or -1

	local property = Properties[id]
	if not property then
		TriggerClientEvent("chat:addMessage", source, "Property not found!", "advert")
		return
	end

	-- Log.
	exports.log:Add({
		source = source,
		verb = "looked up",
		noun = "property",
		extra = ("id: %s"):format(id),
	})

	-- Get type.
	local settings = Config.Types[property.type or ""]
	if not settings then return end

	local owner = nil

	if settings.Public and not settings.Secret and property.character_id then
		local result = exports.GHMattiMySQL:QueryResult("SELECT `first_name`, `last_name` FROM `characters` WHERE id=@id", {
			["@id"] = property.character_id
		})[1]
		if result then
			owner = ("%s %s"):format(result.first_name, result.last_name)
		end
	end

	TriggerClientEvent("property:lookup", source, id, owner)
end, {
	help = "Lookup a property.",
	params = {
		{ name = "Property", help = "What property you're looking up (using /property:get)" },
	}
}, 1, 0)

exports.chat:RegisterCommand("a:givekey", function(source, args, rawCommand, cb)
	local propertyId, target = tonumber(args[1]), tonumber(args[2])
	if not target then
		target = source
	end

	-- Check property.
	local property = GetProperty(propertyId)
	if not property then
		cb("error", "Property doesn't exist!")
		return
	elseif property.type == "bunker" then
		cb("error", "Too many tunnels to navigate...")
		return
	end

	-- Get keys.
	local keys = exports.character:Get(target, "keys")
	if not keys then
		cb("error", "Invalid target!")
		return
	end

	-- Log it.
	exports.log:Add({
		source = source,
		target = target,
		verb = "gave",
		noun = "keys to",
		extra = ("property: %s"):format(propertyId),
		channel = "admin",
	})

	-- Set keys.
	table.insert(keys, {
		character_id = exports.character:Get(target, "id"),
		property_id = propertyId,
	})

	exports.character:Set(target, "keys", keys)

	TriggerEvent("chat:addMessage", source, ("Gave keys to [%s] for property %s!"):format(target, propertyId))
end, {
	help = "Give keys to somebody.",
	params = {
		{ name = "Property", help = "The property to give keys for." },
		{ name = "Target", help = "The player to give keys to." },
	}
}, "Admin")

-- exports.chat:RegisterCommand("property:release", function(source, args, rawCommand)
-- 	local source = source
-- 	local target, propertyId = tonumber(args[1]), tonumber(args[2])

-- 	if not CheckRealtor(source, target, propertyId) then return end

-- 	property = Properties[propertyId]
-- 	if not property or property.character_id then
-- 		TriggerClientEvent("chat:addMessage", source, "This property is not owned!")
-- 		return
-- 	end

-- 	local targetCharacter = exports.character:Get(target, "id")
-- 	if not targetCharacter or targetCharacter ~= property.character_id then

-- 	end

-- 	-- local settings = Config.Types[property.type].
-- 	-- if not settings then return end.
	
-- end, {
-- 	help = "Realtor command: release somebody from their contract",
-- 	params = {
-- 		{ name = "Target", help = "Who you're releasing" },
-- 		{ name = "Property", help = "What property you're selling (using /property:get)" },
-- 	}
-- }, 1, 0)
