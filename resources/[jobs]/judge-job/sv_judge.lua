--[[ Functions ]]--
function CheckFaction(source)
	local factions = { "judge" }
	local hasFaction = false

	for _, faction in ipairs(factions) do
		if exports.character:HasFaction(source, faction) then
			hasFaction = true
			break
		end
	end
	
	if not hasFaction then
		TriggerClientEvent("chat:addMessage", source, "Missing faction!")
	end
	
	return hasFaction
end

exports.chat:RegisterCommand("judge:seize", function(source, args, rawCommand)
	if not CheckFaction(source) then return end
	
	local plate = args[1]
	if not plate or plate:len() > 16 then
		TriggerClientEvent("chat:addMessagge", source, "Invalid plate!")
		return
	end

	local vehicle = exports.GHMattiMySQL:QueryResult("SELECT * FROM vehicles WHERE deleted=0 AND plate=@plate", {
		["@plate"] = plate,
	})[1]
	
	if not vehicle then
		TriggerClientEvent("chat:addMessage", source, "Vehicle not found!")
		return
	end

	exports.interaction:SendConfirm(source, source, "You are about to seize a vehicle ("..vehicle.id..")", function(wasAccepted)
		if not wasAccepted then return end
		
		if exports.garages:DeleteVehicle(vehicle.id) then
			exports.log:Add({
				source = source,
				verb = "seized",
				noun = "vehicle",
				extra = ("vehicle id: %s"):format(vehicle.id),
				channel = "judge",
			})
		end
	end)
end, {
	help = "Seize a vehicle",
	params = {
		{ name = "License", help = "The vehicle's license." },
	}
}, 1)

--[[  exports.chat:RegisterCommand("judge:seizeproperty", function(source, args, rawCommand)
	if not CheckFaction(source) then return end
	
	local propertyId = tonumber(args[1]) or false
	local property = exports.properties:GetProperty(propertyId)

	
	if not property then 
		TriggerClientEvent("chat:addMessage", source, "Invalid property!")
		return 
	end

	exports.interaction:SendConfirm(source, source, "You are about to seize a property ("..propertyId..")", function(wasAccepted)
		if not wasAccepted then return end

		local result = exports.GHMattiMySQL:Query("UPDATE `properties` SET character_id = NULL WHERE id=@propertyId", { 
			["@propertyId"] = propertyId,
		})
		
		local keys = exports.GHMattiMySQL:Query("DELETE FROM `keys` WHERE property_id=@propertyId", {
			["@propertyId"] = propertyId,
		})

		TriggerClientEvent("chat:addMessage", source, ("Property '%s' seized!"):format(propertyId))

		exports.properties:Uncache(propertyId)

		TriggerClientEvent("properties:update", propertyId)

		exports.log:Add({
			source = source,
			verb = "seized",
			noun = "property",
			extra = ("property id: %s"):format(propertyId),
			channel = "judge",
		})
	end)
end, {
	help = "Seize a property.",
	params = {
		{ name = "Property ID", help = "The properties id." },
	}
}, 1)  
--]]

exports.chat:RegisterCommand("judge:subpoena", function(source, args, rawCommand)
	if not CheckFaction(source) then return end
	
	local licenseText = args[1]
	if not licenseText or not tonumber(licenseText) or licenseText:len() ~= 9 then
		TriggerClientEvent("chat:addMessage", source, "Invalid ID!")
		return
	end
	
	local character = exports.GHMattiMySQL:QueryResult("SELECT * FROM characters WHERE license_text=@licenseText", {
		["@licenseText"] = licenseText,
	})[1]
	
	if not character then
		TriggerClientEvent("chat:addMessage", source, "Person not found!")
		return
	end
	
	-- Log the event.
	exports.log:Add({
		source = source,
		verb = "subpoenaed",
		extra = ("character id: %s"):format(character.id),
		channel = "judge",
	})
	
	-- Get the properties.
	local text = "<b>Properties</b><br>"
	
	local properties = exports.GHMattiMySQL:QueryResult("SELECT id, `type` FROM properties WHERE character_id=@characterId", {
		["@characterId"] = character.id
	})
	
	local hasProperty = false
	for k, property in ipairs(properties) do
		local settings = exports.properties:GetSettings(property.type)
		if settings and settings.Public then
			text = text..("%s (%s)<br>"):format(property.id, property.type)
			hasProperty = true
		end
	end
	
	if not hasProperty then
		text = text.."<i>None</i><br>"
	end
	
	-- Vehicles.
	text = text.."<br><b>Vehicles</b><br>"
	local vehicles = exports.GHMattiMySQL:QueryResult("SELECT plate, model, id FROM vehicles WHERE character_id=@characterId AND deleted=0", {
		["@characterId"] = character.id
	})
	
	local hasVehicle = false
	for k, vehicle in ipairs(vehicles) do
		local name = exports.vehicles:GetName(GetHashKey(vehicle.model))
		text = text..("%s (%s) (%s)<br>"):format(vehicle.plate, vehicle.model, vehicle.id)
		hasVehicle = true
	end
	
	if not hasVehicle then
		text = text.."<i>None</i><br>"
	end
	
	-- Send the information.
	TriggerClientEvent("notify:persistentAlert", source, "START", "subpoena", "inform", text, false, true)
end, {
	help = "Subpoena somebody.",
	params = {
		{ name = "License ID", help = "The license ID of the person to subpoena." },
	}
}, 1, group)

exports.chat:RegisterCommand("judge:movevehicle", function(source, args, rawCommand)
	if not CheckFaction(source) then return end
	
	local plate = args[1]
	if not plate or plate:len() > 16 then
		TriggerClientEvent("chat:addMessagge", source, "Invalid plate!")
		return
	end

	local vehicle = exports.GHMattiMySQL:QueryResult("SELECT * FROM vehicles WHERE deleted=0 AND plate=@plate", {
		["@plate"] = plate,
	})[1]
	
	if not vehicle then
		TriggerClientEvent("chat:addMessage", source, "Vehicle not found!")
		return
	end

	exports.interaction:SendConfirm(source, source, "You are about to move a vehicle ("..vehicle.id..", "..plate..") to another garage", function(wasAccepted)
		if not wasAccepted then return end
		
		exports.GHMattiMySQL:Query("UPDATE `vehicles` SET garage_id=4 WHERE id=@id", { ["@id"] = vehicle.id, })
		
		exports.log:Add({
			source = source,
			verb = "moved",
			noun = "vehicle",
			extra = ("vehicle id: %s"):format(vehicle.id),
			channel = "judge",
		})
	end)
end, {
	help = "Move a vehicle garage.",
	params = {
		{ name = "Plate", help = "The vehicle's plate." },
	}
}, 1)
