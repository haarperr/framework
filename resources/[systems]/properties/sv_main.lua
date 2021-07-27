Main = {}

function Main:Init()
	Main:LoadDatabase()
	Main:SyncProperties()
end

function Main:LoadDatabase()
	WaitForTable("characters")

	for _, path in ipairs({
		"sql/properties.sql",
	}) do
		exports.GHMattiMySQL:Query(LoadQuery(path))
	end
end

function Main:SyncProperties()
	-- local queries = {}

	-- for k, property in ipairs(Properties) do
	-- 	queries[k] = ("INSERT IGNORE INTO `properties` SET `id`="):format()
	-- end

	-- exports.GHMattiMySQL:Transaction(queries)
end

--[[ Events ]]--
AddEventHandler("properties:start", function()
	Main:Init()
end)