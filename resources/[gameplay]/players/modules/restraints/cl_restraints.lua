-- { Dict = "mp_arresting", Name = "idle", Flag = 0 },
Restraints = Restraints or {}

--[[ Functions: Restraints ]]--
function Restraints:Start(name)
	if self.active then return end
	
	self.active = true

	LocalPlayer.state.restrained = name
end

function Restraints:Stop()
	if not self.active then return end
	
	self.active = nil

	LocalPlayer.state.restrained = nil
end

function Restraints:UpdateEmote()
	if self.active and not self.emote then
		self.emote = exports.emotes:Play(self.anims.cuffed)
	elseif not self.active and self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
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
	local player, playerPed, playerDist = GetNearestPlayer()
	if not player or playerDist > Config.MaxDist then return end
	-- local player = PlayerId()
	
	TriggerServerEvent("players:restrain", slot.slot_id, GetPlayerServerId(player))
end

--[[ Events: Net ]]--
RegisterNetEvent("players:restrainFinish", function(name)
	Restraints:Start(name or true)
end)

RegisterNetEvent("players:restrainBegin", function()
	local success = exports.quickTime:Begin({ speed = 1.4, goalSize = 0.2 })
	if success then
		TriggerServerEvent("players:restrainResist")
	end
end)

--[[ Events ]]--
AddEventHandler("emotes:cancel", function(id)
	if Restraints.emote == id then
		Restraints.emote = nil
	end
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	if Restraints.items[item.name] then
		Restraints:UseItem(item, slot)

		cb()
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