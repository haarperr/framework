Main.cooldowns = {}

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

RegisterNetEvent(Main.event.."place", function(item, variant, coords, rotation)
	local source = source

	-- Get settings.
	local settings = Config.Decorations[item or false]
	if not settings then
		print("no settings")
		return
	end

	-- Update cooldowns.
	local cooldown = Main.cooldowns[source]
	if cooldown and os.clock() - cooldown < 3.0 then return end

	Main.cooldowns[source] = os.clock()

	-- Check input.
	if type(coords) ~= "vector3" or type(rotation) ~= "vector3" or (variant and type(variant) ~= "number") then
		print("invalid input type")
		return
	end

	-- Get character id.
	local character = exports.character:Get(source, "id")
	if not character then return end

	-- Get instance.
	local instance = exports.instances:Get(source)

	-- Create decoration.
	local decoration = Decoration:Create({
		item = item,
		coords = coords,
		rotation = rotation,
		variant = variant,
		instance = instance,
		character_id = character,
	})
end)