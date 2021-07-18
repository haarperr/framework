--[[ Functions ]]--
MessageHooks["tweet"] = {
	Convert = function(messages)
		for _, v in ipairs(messages) do
			local characterId = v.character_id
			local character = exports.character:GetCharacterById(characterId)
			if character and exports.character:Get(character, "id") == characterId then
				character = { first_name = exports.character:Get(character, "first_name"), last_name = exports.character:Get(character, "last_name") }
			else
				character = exports.GHMattiMySQL:QueryResult("SELECT first_name, last_name FROM `characters` WHERE `id`=@id", {
					["@id"] = characterId
				})[1]
			end
			if not character then return end
			v.name = tostring(character.first_name)..tostring(character.last_name)
			v.character_id = nil
		end
		
		return messages
	end,
	Payload = {
		App = "bleeter",
		Convert = function(source, _type, text)
			local characterId = exports.character:Get(source, "id")
			if not characterId then return end
			
			local firstName, lastName = exports.character:Get(source, "first_name"), exports.character:Get(source, "last_name")
			if not firstName or not lastName then return end

			local filteredMessage = FilterMessage(text)
			if filteredMessage then
				exports.log:Add({
					source = source,
					extra = ("caught by filter: %s"):format(BadWords[filteredMessage]),
					channel = "alert",
				})
				return
			end

			local name = firstName..lastName
			
			return {
				message = {
					name = name,
					message = text,
					timestamp = os.time() * 1000,
				},
				notification = {
					title = name,
					text = text,
					app = "bleeter",
				},
			}
		end,
	},
	Limit = "25",
	Query = "message, `date`, `character_id`",
}

--[[ Events ]]--
