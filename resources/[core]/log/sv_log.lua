Main = {
	players = {},
	event = GetCurrentResourceName()..":",
}

--[[ Functions ]]--
function Main:Init()
	-- Cache session.
	self.session = exports.GHMattiMySQL:QueryScalar([[
		INSERT INTO `logs_sessions` (`id`) VALUES (DEFAULT);
		SELECT LAST_INSERT_ID();
	]])

	-- Log.
	self:Add({
		verb = "initialize",
		extra = ("session id: %s"):format(self.session),
	})

	-- Update current players.
	for i = 1, GetNumPlayerIndices() do
		local player = GetPlayerFromIndex(i - 1)
		self:RegisterPlayer(tonumber(player), true)
	end
end

function Main:Update()
	for player, info in pairs(self.players) do
		info.spam = 0
	end
end

function Main:Add(data)
	if self.session == nil or type(data) ~= "table" then return end

	-- Get source.
	local sourceInfo = nil
	if data.source ~= nil then
		sourceInfo = self.players[data.source]
		if sourceInfo == nil then
			return
		end
	end

	-- Get target.
	local targetInfo = nil
	if data.target ~= nil then
		targetInfo = self.players[data.target]
		if targetInfo == nil then
			return
		end
	end

	-- Anti-spam check.
	if data.source ~= nil and not data.ignoreAntispam then
		sourceInfo.spam = sourceInfo.spam + 1
		if sourceInfo.spam >= 60 then
			DropPlayer(data.source, "anti-spam")
			return
		end
	end

	-- Switch source and targets.
	if data.switch then
		local _source = data.source
		data.source = data.target
		data.target = _source
	end

	data.switch = nil

	-- Get webhook.
	local channel = data.channel or "general"
	if data.channel then
		data.channel = nil
	end

	-- Get table.
	local table = data.table or "logs"
	local isDefault = not data.table

	if isDefault then
		if data.source ~= nil then
			-- Set identifier.
			data.source_user_id = sourceInfo.id
			
			-- Get the coordinates.
			local ped = GetPlayerPed(data.source)
			if DoesEntityExist(ped) then
				local coords = GetEntityCoords(ped)

				data.pos_x = coords.x
				data.pos_y = coords.y
				data.pos_z = coords.z
			end
		end

		if data.target ~= nil then
			-- Set identifier.
			data.target_user_id = targetInfo.id
		end

		-- Set default parameters.
		data.resource = data.resource or GetInvokingResource()
	else
		data.table = nil
	end

	-- Set session id.
	data.session_id = self.session

	-- Insert into the table.
	exports.GHMattiMySQL:Insert(table, { data })

	if isDefault and channel ~= "none" then
		-- Get the formatted text.
		local text = ""

		if data.source then
			text = AppendText(text, self:GetPlayerText(data.source))
		end

		if data.verb then
			text = AppendText(text, data.verb)
		end
		
		if data.noun then
			text = AppendText(text, data.noun)
		end

		if data.target then
			if data.source == data.target then
				text = AppendText(text, "themself")
			else
				text = AppendText(text, self:GetPlayerText(data.target))
			end
		end

		if data.extra then
			local extra = "("..tostring(data.extra)..")"
			text = AppendText(text, extra)
		end

		-- Print the message.
		print(("[%s] %s"):format(data.resource, text))

		-- Send webhooks.
		if not data.is_sensitive then
			local webhook = GetConvar(channel.."_logs", "")
			if webhook ~= "" then
				PerformHttpRequest(webhook, function(err, text, headers)
				end, "POST", json.encode({
					username = "Log",
					content = text,
					tts = false,
				}), { ["Content-Type"] = "application/json" })
			end
		end
	end
end

function Main:RegisterPlayer(source, skipLog)
	-- Check registered already.
	if self.players[source] ~= nil then return false end

	-- Get id.
	local id = exports.user:Get(source, "id")
	if not id then return false end

	-- Get name.
	local name = exports.user:GetIdentifier(source, "name")
	if not name then return false end

	-- Get steam.
	local steam = exports.user:GetIdentifier(source, "steam")
	if not steam then return false end

	-- Get player text.
	local text = "["..tostring(source).."] "..tostring(name).."@"..tostring(steam)

	-- Cache player.
	self.players[source] = {
		id = id,
		spam = 0,
		text = text,
	}

	-- Log.
	if not skipLog then
		self:Add({
			source = source,
			verb = "connected",
		})
	end

	-- Return success.
	return true
end

function Main:DestroyPlayer(source, skipLog)
	-- Get player.
	local player = self.players[source]
	if player == nil then return false end

	-- Log.
	if not skipLog then
		self:Add({
			source = source,
			verb = "disconnected",
		})
	end
	
	-- Uncache player.
	self.players[source] = nil

	-- Return success.
	return true
end

function Main:GetPlayerText(source)
	local player = self.players[source]
	if player == nil then return end

	return player.text
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("user:created", function(source, user)
	Main:RegisterPlayer(source)
end)

AddEventHandler("playerDropped", function()
	local source = source
	Main:DestroyPlayer(source)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	for k, v in pairs(Main) do
		if type(v) == "function" then
			exports(k, function(...)
				return Main[k](Main, ...)
			end)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(30000)
	end
end)