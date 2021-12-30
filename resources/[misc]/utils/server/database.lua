local types = {
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
	["timestamp"] = "number",
}

local function IsServerStarting()
	for i = 0, GetNumResources() - 1 do
		local resource = GetResourceByFindIndex(i)
		local state = GetResourceState(resource)
		if state == "starting" then
			return true
		end
	end
	return false
end

function DescribeTable(table)
	local output = {}
	local columns = exports.GHMattiMySQL:QueryResult("DESCRIBE `"..table.."`")

	for _, column in ipairs(columns) do
		local _type = column.Type:match("%a+")

		output[column.Field] = {
			rawType = column.Type,
			sqlType = _type,
			type = types[_type],

			default = column.Default,
			key = column.Key,
			nullable = column.Null == "YES",
		}
	end

	return output
end

function GetTableReferences(table, column)
	local schema = GetConvar("mysql_schema", "")
	if schema == "" then return {} end

	return exports.GHMattiMySQL:QueryResult([[
		SELECT
			TABLE_NAME AS 'table',
			COLUMN_NAME AS 'column',
			REFERENCED_COLUMN_NAME AS 'referenced_column'
		FROM
			INFORMATION_SCHEMA.KEY_COLUMN_USAGE
		WHERE
			TABLE_SCHEMA=@schema AND
			REFERENCED_TABLE_NAME=@table
	]]..((column and "AND REFERENCED_COLUMN_NAME=@column") or ""), {
		["@schema"] = schema,
		["@table"] = table,
		["@column"] = column,
	})
end

function ConvertTableResult(result)
	for k, row in ipairs(result) do
		for _k, column in pairs(row) do
			if type(column) == "string" and column:sub(1, 1) == "[" and column:sub(#column, #column) == "]" then
				result[k][_k] = json.decode(column)
			end
		end
	end
	return result
end

function LoadQuery(path)
	return LoadResourceFile(GetCurrentResourceName(), path)
end

function RunQuery(path)
	exports.GHMattiMySQL:Query(LoadQuery(path))
end

function WaitForTable(table)
	while IsServerStarting() do
		Citizen.Wait(200)
	end

	local schema = GetConvar("mysql_schema", "")
	if schema == "" then return end

	while exports.GHMattiMySQL:QueryResult([[
		SELECT 1 FROM information_schema.tables
		WHERE table_schema=@schema AND table_name=@table
		LIMIT 1;
	]], {
		["@schema"] = schema,
		["@table"] = table,
	})[1] ~= 1 do
		Citizen.Wait(200)
	end
end