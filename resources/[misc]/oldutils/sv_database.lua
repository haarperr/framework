local DataTypes = {
	["int"] = "number",
	["tinyint"] = "number",
	["smallint"] = "number",
	["mediumint"] = "number",
	["bigint"] = "number",
	["float"] = "number",
	["double"] = "number",
	["decimal"] = "number",
	["bit"] = "number",
	["char"] = "string",
	["varchar"] = "string",
	["blob"] = "string",
	["text"] = "string",
	["tinyblob"] = "string",
	["tinytext"] = "string",
	["mediumblob"] = "string",
	["mediumtext"] = "string",
	["longblob"] = "string",
	["longtext"] = "string",
	["enum"] = "string",
	["json"] = "table",
	["date"] = "number",
	["datetime"] = "number",
}

exports("DescribeTable", function(table)
	local output = {}
	local result = exports.ghmattimysql:QueryResult("DESCRIBE `"..table.."`")
	
	for key, row in ipairs(result) do
		local dataType = row.Type
		local dataTypeP = dataType:find("(", 1, true)

		if dataTypeP then
			dataType = dataType:sub(1, dataTypeP - 1)
		end

		if DataTypes[dataType] then
			dataType = DataTypes[dataType]
		else
			print("EXCEPTION: Undefined data type for "..tostring(dataType).." when describing "..table.."!")
		end

		for column, value in pairs(row) do
			if value == "" then
				row[column] = nil
			end
		end

		local default = row.Default
		if dataType == "number" then
			default = tonumber(default)
		end

		output[row.Field] = {
			dataType = dataType,
			rawType = row.Type,
			nullable = row.Null == "YES",
			key = row.Key,
			default = default,
			extra = row.Extra,
		}
	end
	
	return output
end)

exports("GetTableReferences", function(table, column)
	local condition = "REFERENCED_TABLE_NAME=@table"
	if column then
		condition = condition.." AND REFERENCED_COLUMN_NAME=@column"
	end

	local result = exports.ghmattimysql:QueryResult("SELECT TABLE_NAME AS 'table', COLUMN_NAME AS 'column', REFERENCED_COLUMN_NAME AS 'referenced_column' FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA=@schema AND "..condition, {
		["@schema"] = GetConvar("mysql_schema", ""),
		["@table"] = table,
		["@column"] = column
	})

	return result
end)

exports("ConvertTableResult", function(result)
	for k, row in ipairs(result) do
		for _k, column in pairs(row) do
			if type(column) == "string" and column:sub(1, 1) == "[" and column:sub(#column, #column) == "]" then
				result[k][_k] = json.decode(column)
			end
		end
	end
	return result
end)