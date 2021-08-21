Main = {
	playing = {},
	queue = {},
}

function Main:Update()
	local ped = PlayerPedId()

	for k, emote in pairs(self.playing) do
		local settings = emote.settings or {}
		local isPlaying = settings.Dict and IsEntityPlayingAnim(ped, settings.Dict, settings.Name, 3)

		if
			not emote.noAutoplay and
			((emote.ped and emote.ped ~= ped) or
			(not isPlaying and settings.Flag and settings.Flag % 2 ~= 0 and settings.Flag % 4 ~= 0))
		then
			print("replay anim", settings.Dict, settings.Name)
			emote:Play()
		elseif not isPlaying then
			print("anim over", settings.Dict, settings.Name)
			
			emote.stopping = true
			self.playing[k] = nil
			self.isForcing = nil
		end
	end
end

function Main:UpdateQueue()
	local emote = self.queue[1]
	if not emote then return false end

	local duration = emote.Duration or (emote.Dict and math.floor(GetAnimDuration(emote.Dict, emote.Name) * 1000)) or 1000
	emote.noAutoplay = true

	print("playing", duration, json.encode(emote))
	
	self:PerformEmote(emote)

	Citizen.Wait(0)

	local startTime = GetGameTimer()
	while GetGameTimer() - startTime < duration and (emote.Dict and IsEntityPlayingAnim(PlayerPedId(), emote.Dict, emote.Name, 3)) do
		Citizen.Wait(0)
	end

	table.remove(self.queue, 1)

	return true
end

function Main:Queue(data)
	table.insert(self.queue, data)
end

function Main:PerformEmote(data)
	if type(data) == "string" then
		data = Emotes[data]
	end

	if not data or (not data.Force and self.isForcing) then return end

	local key = (self.lastKey or 0) + 1
	
	print("perform emote", key)

	if data.Sequence then
		for _, stage in ipairs(data.Sequence) do
			stage.key = key
			self:Queue(stage)
		end
	else
		local emote = Emote:Create(data)
		self.playing[key] = emote
	end

	if data.Force then
		self.isForcing = true
	end

	self.lastKey = key

	return key
end
Export(Main, "PerformEmote")

function Main:CancelEmote(p1, p2)
	local cancelEmote
	if type(p1) == "number" then
		cancelEmote = self.playing[p1]
	end

	-- Don't cancel forced emotes.
	if self.isForcing and not cancelEmote then return end

	print("cancel emote")

	-- Get ped.
	local ped = PlayerPedId()

	-- Stop the actual animation.
	if (not cancelEmote and p1) or p2 == true then
		ClearPedTasksImmediately(ped)
	elseif p2 ~= 2 then
		ClearPedTasks(ped)
	end

	-- Clear normal animations.
	if cancelEmote then
		print("clearing anim", p1)
		self.playing[p1] = nil
		self.isForcing = nil
	else
		for k, emote in pairs(self.playing) do
			if not emote.Facial then
				self.playing[k] = nil
			end
		end

		print("clearing anims")

		-- Clear queue.
		self.queue = {}
	end
end
Export(Main, "CancelEmote")

function Main:PlayOnPed(ped, data)
	if not ped or not DoesEntityExist(ped) then return end

	data.ped = ped

	local emote = Emote:Create(data)
end
Export(Main, "PlayOnPed")

function Main:RemoveProps()
	local ped = PlayerPedId()
	for k, entity in ipairs(exports.oldutils:GetObjects()) do
		if DoesEntityExist(entity) and IsEntityAttachedToEntity(entity, ped) then
			self:Delete(entity)
		end
	end
end

function Main:Delete(entity)
	Citizen.CreateThread(function()
		while DoesEntityExist(entity) do
			NetworkRequestControlOfEntity(entity)
			DeleteEntity(entity)

			Citizen.Wait(50)
		end
	end)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Main:UpdateQueue() then
			Citizen.Wait(0)
		else
			Citizen.Wait(100)
		end
	end
end)

--[[ Events ]]--
RegisterNetEvent("instances:join", function(id)
	Main:RemoveProps()
end)

RegisterNetEvent("instances:leave", function(id)
	Main:RemoveProps()
end)