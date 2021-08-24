Injury = {}

--[[ Functions: Injury ]]--
function Injury:Update()
	if IsPedDeadOrDying(Ped) then
		ResurrectPed(Ped)
		ClearPedTasksImmediately(Ped)
	end
	
	local health = Main.effects["Health"]
	if self.isInjured then
		local isInAir = GetPedConfigFlag(Ped, 76)
		if isInAir ~= self.isInAir then
			ClearPedTasksImmediately(Ped)
			self.isInAir = isInAir
		end

		if health > 0.001 then
			self:Activate(false)
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
		self:Writhe()

		exports.interact:AddOption({
			id = "injury",
			text = "Injured",
			icon = "healing",
			sub = {
				{
					id = "injury-die",
					text = "Passout",
					icon = "arrow_circle_down",
				},
				{
					id = "injury-wakeup",
					text = "Wake Up",
					icon = "arrow_circle_up",
				},
			},
		})
	else
		if self.isWrithing then
			self:Getup(2)
		else
			self:ClearEmote()
		end

		exports.interact:RemoveOption("injury")
	end
end

function Injury:Writhe(p2)
	local anim = Config.Anims.Writhes[GetRandomIntInRange(1, #Config.Anims.Writhes)]
	anim.Locked = true
	anim.BlendSpeed = 2.0

	self.emote = exports.emotes:Play(anim, true)
	self.isWrithing = true
end

function Injury:Die(p2)
	local anim = Config.Anims.Deaths[GetRandomIntInRange(1, #Config.Anims.Deaths)]
	anim.Locked = true
	anim.BlendSpeed = 2.0

	self.emote = exports.emotes:Play(anim, true)
	self.isDead = true
end

function Injury:Getup(p2)
	self.isWrithing = nil
	self.isDead = nil
	self.emote = nil
	
	exports.emotes:Play(Config.Anims.Revive, true)
end

function Injury:ClearEmote(p2)
	if not self.emote then return end

	exports.emotes:Stop(self.emote, p2)
	
	self.isWrithing = false
	self.isDead = false
	self.emote = nil
end

--[[ Events ]]--
AddEventHandler("health:stop", function()
	Injury:Activate(false)
end)

AddEventHandler("interact:onNavigate_injury-wakeup", function()
	if Injury.isDead then
		Injury:Writhe(2)
	else
		TriggerEvent("chat:notify", {
			class = "inform",
			text = "You are already awake!",
		})
	end
end)

AddEventHandler("interact:onNavigate_injury-die", function()
	if Injury.isWrithing then
		Injury:Die(2)
	else
		TriggerEvent("chat:notify", {
			class = "inform",
			text = "You are already passed out!",
		})
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Injury:Update()
		Citizen.Wait(0)
	end
end)