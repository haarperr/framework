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
			self.playing[k] = nil
		end
	end
end

function Main:UpdateQueue()
	local data = self.queue[1]
	local duration = data.Duration or (data.Dict and math.floor(GetAnimDuration(data.Dict, data.Name) * 1000)) or 1000
	data.noAutoplay = true

	print("playing", data, duration)
	
	self:PerformEmote(data)

	Citizen.Wait(duration)

	table.remove(self.queue, 1)

	if #self.queue > 0 then
		self:UpdateQueue()
	else
		self.thread = nil
	end
end

function Main:Queue(data)
	table.insert(self.queue, data)

	if not self.thread then
		self.thread = function()
			Main:UpdateQueue()
		end

		Citizen.CreateThread(self.thread)
	end
end

function Main:PerformEmote(data)
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

	self.lastKey = key
end
Export(Main, "PerformEmote")

function Main:CancelEmote(immediate)
	local ped = PlayerPedId()

	if immediate then
		ClearPedTasksImmediately(ped)
	else
		ClearPedTasks(ped)
	end

	for k, emote in pairs(self.playing) do
		if not emote.Facial then
			self.playing[k] = nil
		end
	end
end
Export(Main, "CancelEmote")

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(200)
	end
end)