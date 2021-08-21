Emote = {}
Emote.__index = Emote

function Emote:Create(data)
	if type(data) == "string" then
		data = Emotes[data]
	end
	
	local emote = setmetatable({ settings = data }, Emote)
	local flag = emote.settings.Flag or 0

	emote.isUpperBody = (flag >= 10 and flag <= 31) or (flag >= 48 and flag <= 63)

	if data.Autoplay ~= false then
		emote:Play()
	end

	return emote
end

function Emote:Play(settings)
	-- Get settings.
	local settings = settings or self.settings
	if not settings then return end

	-- Clear old emotes.
	for k, v in pairs(Main.playing) do
		local settings = v.settings or {}
		if not v.Facial and v.isUpperBody == self.isUpperBody and not settings.Force then
			Main.playing[k] = nil
		end
	end

	-- Get ped.
	local ped = settings.ped or PlayerPedId()
	self.ped = ped

	-- Play secondary emote.
	if settings.Secondary then
		self:Play(settings.Secondary)
	end

	-- Play animations.
	if settings.Facial then
		self:RequestDict(settings.Dict)

		ClearFacialIdleAnimOverride(ped)
		SetFacialClipsetOverride(ped, settings.Dict)
		SetFacialIdleAnimOverride(ped, settings.Name)
	elseif settings.Dict then
		self:RequestDict(settings.Dict)

		TaskPlayAnim(
			ped,
			settings.Dict,
			settings.Name,
			settings.BlendIn or settings.BlendSpeed or 2.0,
			settings.BlendOut or settings.BlendSpeed or 2.0,
			settings.Duration or -1,
			settings.Flag or 0,
			settings.Rate or 0.0,
			settings.Lock or false,
			settings.Lock or false,
			settings.Lock or false
		)
	end
end

function Emote:RequestDict(dict)
	-- Get dict.
	if not dict then return
		false
	end

	-- Check dict exists.
	if not DoesAnimDictExist(dict) then
		return false
	end

	-- Load dict.
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end

	-- Dict loaded.
	return true
end
