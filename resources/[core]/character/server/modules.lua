Modules = {
	Load = {},
	SkipReferences = {
		["outfits"] = true,
		["containers"] = true,
		["decorations"] = true,
		["jail"] = true,
		["mdt_paramedic_profiles"] = true,
		["mdt_paramedic_reports"] = true,
		["mdt_police_profiles"] = true,
		["mdt_police_reports"] = true,
		["vehicles"] = true,
		["phone_contacts"] = true,
		["phone_messages"] = true,
		["phone_conversations"] = true,
		["weapons"] = true,
	},
}

function Modules:LoadDatabase()
	local references = GetTableReferences("characters", "id")
	self.references = {}
	
	for k, reference in pairs(references) do
		if not self.SkipReferences[reference.table] then
			self.references[reference.table] = reference
		end
	end
end

function Modules:LoadModules(source, character)
	local loadedModules = 0
	for reference, data in pairs(self.references) do
		exports.ghmattimysql:QueryResultAsync("SELECT * FROM `"..data.table.."` WHERE character_id=@character_id", {
			["@character_id"] = character.id,
		}, function(result)
			result = ConvertTableResult(result)
			loadedModules = loadedModules + 1
			if self.Load[data.table] then
				local output = self.Load[data.table](result)
				if output ~= nil then
					result = output
				end
			end
			character:Set(data.table, result)
		end)
	end

	while loadedModules < #self.references do Wait(20) end
end

function AddModule(character, table, data, callback)
	if type(character) == "number" then
		character = Main:GetCharacter(character)
	end

	if not character or not character.id then return end
	if not table then return end
	if not data then return end

	if not data.character_id then
		data.character_id = character.id
	end

	local insertData = {}

	for k, v in pairs(data) do
		if type(v) == "table" then
			insertData[k] = json.encode(v)
		else
			insertData[k] = v
		end
	end

	exports.ghmattimysql:Insert(table, {
		insertData
	}, function()
		if callback then
			pcall(callback)
		end
	end)
end
exports("AddModule", AddModule)

function RemoveModule(character, table, conditions, callback)
	if type(character) == "number" then
		character = Main:GetCharacter(character)
	end

	if not character or not character.id then return end
	if not table then return end
	if not conditions then return end

	local conditionQuery = "WHERE character_id=@character_id"
	local data = {
		["@character_id"] = character.id
	}

	for k, v in pairs(conditions) do
		conditionQuery = ("%s AND %s=@%s"):format(conditionQuery, k, k)
		data["@"..k] = v
	end

	exports.ghmattimysql:QueryAsync("DELETE FROM `"..table.."` "..conditionQuery, data, function()
		if callback then
			pcall(callback)
		end
	end)
end
exports("RemoveModule", RemoveModule)

function UpdateModule(character, table, values, conditions, callback)
	if type(character) == "number" then
		character = Main:GetCharacter(character)
	end

	if not character or not character.id then return end
	if not table then return end
	if not conditions then return end

	local conditionQuery = "WHERE character_id=@character_id"
	local data = {
		["@character_id"] = character.id
	}

	for k, v in pairs(conditions) do
		conditionQuery = ("%s AND %s=@%s"):format(conditionQuery, k, k)
		data["@"..k] = v
	end

	local setQuery = "SET"
	for k, v in pairs(values) do
		if setQuery ~= "SET" then
			setQuery = setQuery.." AND "
		end
		setQuery = ("%s %s=@%s"):format(setQuery, k, k)
		data["@"..k] = v
	end

	exports.ghmattimysql:QueryAsync(("UPDATE `%s` %s %s"):format(table, setQuery, conditionQuery), data, function()
		if callback then
			pcall(callback)
		end
	end)
end
exports("UpdateModule", UpdateModule)