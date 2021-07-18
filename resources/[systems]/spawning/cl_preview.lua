Preview = setmetatable({
	peds = {},
}, {
	__index = function(table, key)
		return key ~= "settings" and Preview.settings and Preview.settings[key]
	end
})

function Preview:Init()
	-- Fade out.
	DoScreenFadeOut(0)
	Citizen.Wait(1000)

	-- Cache settings.
	self.settings = Config.Previews[GetRandomIntInRange(1, #Config.Previews)]
	self.isActive = true
	
	-- Init functions.
	for k, v in pairs(self) do
		if k:sub(1, 5) == "Init_" then
			v(self)
		end
	end
	
	-- Fade in.
	DoScreenFadeIn(2000)
end

function Preview:Destroy()
	local camera = self.camera
	if camera then
		camera:Destroy()
		self.camera = nil
	end

	ClearFocus()
	ClearTimecycleModifier()

	for _, audioScene in ipairs(Config.AudioScenes) do
		StopAudioScene(audioScene)
	end
	
	self.isActive = false
end

function Preview:Init_Cam()
	local camera = Camera:Create({
		coords = self.Camera.Coords,
		rotation = self.Camera.Rotation,
		fov = self.Camera.Fov,
		shake = {
			type = "HAND_SHAKE",
			amount = 0.1,
		}
	})

	camera:Activate()

	self.camera = camera
end

function Preview:Init_Timecycle()
	if self.Timecycle then
		SetTimecycleModifier(self.Timecycle.Name)
		SetTimecycleModifierStrength(self.Timecycle.Strength or 1.0)
	else
		ClearTimecycleModifier()
	end
end

function Preview:Init_Audio()
	for _, audioScene in ipairs(Config.AudioScenes) do
		StartAudioScene(audioScene)
	end
end

function Preview:Init_Peds()

end

function Preview:Update()
	-- local cam = self.cam
	-- if not cam then return end

	-- cam:Set("pos", self.Camera.Coords)
	-- cam:Set("rot", self.Camera.Rotation)
	-- cam:Set("fov", self.Camera.Fov)
	
	SetFocusPosAndVel(self.Camera.Coords)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Preview.isActive then
			Preview:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Events ]]--
AddEventHandler("spawning:stop", function()
	for ped, info in pairs(Preview.peds) do
		DeleteEntity(ped)
	end
end)