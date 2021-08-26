Injury = {
	options = {
		{
			id = "injury-passout",
			text = "Passout",
			icon = "arrow_circle_down",
			anim = "Deaths",
		},
		{
			id = "injury-writhe",
			text = "Writhe",
			icon = "arrow_circle_up",
			anim = "Writhes",
		},
		{
			id = "injury-situp",
			text = "Sit Up",
			icon = "chair",
			anim = "Sit",
			func = function()
				return true
			end,
		},
	}
}

--[[ Functions: Injury ]]--
function Injury:Update()
	if IsPedDeadOrDying(Ped) then
		ResurrectPed(Ped)
		ClearPedTasksImmediately(Ped)
	end
	
	local health = Main.effects["Health"]
	if self.isInjured then
		-- Stop getting up.
		local isInAir = GetPedConfigFlag(Ped, 76)
		if isInAir ~= self.isInAir then
			ClearPedTasksImmediately(Ped)
			self.isInAir = isInAir
		end

		-- Deactivate when healed.
		if health > 0.001 then
			self:Activate(false)
		end

		-- Disable controls.
		for i = 0, 360 do
			if not Config.EnableControls[i] then
				DisableControlAction(0, i)
			end
		end

		-- Replay emotes.
		if self.anim and (not self.emote or not exports.emotes:IsPlaying(self.emote, true)) then
			self.emote = exports.emotes:Play(self.anim, true)
		end
	else
		if health and health < 0.001 then
			self:Activate(true)
		end
	end
end

function Injury:Activate(value)
	if value and value == self.isInjured then return end

	self.isInjured = value

	SetPedCanRagdoll(Ped, not value)
	SetPedConfigFlag(Ped, 17, value)

	if value then
		self:SetAnim("Writhes")
	else
		if self.anim then
			self:Getup(2)
		else
			self:ClearEmote()
		end

		Main:BuildNavigation()
	end
end

function Injury:Getup(p2)
	self.anim = nil
	self.emote = nil
	
	exports.emotes:Play(Config.Anims.Revive, true)
end

function Injury:SetAnim(name, p2)
	local anim = Config.Anims[name]
	if #anim > 0 then
		anim = anim[GetRandomIntInRange(1, #anim + 1)]
	end

	if anim == self.anim then
		return false
	end

	anim.Locked = true
	anim.BlendSpeed = 2.0

	self.emote = exports.emotes:Play(anim, true)
	self.anim = anim
	self.name = name

	Main:BuildNavigation()

	return true
end

function Injury:ClearEmote(p2)
	if self.emote then
		exports.emotes:Stop(self.emote, p2)
	end
	
	self.emote = nil
	self.anim = nil
end

--[[ Listeners ]]--
Main:AddListener("BuildNavigation", function(options)
	if not Injury.isInjured then return end
	
	for k, option in ipairs(Injury.options) do
		if option.anim ~= Injury.name and (not option.func or option.func()) then
			options[#options + 1] = {
				id = option.id,
				text = option.text,
				icon = option.icon,
			}
		end
	end
end)

--[[ Events ]]--
AddEventHandler("health:stop", function()
	Injury:Activate(false)
end)

AddEventHandler("interact:onNavigate", function(id)
	if id:sub(1, ("injury"):len()) ~= "injury" then
		return
	end
	for k, option in ipairs(Injury.options) do
		if option.id == id then
			Injury:SetAnim(option.anim, 2)
			break
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Injury:Update()
		Citizen.Wait(0)
	end
end)