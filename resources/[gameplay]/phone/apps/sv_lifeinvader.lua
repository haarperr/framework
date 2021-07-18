local ads = {}

function UncacheUser(source)
	local _source = tostring(source)
	local ad = ads[_source]
	if ad then
		SendPayload(-1, "lifeinvader", { remove = ad.number })
		ads[_source] = nil
	end
end

function CacheUser(source, message)
	message = FormatMessage(message, "ad")

	if message:len() <= 1 then return end

	local _source = tostring(source)
	local ad = ads[_source]
	if ad then
		ad.message = message
	else
		local character = exports.character:GetCharacter(source)
		if not character then return end

		ad = {
			name = character.first_name.." "..character.last_name,
			number = character.phone_number,
			message = message,
		}

		ads[_source] = ad
	end

	SendPayload(-1, "lifeinvader", { message = ad })
end

RegisterNetEvent("phone:loadAds")
AddEventHandler("phone:loadAds", function()
	local source = source
	TriggerClientEvent("phone:loadAds", source, ads)
end)

RegisterNetEvent("phone:updateAd")
AddEventHandler("phone:updateAd", function(message)
	local source = source
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	if type(message) == "string" then
		CacheUser(source, message)

		exports.GHMattiMySQL:Query([[
			IF EXISTS (SELECT 1 FROM `phone_messages` WHERE `type`='ad' AND `character_id`=@characterId) THEN
				UPDATE `phone_messages` SET `message`=@message WHERE `type`='ad' AND `character_id`=@characterId;
			ELSE
				INSERT INTO `phone_messages` SET `message`=@message, `type`='ad', `character_id`=@characterId;
			END IF;
		]], {
			["@characterId"] = characterId,
			["@message"] = message,
		})
	else
		UncacheUser(source)

		exports.GHMattiMySQL:Query([[
			DELETE FROM `phone_messages` WHERE `type`='ad' AND `character_id`=@characterId
		]], {
			["@characterId"] = characterId,
		})
	end
end)

RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	local source = source
	
	UncacheUser(source)
end)

AddEventHandler("character:loaded", function(source, character)
	local message = exports.GHMattiMySQL:QueryResult("SELECT * FROM phone_messages WHERE `type`='ad' AND `character_id`=@id", {
		["@id"] = character.id,
	})[1]

	if message then
		CacheUser(source, message.message)
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	UncacheUser(source)
end)