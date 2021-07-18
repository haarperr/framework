local Escorting = false
local Escortee = false
local MessageReceived = false
local EscortType = 1
local EscortTypes = {
	[1] = {
		Offset = vector3(0.3, 0.6, 0.0),
		Rotation = vector3(0.0, 0.0, 0.0),
		Bone = -1,
		CanBreakOut = true,
	},
	[2] = {
		Offset = vector3(0.8, 0.4, -0.2),
		Rotation = vector3(-30.0, 90.0, 0.0),
		Bone = 57005,
		Anim = {
			Dict = "anim@heists@box_carry@",
			Name = "idle",
			Flag = 49,
			Escort = true,
			DisableCombat = true,
			DisableJumping = true,
		},
		TargetAnim = {
			Dict = "amb@world_human_bum_slumped@male@laying_on_right_side@base",
			Name = "base",
			Flag = 1,
			DisableMovement = true,
			DisableCarMovement = true,
			DisableCombat = true,
			DisableJumping = true,
			Escort = true,
		},
	},
	[3] = {
		Offset = vector3(-0.1, 0.05, 0.15),
		Rotation = vector3(25.0, 45.0, 180.0),
		Bone = 40269,
		Anim = {
			Dict = "misscarsteal4@meltdown",
			Name = "_rehearsal_camera_man",
			Flag = 49,
			Escort = true,
			DisableCombat = true,
			DisableJumping = true,
		},
		TargetAnim = {
			Dict = "nm",
			Name = "firemans_carry",
			Flag = 1,
			DisableMovement = true,
			DisableCarMovement = true,
			DisableCombat = true,
			DisableJumping = true,
			Escort = true,
		},
	},
	[4] = {
		Offset = vector3(-0.1, -0.2, 0.0),
		Rotation = vector3(0.0, 90.0, 0.0),
		Bone = 39317,
		Anim = {
			Dict = "move_f@hiking",
			Name = "base",
			Flag = 49,
			Escort = true,
			DisableCombat = true,
			DisableJumping = true,
		},
		TargetAnim = {
			Dict = "amb@code_human_in_bus_passenger_idles@male@sit@idle_b",
			Name = "idle_e",
			Flag = 1,
			DisableMovement = true,
			DisableCarMovement = true,
			DisableCombat = true,
			DisableJumping = true,
			Escort = true,
		},
	},
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if Escorting then
			local player = GetPlayerFromServerId(Escorting)
			local playerPed = GetPlayerPed(player)
			
			if
				(IsEntityAttached(playerPed) and not IsEntityAttachedToEntity(playerPed, PlayerPedId())) or
				IsPedInAnyVehicle(ped, true) or
				exports.health:IsPedDead(PlayerPedId())
			then
				StopEscorting()
			end

			if Escortee then
				StopBeingEscorted()
				return
			end
		end
		if Escortee then
			local escortConfig = EscortTypes[EscortType]
			if escortConfig.CanBreakOut and ((IsControlJustReleased(0, 76) and CanDo()) or not IsEntityAttached(ped)) then
				StopBeingEscorted()
			end
			if escortConfig.TargetAnim then
				local currentEmote = exports.emotes:GetCurrentEmote()
				if IsHandcuffed or exports.health:IsPedDead(PlayerPedId()) then
					StopBeingEscorted()
				elseif not currentEmote or not currentEmote.Escort then
					exports.emotes:PerformEmote(escortConfig.TargetAnim)
				end
			end
		end
		if not Escorting and not Escortee then
			if IsEntityAttachedToAnyPed(ped) then
				DetachSelf()
			end
			Citizen.Wait(500)
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
Messages["escort"] = function(source, message, value)
	local ped = PlayerPedId()
	if value then
		Escortee = source
		EscortType = value
		local otherPed = GetPlayerPed(GetPlayerFromServerId(source))
		local escortConfig = EscortTypes[value]

		AttachEntityToEntity(
			ped,
			otherPed,
			GetPedBoneIndex(otherPed, escortConfig.Bone or 0),
			escortConfig.Offset.x or 0.0,
			escortConfig.Offset.y or 0.0,
			escortConfig.Offset.z or 0.0,
			escortConfig.Rotation.x or 0.0,
			escortConfig.Rotation.y or 0.0,
			escortConfig.Rotation.z or 0.0,
			0,
			false, -- Soft pinning.
			true, -- Collision.
			true,
			0,
			true
		)

		SendMessage(source, "escort-response", value)
		SetEntityCollision(ped, false, false)

		if escortConfig.TargetAnim then
			exports.emotes:PerformEmote(escortConfig.TargetAnim)
		end
	else
		Escortee = false
		DetachSelf()
	end
end

Messages["escort-response"] = function(source, message, value)
	if value then
		MessageReceived = true
	else
		Escorting = false
		MessageReceived = false

		Citizen.Wait(0)

		exports.emotes:CancelEmote()
		ClearPedTasks(PlayerPedId())
	end
end

function IsBeingEscorted()
	return Escortee ~= false
end
exports("IsBeingEscorted", IsBeingEscorted)

function IsEscorting()
	return Escorting ~= false
end
exports("IsEscorting", IsEscorting)

function GetEscorting()
	return Escorting
end
exports("GetEscorting", GetEscorting)

function StopEscorting()
	if not Escorting then return end
	SendMessage(Escorting, "escort", false)
	Escorting = false

	Citizen.Wait(0)

	exports.emotes:CancelEmote()
	ClearPedTasks(PlayerPedId())
end
exports("StopEscorting", StopEscorting)

function StopBeingEscorted()
	if not Escortee then return end
	SendMessage(Escortee, "escort-response", false)
	DetachEntity(PlayerPedId(), true, false)
	Escortee = false

	Citizen.Wait(0)

	exports.emotes:CancelEmote()
	ClearPedTasks(PlayerPedId())
end
exports("StopBeingEscorted", StopBeingEscorted)

function Escort(_type)
	if Escortee then
		exports.mythic_notify:SendAlert("error", "You can't escort while being escorted!", 7000)
		return
	end
	if IsZiptied or IsHandcuffed then 
		exports.mythic_notify:SendAlert("error", "You can't escort while restrained!", 7000)
		return 
	end
	if not CanDo() and not Escorting then return end
	local player = GetPlayer(1.5)
	if player == 0 and not Escorting then NobodyNearby("escort") return end

	local playerPed = GetPlayerPed(GetPlayerFromServerId(player))
	local ped = PlayerPedId()
	local escortConfig = EscortTypes[_type]
	
	if not Escorting and (IsEntityAttached(playerPed) or (escortConfig.TargetAnim and DecorGetBool(playerPed, "IsHandcuffed"))) then
		return
	end
	
	MessageReceived = false
	SendMessage(player, "escort", _type)

	if Escorting then
		Escorting = false
		exports.emotes:CancelEmote()
	else
		Escorting = player
		EscortType = _type
		if escortConfig.Anim then
			exports.emotes:PerformEmote(escortConfig.Anim, function(finished)
				StopEscorting()
			end)
		end
	end
end

function DetachSelf()
	local ped = PlayerPedId()
	DetachEntity(ped, true, false)
	SetEntityCollision(ped, true, true)

	Citizen.Wait(0)

	exports.emotes:CancelEmote()
	ClearPedTasks(ped)
end

--[[ Commands ]]--
RegisterCommand("escort", function()
	Escort(1)

	-- Test.
	-- playerPed = exports.oldutils:GetNearestPed()

	-- local rot = GetEntityRotation(ped)

	-- AttachEntityToEntity(playerPed, ped, -1, 0.3, 0.8, 0.0, rot.y, 0.0, false, false, true, true, 0, true)
	-- ClearPedTasksImmediately(playerPed)
	-- Escorting = playerPed
end)

RegisterCommand("hold", function()
	Escort(2)
end)

RegisterCommand("carry", function()
	Escort(3)
end)

RegisterCommand("piggyback", function()
	Escort(4)
end)
