Emote = {}
Emote.__index = Emote

function Emote:Create(data, id)
	if type(data) == "string" then
		data = Main.emotes[data]
	end
	
	local emote = setmetatable({
		id = id,
		settings = data,
	}, Emote)
	
	if id then
		Main.playing[id] = emote
	end
	
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
		if
			v.id ~= self.id and
			not v.Facial and
			v.isUpperBody == self.isUpperBody and
			not settings.Force
		then
			v:Remove()
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

	-- Create props.
	if settings.Props then
		if not self.props then
			self.props = {}
		end

		for k, v in ipairs(settings.Props) do
			if not IsModelValid(v.Model) then
				print("Invalid model during emote: "..tostring(v.Model))
				break
			end

			while not HasModelLoaded(v.Model) do
				RequestModel(v.Model)
				Citizen.Wait(0)
			end

			local coords = GetEntityCoords(ped)
			local entity = CreateObject(v.Model, coords.x, coords.y, coords.z, true, true, false)
			local offset = v.Offset or { 0, 0, 0, 0, 0, 0}

			SetEntityCollision(entity, false, false)
			AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, v.Bone), offset[1], offset[2], offset[3], offset[4], offset[5], offset[6], false, false, true, true, 0, true)
			SetModelAsNoLongerNeeded(v.Model)

			table.insert(self.props, entity)
		end
	end
end

function Emote:Remove()
	print("removing", self.id)

	if self.id then
		Main.playing[self.id] = nil
	end
	
	if self.props then
		for _, entity in ipairs(self.props) do
			Delete(entity)
		end
		self.props = nil
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
