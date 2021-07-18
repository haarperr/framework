function AddBusiness(source, name, notify)
	local characterId = exports.character:Get(source, "id")
	if not characterId then
		return false, "Invalid target!"
	end

	if not name then
		return false, "Name required!"
	end

	local exists = exports.GHMattiMySQL:QueryScalar("SELECT 1 FROM businesses WHERE `name`=@name", {
		["@name"] = name
	})

	if exists then
		return false, "Name taken!"
	end
	
	local business = {
		character_id = characterId,
		name = name,
		bank = 0,
	}

	exports.GHMattiMySQL:Insert("businesses", { business }, function(id)
		local businesses = exports.character:Get(source, "businesses")
		if not businesses then
			businesses = {}
		end

		business.id = id

		businesses[#businesses + 1] = business
		exports.character:Set(source, "businesses", businesses)

		if notify then
			TriggerClientEvent("chat:addMessage", notify, ("Created business '%s' with ID: %s"):format(name, id))
		end
	end, true)

	return true
end
exports("AddBusiness", AddBusiness)

function RemoveBusiness(id)
	local exists = exports.GHMattiMySQL:QueryScalar("SELECT 1 FROM businesses WHERE `id`=@id", {
		["@id"] = id
	})

	if not exists then
		return false, "Business doesn't exist!"
	end

	exports.GHMattiMySQL:Query("DELETE FROM businesses WHERE `id`=@id", {
		["@id"] = id
	})

	return true, "Business removed!"
end
exports("RemoveBusiness", RemoveBusiness)

function HasAccess(source)
	return source == 0 or exports.character:HasFaction(source, "judge")
end

--[[ Commands ]]--
exports.chat:RegisterCommand("business:add", function(source, args, rawCommand)
	if not HasAccess(source) then return end

	local target = tonumber(args[1])

	table.remove(args, 1)
	local name = table.concat(args, " ")
	
	local added, message = AddBusiness(target, name, source)
	if message then
		TriggerClientEvent("chat:addMessage", source, message)
	end
	if added then
		exports.log:Add({
			source = source,
			target = target,
			verb = "added",
			noun = "business",
			extra = name,
		})
		TriggerClientEvent("chat:addMessage", target, "Congratulations, you own a business!")
	end
end, {
	help = "Establish a business",
	params = {
		{ name = "Target", help = "Owner of the business" },
		{ name = "Name", help = "Name to give the business" },
	}
}, -1, group)

exports.chat:RegisterCommand("business:remove", function(source, args, rawCommand)
	if not HasAccess(source) then return end

	local id = tonumber(args[1])

	local removed, message = RemoveBusiness(id)
	if message then
		TriggerClientEvent("chat:addMessage", source, message)
	end
	if removed then
		exports.log:Add({
			source = source,
			verb = "removed",
			noun = "business",
			extra = id,
		})
	end
end, {
	help = "Remove a business",
	params = {
		{ name = "ID", help = "ID of the business to remove" },
	}
}, 1, group)

exports.chat:RegisterCommand("business:check", function(source, args, rawCommand)
	if not HasAccess(source) then return end

	local id = tonumber(args[1])

	local result = exports.GHMattiMySQL:QueryResult([[
		SELECT * FROM businesses WHERE id=@id
	]], {
		["@id"] = id,
	})[1]

	local message
	if result then
		message = ("Business ID: %s; Name: %s; Owner: %s"):format(id, result.name, result.character_id)
	else
		message = "Business not found!"
	end
	TriggerClientEvent("chat:addMessage", source, message)
end, {
	help = "Remove a business",
	params = {
		{ name = "ID", help = "ID of the business to remove" },
	}
}, 1, group)