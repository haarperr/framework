Main.users = {}
Main.blacklist = {}
Main.mimics = {}

--[[ Functions ]]--
function Main:Init()
	for _, path in ipairs({
		"sql/users.sql",
		"sql/bans.sql",
	}) do
		exports.GHMattiMySQL:Query(LoadQuery(path))
	end

	self.columns = DescribeTable("users")
end

function Main:RegisterPlayer(source)
	-- Check user
	source = tonumber(source)
	if source == nil or self.users[source] ~= nil then return end

	-- Create user.
	local data = self:GetData(source)
	local user = User:Create(data)
	self.users[source] = user

	-- Inform client.
	local endpoint = user.identifiers.endpoint
	user.identifiers.endpoint = nil
	
	TriggerEvent(self.event.."created", source, user)
	TriggerClientEvent(self.event.."sync", source, user)
	
	user.identifiers.endpoint = endpoint
end

function Main:DestroyPlayer(source)
	local user = self.users[source]
	if user == nil then return end

	self.users[user.source or false] = nil
end

function Main:GetData(source)
	if source == nil then return end

	-- Get identifiers.
	local numIdentifiers = GetNumPlayerIdentifiers(source)
	local identifiers = {
		endpoint = GetPlayerEndpoint(source),
		name = GetPlayerName(source),
	}

	-- Get mimics.
	local mimic = self.mimics[identifiers.endpoint]
	
	-- Set identifiers.
	if mimic then
		local user = mimic ~= 0 and exports.GHMattiMySQL:QueryResult("SELECT * FROM `users` WHERE `id`=@id", {
			["@id"] = mimic,
		})[1]
	
		if user then
			for _, key in ipairs(Server.Identifiers) do
				identifiers[key] = user[key]
			end
		else
			identifiers.steam = "000000000000000"
			identifiers.license = "0000000000000000000000000000000000000000"
			identifiers.license2 = "0000000000000000000000000000000000000000"
			identifiers.discord = "000000000000000000"
		end
	else
		for i = 1, numIdentifiers do
			local identifier = GetPlayerIdentifier(source, i - 1)
			if identifier ~= nil then
				local key, value = identifier:match("([^:]+):([^:]+)")
				identifiers[key] = value
			end
		end
	end

	-- Get tokens.
	local numTokens = GetNumPlayerTokens(source)
	local tokens = {}
	
	for i = 1, numTokens do
		local token = GetPlayerToken(source, i - 1)
		if token ~= nil then
			tokens[i] = token
		end
	end
	
	-- Return data.
	return {
		source = source,
		identifiers = identifiers,
		tokens = tokens,
	}
end

function Main:Ban(target, duration, reason)
	local key, value = target:match("([^:]+):([^:]+)")
	print("BAN", key, value)
end
Export(Main, "Ban")

function Main:Set(source, ...)
	local user = self.users[source]
	if user == nil then return false end

	return user:Set(...)
end
Export(Main, "Set")

function Main:Get(source, key)
	local user = self.users[source]
	if user == nil then return end

	return user[key]
end
Export(Main, "Get")

function Main:GetUser(source)
	return self.users[source]
end
Export(Main, "GetUser")

function Main:GetIdentifier(source, identifier)
	local identifiers = self:Get(source, "identifiers")
	return identifiers ~= nil and identifiers[identifier]
end
Export(Main, "GetIdentifier")

function Main:Mimic(endpoint, user)
	if not endpoint then return end

	self.mimics[endpoint] = user
	
	print(("'%s' will now mimic '%s'"):format(endpoint, user or "None"))
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

RegisterNetEvent(Main.event.."ready")
AddEventHandler(Main.event.."ready", function()
	local source = source
	Main:RegisterPlayer(source)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Main:DestroyPlayer(source)
end)