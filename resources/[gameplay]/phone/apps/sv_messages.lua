Cache = {}
Times = {}

--[[ Functions ]]--
function AddMessage(sourceId, targetId, _type, text)
	-- print(sourceId, GetNumber(sourceId), targetId, GetNumber(targetId))

	if targetId == -1 then
		targetId = nil
	end
	
	local message = {
		character_id = sourceId,
		target_character_id = targetId,
		message = text,
		type = _type
	}
	
	exports.GHMattiMySQL:Insert("phone_messages", { message })

	local source = exports.character:GetCharacterById(sourceId)
	local sourceNumber = GetNumber(sourceId)
	
	local target
	local targetNumber

	if targetId then
		target = exports.character:GetCharacterById(targetId)
		targetNumber = GetNumber(targetId)
	end

	local hook = MessageHooks[_type]

	if hook and hook.Payload then
		local payload = hook.Payload.Convert(source, _type, text)
		if payload then
			SendPayload(-1, hook.Payload.App, payload)
		end
		return
	end
	
	if source then
		SendPayload(source, "messages-dm", {
			message = {
				target = targetNumber,
				text = text,
				timestamp = os.time() * 1000,
				isSelf = true,
			}
		})
	end

	if target then
		SendPayload(target, "messages-dm", {
			message = {
				target = sourceNumber,
				text = text,
				timestamp = os.time() * 1000,
			},
			notification = {
				title = sourceNumber,
				text = text,
				app = "messages",
			},
		})
	end
end

function FormatMessage(message, _type)
	message = message:gsub("<.*>", "")

	if _type ~= "tweet" then
		message = message:gsub("\n", "<br>")
	end

	message = message:gsub("%s+", " ")

	return message
end

function FilterMessage(message)
	message = message:lower():gsub("%s+", "")
	for k, v in ipairs(BadWords) do
		if message:find(v) then
			return k
		end
	end
	return false
end

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)
-- 	AddMessage(31, 1, "text", "imgay")
-- end)

--[[ Events ]]--
RegisterNetEvent("phone:sendMessage")
AddEventHandler("phone:sendMessage", function(target, _type, message)
	local source = source
	local lastMessage = Times[source]
	if lastMessage and lastMessage > os.clock() then return end

	if not Config.ValidTypes[_type] then return end
	
	local targetId
	if _type == "text" then
		targetId = GetId(target)
		if not targetId then return end
	else
		targetId = -1
	end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return end
	
	if type(message) ~= "string" or message:len() >= 255 then return end

	-- Format the message.
	message = FormatMessage(message, "tweet")

	if message:len() <= 1 then return end
	
	-- Cooldown.
	Times[source] = os.clock() + 1.0
	
	-- Log.
	if targetId == -1 then
		exports.log:Add({
			source = source,
			verb = "sent",
			noun = _type,
			extra = message,
			channel = "general",
		})
	else
		exports.log:Add({
			source = source,
			verb = "sent",
			noun = _type,
			extra = ("source cid: %s target cid: %s - %s"):format(characterId, targetId, message),
			is_sensitive = false,
			switch = false,
			channel = "general",
		})
	end

	-- Add message.
	AddMessage(characterId, targetId, _type, message)
end)

RegisterNetEvent("phone:requestMessages")
AddEventHandler("phone:requestMessages", function(app, target, _type, offset)
	local source = source
	if not source then return end

	local nextTime = Times[source]
	if nextTime and nextTime > os.clock() then
		local duration = nextTime - os.clock()

		Citizen.Wait(math.floor(duration * 1000))

		if math.floor(Times[source] * 1000) ~= math.floor(nextTime * 1000) then return end
	end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	Times[source] = os.clock() + 1.0

	local messages = {}
	local hook = MessageHooks[_type]
	
	-- local cache = Cache[source]
	
	-- if cache and cache[_type] and cache[target] then
	-- 	Cache[source] = 
	if hook and hook.Override then
		messages = hook.Override()
	elseif _type ~= "text" then
		messages = exports.GHMattiMySQL:QueryResult("SELECT "..(hook.Query or "*").." FROM `phone_messages` WHERE `type`=@type ORDER BY `date` DESC LIMIT "..(hook.Limit or "100"), {
			["@type"] = _type,
		})
	elseif target == -1 then
		local result = exports.GHMattiMySQL:QueryResult([[
			WITH call_list AS (
				SELECT *,
					@character_id AS `primary_character_id`,
					IF(@character_id=`character_id`, `target_character_id`, `character_id`) AS `secondary_character_id`
				FROM
					`phone_messages`
				WHERE
					(`character_id`= @character_id OR `target_character_id`= @character_id) AND `type`= @_type
			),
			sorted_call_list AS (
				SELECT *,
					ROW_NUMBER() OVER (
						PARTITION BY `primary_character_id`, `secondary_character_id`
						ORDER BY `date` DESC
					) AS char_rn
				FROM call_list
			)
			SELECT
				#`primary_character_id` AS 'character_id',
				#`secondary_character_id` AS 'target_character_id',
				get_phone_number_from_id(`secondary_character_id`) AS 'phone_number',
				`message`,
				`type`,
				`date`
			FROM
				sorted_call_list
			WHERE
				char_rn=1
			ORDER BY `date` DESC;
		]], {
			["@character_id"] = characterId,
			["@_type"] = _type,
		})

		for k, v in ipairs(result) do
			messages[#messages + 1] = { v.phone_number, v.message, v.date }
		end
	else
		if type(target) ~= "string" or target:len() ~= 10 then return end

		local targetCharacterId = exports.GHMattiMySQL:QueryScalar("SELECT get_id_from_phone_number(@phone_number)", {
			["@phone_number"] = target,
		})

		if not targetCharacterId then return end

		local result = exports.GHMattiMySQL:QueryResult([[
			(SELECT
				`character_id`,
				`message`,
				`date`,
				get_phone_number_from_id(@target_character_id) AS `phone_number`
			FROM
				`phone_messages`
			WHERE
				(((`target_character_id`=@character_id AND
				`character_id`=@target_character_id) OR
				(`target_character_id`=@target_character_id AND
				`character_id`=@character_id)) AND
				`type`=@type)
			ORDER BY `date` DESC LIMIT 50);
		]], {
			["@character_id"] = characterId,
			["@target_character_id"] = targetCharacterId,
			["@type"] = _type,
		})

		for k, v in ipairs(result) do
			-- print(k, v.phone_number, v.message, v.date, v.character_id == characterId)
			messages[k] = { v.phone_number, v.message, v.date, v.character_id == characterId }
		end
	end

	if hook and hook.Convert then
		messages = hook.Convert(messages)
	end
	
	TriggerClientEvent("phone:receiveMessages", source, app, target, _type, messages)
end)