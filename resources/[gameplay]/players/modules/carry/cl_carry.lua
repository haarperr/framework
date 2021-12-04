Carry = Carry or {}

--[[ Functions ]]--
function Carry:Send(id)
	if not Main.serverId or not self:CanCarry() then return end

	-- Trigger event.
	TriggerServerEvent("players:carryBegin", Main.serverId, id)
end

function Carry:Activate(direction, target, id)
	local ped = PlayerPedId()
	local state = (LocalPlayer or {}).state or {}

	-- Get player.
	local player = GetPlayerFromServerId(target)
	local playerPed = GetPlayerPed(player)
	
	-- Check player ped.
	if not DoesEntityExist(playerPed) or playerPed == ped then return end

	-- Get mode.
	local mode = self.modes[id]
	if not mode then return end

	-- Attach source to target.
	if direction == "Target" then
		local attach = mode.Attachment
		local boneIndex = GetPedBoneIndex(playerPed, attach.Bone)
		local pos = attach.Offset
		local rot = attach.Rotation

		AttachEntityToEntity(ped, playerPed, boneIndex, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, false, false, false, true, 0, true)
	end

	-- Add option.
	exports.interact:AddOption({
		id = "carryEnd",
		text = direction == "Target" and "Break-out" or "Drop",
		icon = "pan_tool",
	})

	-- Cache stuff.
	self.mode = mode
	self.player = player
	self.ped = playerPed

	-- Play animation.
	local anim = mode[direction]
	if anim then
		self:SetAnim(anim)
	end
end

function Carry:Update()
	local mode = self.mode
	if not mode then return end

	local ped = PlayerPedId()
	local playerPed = self.ped
	local state =  (LocalPlayer or {}).state
	
	if not playerPed or not state then return end

	-- Check emote.
	if self.anim and self.emote and not exports.emotes:IsPlaying(self.emote) then
		self:SetAnim(self.anim)
	end

	-- Check carry.
	if
		(playerPed and (not DoesEntityExist(playerPed) or IsPedRagdoll(playerPed))) or
		IsPedInAnyVehicle(ped) or
		(state.immobile and not mode.Immobile) or
		state.restrained
	then
		TriggerServerEvent("players:carryEnd")
	end
end

function Carry:UpdateInput()
	if not self.mode then return end

	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end
end

function Carry:Deactivate()
	local ped = PlayerPedId()

	-- Detach entity.
	if IsEntityAttachedToAnyPed(ped) then
		DetachEntity(ped, true, false)
		SetEntityCollision(ped, true, true)
	end

	-- Clear cache.
	self.mode = nil
	self.anim = nil
	self.player = nil
	self.ped = nil

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end

	-- Remove navigation option.
	exports.interact:RemoveOption("carryEnd")
end

function Carry:SetAnim(anim)
	self.anim = anim
	self.emote = exports.emotes:Play(anim)
end

function Carry:CanCarry()
	local state = (LocalPlayer or {}).state
	if not state then return false end

	local ped = PlayerPedId()

	return (
		not IsPedRagdoll(ped) and
		not state.immobile and
		not state.restrained
	)
end

--[[ Options ]]--
local sub = {}
for k, v in pairs(Carry.modes) do
	local event = "player-"..k
	if k ~= "carry" then
		sub[#sub + 1] = {
			id = "player-"..k,
			text = v.Name,
			icon = "luggage",
		}
	end

	AddEventHandler("interact:onNavigate_"..event, function(option)
		Carry:Send(k)

		TriggerServerEvent("players:carryEnd")
	end)
end

Main:AddOption({
	id = "player-carry",
	text = "Carry",
	icon = "luggage",
	sub = sub,
})

--[[ Events: Net ]]--
RegisterNetEvent("players:carry", function(direction, target, id)
	if id then
		Carry:Activate(direction, target, id)
	else
		Carry:Deactivate()
	end
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate_carryEnd", function()
	TriggerServerEvent("players:carryEnd")
end)

AddEventHandler("interact:onNavigate_forcePlayer", function()
	TriggerServerEvent("players:force")
end)

AddEventHandler("interact:navigate", function(value)
	if not value then
		if Carry.force then
			exports.interact:RemoveOption("forcePlayer")
			Carry.force = nil
		end

		return
	end

	local state = (LocalPlayer or {}).state
	if not state or not state.carrying then return end

	exports.interact:AddOption({
		id = "forcePlayer",
		text = "Force",
	})

	Carry.force = true
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Carry:Update()
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		Carry:UpdateInput()
		Citizen.Wait(0)
	end
end)