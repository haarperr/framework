function Character:Create(source, data)
	if not data.id then return end

	if not source then
		error(("Character (id %s) missing source user!"):format(data.id))
	end

	data = setmetatable(data, self)
	data.source = source

	for _, column in ipairs(Main.tableColumns) do
		local value = data[column]
		if value and type(value) == "string" then
			data[column] = json.decode(value)
		end
	end

	if type(data.dob) == "number" then
		local dob = data.dob / 1000.0
		local offset = 0

		if dob < 0 then
			dob = dob + 4070912400
			offset = 129
		end
		
		local date = os.date("*t", dob)
		if date then
			data.dob = ("%d/%02d/%02d"):format(date.year - offset, date.month, date.day)
			data.age = math.ceil(os.date("%Y", os.time()) - date.year + offset)
		end
	end

	Main.ids[data.id] = data
	
	return data
end

function Character:Set(...)
	local args = {...}
	if type(args[1]) == "table" then
		args = args[1]
	else
		args = { [args[1]] = args[2] }
	end

	local setters, values = "", {
		["@id"] = self.id,
	}

	for key, value in pairs(args) do
		local _value = value

		-- Check column is not id.
		if key == "id" then
			error("Cannot set column 'id'")
		end

		-- Get column from table.
		local column = Main.columns[key]
		if column then
			-- Convert tables.
			if type(_value) == "table" then
				_value = json.encode(_value)
			end
		
			-- Check nullables.
			if _value == nil and not column.nullable then
				error(("Column '%s' is not nullable"):format(key))
			end
		
			-- Compare types.
			if type(_value) ~= column.type then
				error(("Column '%s' type is '%s' but value type is '%s'"):format(key, column.type, type(_value)))
			end

			-- Append setters.
			if setters ~= "" then
				setters = setters..", "
			end

			setters = setters..key.."=@"..key
			values["@"..key] = _value
		end
		
		-- Cache the value.
		self[key] = value
	end

	-- Sync with client.
	TriggerClientEvent("character:update", self.source, args)

	-- Save the values.
	if setters ~= "" then
		exports.GHMattiMySQL:QueryAsync(("UPDATE characters SET %s WHERE id=@id"):format(setters), values)
	end
end