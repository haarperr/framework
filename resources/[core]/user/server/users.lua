function User:Create(data)
	local queryString = "tokens=@tokens"
	local queryValues = {
		["@tokens"] = json.encode(data.tokens or {})
	}

	-- Get identifiers.
	for _, key in ipairs(Server.Identifiers) do
		local value = data.identifiers[key]
		if value ~= nil then
			queryString = queryString..", "..key.."=@"..key
			queryValues["@"..key] = value
		end
	end
	
	-- Update database.
	exports.GHMattiMySQL:Query("INSERT INTO `users` SET "..queryString.." ON DUPLICATE KEY UPDATE "..queryString, queryValues)

	-- Update fields.
	local user = exports.GHMattiMySQL:QueryResult([[
		UPDATE `users` SET last_played=NOW(), first_joined=COALESCE(first_joined, NOW()) WHERE steam=@steam;
		SELECT * FROM `users` WHERE steam=@steam LIMIT 1;
	]], { ["@steam"] = data.identifiers.steam })[1]
	if user == nil then return end

	for _, field in pairs(Server.Fields) do
		data[field] = user[field]
	end

	-- Return object.
	return setmetatable(data, User)
end

function User:Set(key, value)
	local column = Main.columns[key]
	if column then
		if type(value) ~= column.type then
			return false
		end

		exports.GHMattiMySQL:QueryAsync("UPDATE `users` SET "..key.."=@"..key.." WHERE `id`=@id", {
			["@id"] = self.id,
			["@"..key] = value,
		})
	end
	
	self[key] = value

	TriggerClientEvent(Main.event.."set", self.source, key, value)

	return true
end