CriminalCode = {}
CriminalCodeIds = {}
Cooldowns = {}

--[[ Functions ]]--
function CheckUser(source, faction)
	if not faction then return false end
	local settings = Config.Types[faction]
	if not settings then return false end

	return exports.jobs:IsInEmergency(source, "AccessMdt") == faction
end

function Initialize()
	CriminalCode = exports.GHMattiMySQL:QueryResult("SELECT * FROM mdt_criminal_code")
	CriminalCodeIds = {}
	for k, v in ipairs(CriminalCode) do
		CriminalCodeIds[v.id] = v
	end
end

--[[ Events ]]--
RegisterNetEvent("mdt:requestCriminalCode")
AddEventHandler("mdt:requestCriminalCode", function()
	local source = source
	TriggerClientEvent("mdt:receiveCriminalCode", source, CriminalCode)
end)

RegisterNetEvent("mdt:search")
AddEventHandler("mdt:search", function(faction, loader, data, offset)
	local source = source
	local status = CheckUser(source, faction)

	if not status then return end
	if offset ~= nil and type(offset) ~= "number" then return end
	
	local statement = nil
	local conditions = nil
	local result = nil
	
	-- if loader == "persons" then
	-- 	if type(data) ~= "string" or data:len() > 512 then return end

	-- 	local firstName = ""
	-- 	local lastName = ""
	-- 	local i = 1;
	-- 	for str in data:gmatch("([^%s]+)") do
	-- 		if i == 1 then
	-- 			firstName = str
	-- 		elseif i == 2 then
	-- 			lastName = str
	-- 		else
	-- 			break
	-- 		end
	-- 		i = i + 1
	-- 	end

	-- 	statement = "SELECT id, first_name, last_name, dob, gender, license_text, dead FROM characters"
	-- 	if firstName ~= "" then
	-- 		statement = statement.." WHERE first_name LIKE @first_name"
	-- 		conditions = {
	-- 			["@first_name"] = "%"..firstName.."%"
	-- 		}

	-- 		if lastName ~= "" then
	-- 			statement = statement.." AND last_name LIKE @last_name"
	-- 			conditions["@last_name"] = "%"..lastName.."%"
	-- 		else
	-- 			statement = statement.." OR last_name LIKE @last_name"
	-- 			conditions["@last_name"] = "%"..firstName.."%"
	-- 		end
	-- 		statement = statement.." ORDER BY first_name, last_name ASC"
	-- 	end
	-- elseif loader == "vehicles" then
	-- 	if type(data) ~= "string" or data:len() > 512 then return end

	-- 	statement = "SELECT id, plate, model, (SELECT CONCAT(characters.first_name, ' ', characters.last_name) FROM characters WHERE characters.id=vehicles.character_id) AS `name` FROM vehicles"

	-- 	if data ~= "" then
	-- 		statement = statement.." WHERE plate LIKE @plate"
	-- 		conditions = {
	-- 			["@plate"] = "%"..data.."%",
	-- 		}
	-- 	end
	-- else
	-- end
	local typeSettings = ServerConfig.Types[faction]
	if not typeSettings then return end

	if typeSettings.Load then
		result = typeSettings.Load(source, loader, data)
	end

	if statement then
		if offset and offset > 0 then
			statement = statement.." LIMIT "..tostring(offset)..", "..tostring(Config.SearchLimit)
		else
			statement = statement.." LIMIT "..tostring(Config.SearchLimit)
		end

		result = exports.GHMattiMySQL:QueryResult(statement, conditions)
	end

	TriggerClientEvent("mdt:receive", source, loader, result, offset)
end)

RegisterNetEvent("mdt:save")
AddEventHandler("mdt:save", function(faction, id, _type, diff)
	local source = source
	
	if Cooldowns[source] and os.clock() - Cooldowns[source] < 1.0 then return end
	Cooldowns[source] = os.clock()

	local status = CheckUser(source, faction)

	if not status then return end
	if type(id) ~= "number" then return end

	local statement = nil
	local conditions = {
		["@id"] = id
	}

	if _type == "person" then
		local setters = ""

		for k, v in pairs(diff) do
			local _type = type(v)
			if ServerConfig.ValidDiffs[k] and (v == false or _type == ServerConfig.ValidDiffs[k]) then
				if setters ~= "" then
					setters = setters..", "
				end
				if v == false then
					setters = setters..k.."=NULL"
				else
					setters = setters..k.."=@"..k
					conditions["@"..k] = v
				end
			end
		end

		if setters == "" then return end

		local table = "mdt_"..faction.."_profiles"

		statement = ([[
			IF EXISTS (SELECT 1 FROM ]]..table..[[ WHERE character_id=@id) THEN
				UPDATE ]]..table..[[ SET ]]..setters..[[ WHERE character_id=@id;
			ELSE
				INSERT INTO ]]..table..[[ SET character_id=@id, ]]..setters..[[;
			END IF;
		]]):format(table)
	end

	if statement == nil then return end

	if EnableDebug then
		print(statement)
	end

	exports.log:Add({
		source = source,
		verb = "editing",
		noun = "profile",
		extra = ("character id: %s"):format(id),
	})
	
	exports.GHMattiMySQL:QueryAsync(statement, conditions)
end)

RegisterNetEvent("mdt:load")
AddEventHandler("mdt:load", function(faction, loader, data)
	local source = source
	
	local status = CheckUser(source, faction)
	if not status then return end

	local typeSettings = ServerConfig.Types[faction]
	if not typeSettings then return end

	TriggerClientEvent("mdt:loaded", source, typeSettings.Load(source, loader, data))
end)

RegisterNetEvent("mdt:report")
AddEventHandler("mdt:report", function(faction, data)
	local source = source

	if Cooldowns[source] and os.clock() - Cooldowns[source] < 1.0 then return end
	Cooldowns[source] = os.clock()

	local status = CheckUser(source, faction)
	if not status then return end

	local authorId = exports.character:Get(source, "id")
	if not authorId then return end
	
	local targetId = exports.GHMattiMySQL:QueryScalar("SELECT id FROM `characters` WHERE license_text=@license_text AND first_name=@first_name AND last_name=@last_name", {
		["@license_text"] = data.license_text,
		["@first_name"] = data.first_name,
		["@last_name"] = data.last_name,
	})
	
	if not targetId then return end
	local typeSettings = ServerConfig.Types[faction]
	if not typeSettings then return end

	typeSettings.Add(source, authorId, targetId, data)
end)

AddEventHandler("mdt:start", function()
	Initialize()
end)