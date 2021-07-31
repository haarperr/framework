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
			not emote.noAutoplay and not settings.Force and
			((emote.ped and emote.ped ~= ped) or
			(not isPlaying and settings.Flag and settings.Flag % 2 ~= 0 and settings.Flag % 4 ~= 0))
		then
			print("replay anim", settings.Dict, settings.Name)
			emote:Play()
		elseif not isPlaying then
			print("anim over", settings.Dict, settings.Name)
			self.playing[k] = nil
			self.isForcing = nil
		end
	end
end

function Main:UpdateQueue()
	local data = self.queue[1]
	if not data then return false end

	local duration = data.Duration or (data.Dict and math.floor(GetAnimDuration(data.Dict, data.Name) * 1000)) or 1000
	data.noAutoplay = true

	print("playing", data, duration)
	
	self:PerformEmote(data)

	Citizen.Wait(duration)

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

	if not data then return end
	local key = (self.lastKey or 0) + 1

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
end
Export(Main, "PerformEmote")

function Main:CancelEmote(immediate)
	-- Don't cancel forced emotes.
	if self.isForcing then return end

	-- Get ped.
	local ped = PlayerPedId()

	-- Stop the actual animation.
	if immediate then
		ClearPedTasksImmediately(ped)
	else
		ClearPedTasks(ped)
	end

	-- Clear normal animations.
	for k, emote in pairs(self.playing) do
		if not emote.Facial then
			self.playing[k] = nil
		end
	end

	-- Clear queue.
	self.queue = {}
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