--[[ Events ]]--
RegisterNetEvent("phone:saveContact")
AddEventHandler("phone:saveContact", function(name, number)
	local source = source
	if not source then return end

	if type(name) ~= "string" then return end
	if type(number) ~= "string" or number:len() ~= 10 then return end
	
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	local contacts = exports.character:Get(source, "phone_contacts")
	if not contacts then return end
	
	local exists = contacts[number] ~= nil
	local values = {
		["@character_id"] = characterId,
		["@name"] = name,
		["@phone_number"] = number,
	}
	
	if exists then
		exports.log:Add({
			source = source,
			verb = "updated",
			noun = "contact",
			extra = ("number: %s"):format(number),
			channel = "misc",
		})
		
		exports.GHMattiMySQL:QueryAsync("UPDATE `phone_contacts` SET `name`=@name WHERE `character_id`=@character_id AND `target_character_id`=get_id_from_phone_number(@phone_number)", values)
	else
		values.targetCharacterId = exports.GHMattiMySQL:QueryScalar("SELECT get_id_from_phone_number(@phone_number)", values)

		if not values.targetCharacterId then return end
		
		exports.log:Add({
			source = source,
			verb = "added",
			noun = "contact",
			extra = ("number: %s"):format(number),
			channel = "misc",
		})
		
		exports.GHMattiMySQL:QueryAsync("INSERT INTO `phone_contacts` SET character_id=@character_id, target_character_id=@targetCharacterId, name=@name", values)
	end

	contacts[number] = name
	
	exports.character:Set(source, "phone_contacts", contacts)
end)

RegisterNetEvent("phone:deleteContact")
AddEventHandler("phone:deleteContact", function(number)
	local source = source
	if not source then return end
	
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end
	
	if type(number) ~= "string" or number:len() ~= 10 then return end

	local contacts = exports.character:Get(source, "phone_contacts")
	if not contacts or not contacts[number] then return end
	
	exports.log:Add({
		source = source,
		verb = "removed",
		noun = "contact",
		extra = ("number: %s"):format(number),
		channel = "misc",
	})
	
	exports.GHMattiMySQL:QueryAsync("DELETE FROM `phone_contacts` WHERE `character_id`=@character_id AND `target_character_id`=get_id_from_phone_number(@phone_number)", {
		["@character_id"] = characterId,
		["@phone_number"] = number,
	})

	contacts[number] = nil

	exports.character:Set(source, "phone_contacts", contacts)
end)

AddEventHandler("character:loaded", function(source, character)
	-- Select the user-set name and phone number of each contact.
	local result = exports.GHMattiMySQL:QueryResult("SELECT `name`, (SELECT `phone_number` FROM characters WHERE `id`=`target_character_id`) AS 'phone_number' FROM phone_contacts WHERE `character_id`=@character_id", {
		["@character_id"] = character.id
	})

	local contacts = {}
	for k, v in ipairs(result) do
		contacts[v.phone_number] = v.name
	end

	-- Set as a character field, this will sync automatically.
	exports.character:Set(source, "phone_contacts", contacts)
end)