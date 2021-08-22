RegisterNetEvent(Admin.event.."lookupUser", function(data)
	local source = source

	if not data or not exports.user:IsMod(source) then return end

	-- Get query and values.
	local query, values
	local userId = tonumber(data)

	if userId then
		query = "`id`=@userId"
		values = {
			["@userId"] = userId,
		}
	else
		local key, value = data:match("([^:]+):([^:]+)")
		query = ("`%s`=@value"):format(key)
		values = {
			["@value"] = value
		}
	end

	-- Check query.
	if not query then
		TriggerClientEvent("chat:notify", source, {
			class = "error",
			text = "Invalid input!",
		})

		return
	end

	-- Get user.
	local user = exports.GHMattiMySQL:QueryResult("SELECT * FROM `users` WHERE "..query, values)[1]
	if not user then
		TriggerClientEvent("chat:notify", source, {
			class = "error",
			text = "User not found!",
		})

		return
	end

	user.endpoint = nil
	user.tokens = nil
	user.first_joined = DateFromTime(user.first_joined)
	user.last_played = DateFromTime(user.last_played)

	-- Get characters.
	local characters = {}
	local characters = exports.GHMattiMySQL:QueryResult("SELECT * FROM `characters` WHERE `user_id`="..user.id)
	
	for k, character in ipairs(characters) do
		local dob, age = DateFromTime(character.dob)
		character.dob = dob
		character.age = age
	end

	-- Get warnings.
	-- local warnings = exports.GHMattiMySQL:QueryResult("SELECT * FROM `warnings` WHERE `user_id`=@userId".., {
	-- 	["@userId"] = user.id
	-- })

	local warnings = {}

	-- Send user.
	TriggerClientEvent(Admin.event.."receiveUser", source, user, characters, warnings)
end)