Injury = {}

--[[ Functions: Injury ]]--
function Injury:Update()
	if IsPedDeadOrDying(Ped) then
		ResurrectPed(Ped)
		ClearPedTasksImmediately(Ped)
	end
end

function Injury:Activate(value)
	if value == self.isInjured then return end

	self.isInjured = value

	SetPedCanRagdoll(Ped, not value)

	if value then
		self:Writhe()
	else
		ClearPedTasksImmediately(Ped)
	end
end

function Injury:Writhe()
	local anim = Config.Writhes[GetRandomIntInRange(1, #Config.Writhes)]
	anim.Force = true

	exports.emotes:PerformEmote(anim)
end

--[[ Listeners ]]--
Main:AddListener("DamageBone", function(bone, amount)
	local health = Main:GetHealth()
	if health < 0.0 then
		Injury:Activate(true)
	end
end)

--[[ Events ]]--
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