--[[ Functions ]]--
function Main:Init()
	-- Load tables.
	self:LoadDatabase()

	-- Load decorations.
	self:LoadDecorations()
end

function Main:LoadDatabase()
	WaitForTable("characters")
	WaitForTable("items")

	RunQuery("sql/decorations.sql")
end

function Main:LoadDecorations()
	
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)