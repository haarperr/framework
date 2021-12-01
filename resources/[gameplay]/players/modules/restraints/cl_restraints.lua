-- { Dict = "mp_arresting", Name = "idle", Flag = 0 },
Restraints = Restraints or {}

Restraints.controls = {
	22, -- INPUT_JUMP
	24, -- INPUT_ATTACK
	25, -- INPUT_AIM
	45, -- INPUT_RELOAD
	46, -- INPUT_TALK
	47, -- INPUT_DETONATE
	51, -- INPUT_CONTEXT
	52, -- INPUT_CONTEXT_SECONDARY
	55, -- INPUT_DIVE
	58, -- INPUT_THROW_GRENADE
	59, -- INPUT_VEH_MOVE_LR
	68, -- INPUT_VEH_AIM
	69, -- INPUT_VEH_ATTACK
	70, -- INPUT_VEH_ATTACK2
	74, -- INPUT_VEH_HEADLIGHT
	76, -- INPUT_VEH_HANDBRAKE
	101, -- INPUT_VEH_ROOF
	140, -- INPUT_MELEE_ATTACK_LIGHT
	141, -- INPUT_MELEE_ATTACK_HEAVY
	142, -- INPUT_MELEE_ATTACK_ALTERNATE
	143, -- INPUT_MELEE_BLOCK
	144, -- INPUT_PARACHUTE_DEPLOY
	145, -- INPUT_PARACHUTE_DETACH
	257, -- INPUT_ATTACK2
	263, -- INPUT_MELEE_ATTACK1
	264, -- INPUT_MELEE_ATTACK2
}

--[[ Functions: Restraints ]]--
function Restraints:Start(name)
	if self.active then return end
	
	self.active = true
	self.freeing = nil

	LocalPlayer.state:set("restrained", name, true)
end

function Restraints:Stop()
	if not self.active then return end
	
	self.active = nil
	self.freeing = nil

	LocalPlayer.state:set("restrained", nil, true)
end

function Restraints:UpdateEmote()
	local active = self.active and not self.freeing
	if active and not self.emote then
		self.emote = exports.emotes:Play(self.anims.cuffed)
	elseif not active and self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end

	if not self.active then return end

	-- Disable controls.
	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end
end

function Restraints:UpdateState(delta)
	if not self.active then return end

	local ped = PlayerPedId()
	local chance = 0.0

	-- Sprinting.
	if IsPedSprinting(ped) then
		chance = chance + 0.25
	elseif IsPedRunning(ped) then
		chance = chance + 0.05
	end

	-- Stairs.
	if not IsPedStill(ped) and GetPedConfigFlag(ped, 253) then
		chance = chance * 2.0
	end

	-- Check fatigue.
	local fatigue = exports.health:GetEffect("Fatigue") or 0.0
	
	-- Ragdoll chance.
	local ragdoll = GetRandomFloatInRange(0.0, 1.0) < chance / delta * (fatigue * 0.8 + 0.2)
	if ragdoll then
		SetPedToRagdoll(ped, 1000, 0, 3, true, true, false)
	end
	
	-- Ragdoll anims.
	-- if IsPedRagdoll(ped) then
	-- 	Citizen.Wait(200)
	-- 	exports.emotes:Play({ Dict = "get_up@cuffed", Name = "front_to_default", Flag = 0 })
	-- end
end

function Restraints:UseItem(item, slot)
	local info = Restraints.items[item.name]
	if not info then return false end
	
	local player, playerPed, playerDist = GetNearestPlayer()
	if not player or playerDist > Config.MaxDist then return false end
	-- local player = PlayerId()
	
	TriggerServerEvent("players:restrain", slot.slot_id, GetPlayerServerId(player))

	return true, info.Duration
end

--[[ Events: Net ]]--
RegisterNetEvent("players:restrainFinish", function(name)
	local info = name and Restraints.items[name]
	if info and info.Restraint then
		Restraints:Start(name)
	else
		Restraints:Stop()
	end
end)

RegisterNetEvent("players:restrainBegin", function(name)
	local info = Restraints.items[name]
	if not info then return end

	if info.Resist then
		local success = exports.quickTime:Begin({ speed = 1.4, goalSize = 0.2 })
		if success then
			TriggerServerEvent("players:restrainResist")
		end
	end

	if not info.Restraint then
		Restraints.freeing = true
	end
end)

--[[ Events ]]--
AddEventHandler("emotes:cancel", function(id)
	if Restraints.emote == id then
		Restraints.emote = nil
	end
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	local success, duration = Restraints:UseItem(item, slot)
	if success then
		cb(duration)
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Restraints:UpdateEmote()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local delay = 200
	while true do
		Restraints:UpdateState(1000 / delay)
		Citizen.Wait(delay)
	end
end)