Injury = {
	t = {},
}

--[[ Functions: Injury ]]--
function Injury:Update()
	if IsPedDeadOrDying(Ped) then
		ResurrectPed(Ped)
		ClearPedTasksImmediately(Ped)
	end

	if self.isInjured then
		local isInAir = GetPedConfigFlag(Ped, 76)
		if isInAir ~= self.isInAir then
			ClearPedTasksImmediately(Ped)
			self.isInAir = isInAir
		end
	end

	if self.isWrithing and IsDisabledControlPressed(0, Config.Controls.Die) then
		self:Die(2)
	elseif self.isProning and not IsDisabledControlPressed(0, Config.Controls.Die) then
		self:Writhe(2)
	end
end

function Injury:Activate(value)
	if value and value == self.isInjured then return end

	self.isInjured = value

	SetPedCanRagdoll(Ped, not value)
	SetPedConfigFlag(Ped, 17, value)

	if value then
		self:Writhe()
	else
		Main:Heal()

		if self.isWrithing then
			self:Getup(2)
		else
			self:ClearEmote()
		end
	end
end

function Injury:Writhe(p2)
	self:ClearEmote(p2)

	local anim = Config.Anims.Writhes[GetRandomIntInRange(1, #Config.Anims.Writhes)]
	anim.Force = true
	anim.BlendSpeed = 2.0

	self.emote = exports.emotes:PerformEmote(anim)
	self.isWrithing = true
end

function Injury:Die(p2)
	self:ClearEmote(p2)

	local anim = Config.Anims.Deaths[GetRandomIntInRange(1, #Config.Anims.Deaths)]
	anim.Force = true
	anim.BlendSpeed = 2.0

	self.emote = exports.emotes:PerformEmote(anim)
	self.isProning = true
end

function Injury:Getup(p2)
	self:ClearEmote(p2)

	exports.emotes:PerformEmote(Config.Anims.Revive)
end

function Injury:ClearEmote(p2)
	if not self.emote then return end

	exports.emotes:CancelEmote(self.emote, p2)

	self.isWrithing = false
	self.isProning = false
	self.emote = nil
end

--[[ Listeners ]]--
Main:AddListener("DamageBone", function(bone, amount)
	local health = Main:GetHealth()
	if health < 0.001 then
		Injury:Activate(true)
	end
end)

--[[ Events ]]--
AddEventHandler("health:stop", function()
	Injury:Activate(false)
end)

RegisterNetEvent("health:revive", function()
	Injury:Activate(false)
end)

RegisterNetEvent("health:slay", function()
	Injury:Activate(true)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Injury:Update()
		Citizen.Wait(0)
	end
end)