Voip.scope = {}
Voip.channels = {}
Voip.players = {}
Voip.playerChannels = {}
Voip.talking = {}

function Voip:Init()
	TriggerServerEvent("voip:init")
	
	while not MumbleIsConnected() or not DoesEntityExist(PlayerPedId()) do
		Citizen.Wait(20)
	end

	NetworkSetVoiceActive(true)

	local player = PlayerId()
	local serverId = GetPlayerServerId(player)
	
	Voip:Clear()
	
	NetworkSetVoiceChannel(serverId)

	MumbleSetVoiceTarget(1)
	
	MumbleSetAudioInputIntent("speech")
	MumbleSetAudioOutputDistance(100.0)
	
	-- Load active players.
	local localPlayer = PlayerId()
	for _, otherPlayer in ipairs(GetActivePlayers()) do
		if otherPlayer ~= localPlayer then
			local _serverId = GetPlayerServerId(otherPlayer)

			self.scope[_serverId] = true
			self:AddTarget(_serverId)
		end
	end

	-- Set default range.
	self:SetRange(2)

	-- Create submixes.
	if self.submixes then return end

	local radio = CreateAudioSubmix("radio")
	
	AddAudioSubmixOutput(radio, 0)
	SetAudioSubmixEffectRadioFx(radio, 0)
	SetAudioSubmixEffectParamInt(radio, 0, `default`, 0)
	SetAudioSubmixEffectParamFloat(radio, 0, `freq_hi`, 3200.0)
	SetAudioSubmixEffectParamFloat(radio, 0, `freq_low`, 240.0)
	SetAudioSubmixEffectParamFloat(radio, 0, `fudge`, 2.0)

	local phone = CreateAudioSubmix("phone")
	
	AddAudioSubmixOutput(phone, 0)
	SetAudioSubmixEffectRadioFx(phone, 0)
	SetAudioSubmixEffectParamInt(phone, 0, `default`, 0)
	SetAudioSubmixEffectParamFloat(phone, 0, `freq_hi`, 2500.0)
	SetAudioSubmixEffectParamFloat(phone, 0, `freq_low`, 120.0)

	self.submixes = {
		radio = radio,
		phone = phone,
	}
end


function Voip:Update()
	-- Check status.
	local status = MumbleIsConnected()
	
	if self.status ~= status then
		if status then
			self:Init()
		end

		SendNUIMessage({ connected = status })
		self.status = status
	end

	if not status then return end

	-- Get ped.
	local localPed = PlayerPedId()
	local localCoords = GetEntityCoords(localPed)

	-- Find amplifiers.
	local shouldAmplify = false

	for _, amplifier in ipairs(Config.Amplifiers) do
		if #(amplifier.Coords - localCoords) < amplifier.Radius then
			shouldAmplify = true
			break
		end
	end

	-- Update amplifier.
	if shouldAmplify ~= self.amplified then
		self.amplified = shouldAmplify
		if shouldAmplify then
			self:SetRange("M")
			MumbleSetAudioInputIntent("music")
		else
			self:SetRange(self.range)
			MumbleSetAudioInputIntent("speech")
		end
	end
end

function Voip:Input()
	if (self.talkingCount or 0) > 0 then
		SetControlNormal(0, 249, 1.0)
	end

	local isTalking = NetworkIsPlayerTalking(PlayerId())
	isTalking = isTalking == 1 and true or isTalking
	
	if isTalking ~= (self.wasTalking or false) then
		self.wasTalking = isTalking

		SendNUIMessage({ talking = isTalking })

		TriggerServerEvent("voip:setTalking", isTalking)
	end
end

function Voip:Clear()
	for i = 0, 30 do
		MumbleClearVoiceTarget(i)
		MumbleClearVoiceTargetChannels(i)
		MumbleClearVoiceTargetPlayers(i)
	end

	NetworkClearVoiceChannel()
end

function Voip:SetRange(index)
	local range = Config.Ranges[index]
	if not range then return end
	
	if type(index) == "number" then
		self.range = index
	end
	
	SendNUIMessage({ range = index })
	MumbleSetAudioInputDistance(range.Proximity)
end

--[[ Functions: Players ]]--
function Voip:AddTarget(serverId)
	if self.players[serverId] then return false end

	self:Debug("[%i] joined proximity", serverId)

	self.players[serverId] = true

	MumbleAddVoiceTargetPlayerByServerId(1, serverId)

	return true
end

function Voip:RemoveTarget(serverId)
	if not self.players[serverId] then return false end

	self:Debug("[%i] left proximity", serverId)

	self.players[serverId] = nil

	self:UpdateTargets()

	return true
end

function Voip:UpdateTargets()
	MumbleClearVoiceTargetPlayers(1)
	
	for serverId, _ in pairs(self.players) do
		MumbleAddVoiceTargetPlayerByServerId(1, serverId)
	end
	
	for channelId, players in pairs(self.playerChannels) do
		for serverId, _ in pairs(players) do
			MumbleAddVoiceTargetPlayerByServerId(1, serverId)
		end
	end
end

function Voip:SetPlayerTalking(channelId, serverId, value)
	if value and self.talking[serverId] then return end

	Voip:Debug("[%i] %s talking in channel %s", serverId, value and "started" or "stopped", channelId)

	local channel = self.channels[channelId]
	local volume = value and channel.volume or -1.0
	local submix = value and self.submixes[channel.submix or false] or -1

	if volume < 0.01 then
		volume = -1.0
		submix = -1
	end

	MumbleSetVolumeOverrideByServerId(serverId, volume + 0.0)
	MumbleSetSubmixForServerId(serverId, submix)

	self.talking[serverId] = value and channelId or nil

	TriggerEvent(value and "playerStartedTalking" or "playerStoppedTalking", serverId, channelId)

	self:UpdateTalking(value)
end

function Voip:UpdateTalking(value)
	if self.hideFrequencies then return end

	local channels = {}
	for serverId, channelId in pairs(self.talking) do
		channels[#channels + 1] = channelId
	end

	SendNUIMessage({ channels = channels })
end

function Voip:SetTalking(value, ...)
	local channels = {...}
	local filter = #channels > 0 and {} or nil

	for _, channelId in ipairs(channels) do
		filter[channelId] = true
	end

	self.talkingCount = (self.talkingCount or 0) + (value and #channels or -#channels)

	TriggerServerEvent("voip:setTalking", value, filter)
end
Voip:Export("SetTalking")

function Voip:SetVolume(value, ...)
	-- Get channels.
	local channels = {...}
	
	-- Check value.
	if type(value) ~= "number" then return end

	-- Update channels.
	for _, channelId in ipairs(channels) do
		-- Set volume for channel.
		local channel = self.channels[channelId]
		if channel then
			channel.volume = value
		end

		-- Update any talking players.
		local players = self.playerChannels[channelId]
		if players then
			for serverId, _ in pairs(players) do
				local isTalking = self.talking[serverId]
				if isTalking then
					self.talking[serverId] = nil
					self:SetPlayerTalking(channelId, serverId, true)
				end
			end
		end
	end
end
Voip:Export("SetVolume")

function Voip:GetVoiceRange()
	return self.range
end
Voip:Export("GetVoiceRange")

---[[ Functions: Channels ]]--
function Voip:AddToChannel(channelId, serverId)
	self:Debug("[%i] joined channel %s", serverId, channelId)

	local channel = self.playerChannels[channelId]
	if not channel then
		channel = {}
		self.playerChannels[channelId] = channel
	end

	channel[serverId] = true

	MumbleAddVoiceTargetPlayerByServerId(1, serverId)
end

function Voip:RemoveFromChannel(channelId, serverId)
	self:Debug("[%i] left channel %s", serverId, channelId)

	local channel = self.playerChannels[channelId]
	if not channel then return end

	channel[serverId] = nil

	self:UpdateTargets()
end

function Voip:DestroyChannel(channelId)
	self:Debug("Destroyed channel %s", channelId)

	local channel = self.playerChannels[channelId]
	if not channel then return end

	for serverId, _ in pairs(channel) do
		self:SetPlayerTalking(channelId, serverId, false)
	end

	self.playerChannels[channelId] = nil

	self:UpdateTargets()
end

function Voip:JoinChannel(channelId, _type, submix, volume)
	channelId = tostring(channelId)

	-- Default settings.
	if not settings then
		settings = {}
	end

	-- Cache channel.
	self.channels[channelId] = {
		type = _type,
		submix = submix,
		volume = volume or 1.0,
	}

	-- Join channel.
	TriggerServerEvent("voip:joinChannel", channelId, _type)
end
Voip:Export("JoinChannel")

function Voip:LeaveChannel(channelId)
	channelId = tostring(channelId)

	-- Cache channel.
	self.channels[channelId] = nil
	
	-- Join channel.
	TriggerServerEvent("voip:leaveChannel", channelId)
end
Voip:Export("LeaveChannel")

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		
		Voip:Update()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		Voip:Input()
	end
end)

--[[ Events ]]--
AddEventHandler("voip:clientStart", function()
	Voip.hideFrequencies = GetResourceKvpInt(Config.ChannelHudKey) == 1
end)

AddEventHandler("voip:stop", function()
	Voip:Clear()
end)

RegisterNetEvent("voip:addToScope", function(serverId)
	Voip.scope[serverId] = true
	Voip:AddTarget(serverId)
end)

--[[ Events: Net ]]--
RegisterNetEvent("voip:removeFromScope", function(serverId)
	Voip.scope[serverId] = nil
	Voip:RemoveTarget(serverId)
end)

RegisterNetEvent("voip:addToChannel", function(channelId, serverId, talking)
	if type(serverId) == "table" then
		Voip:Debug("Joining channel: %s", channelId)

		for _serverId, _ in pairs(serverId) do
			Voip:AddToChannel(channelId, tonumber(_serverId))
		end
	else
		Voip:AddToChannel(channelId, serverId)
	end

	if talking then
		for _serverId, value in pairs(talking) do
			Voip:SetPlayerTalking(channelId, tonumber(_serverId), true)
		end
	end
end)

RegisterNetEvent("voip:removeFromChannel", function(channelId, serverId)
	if serverId then
		Voip:RemoveFromChannel(channelId, serverId)
	else
		Voip:DestroyChannel(channelId)
	end
end)

RegisterNetEvent("voip:setTalking", function(channelId, serverId, value)
	Voip:SetPlayerTalking(channelId, serverId, value)
end)