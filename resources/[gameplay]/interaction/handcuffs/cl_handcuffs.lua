local DisabledControls = { 22, 24, 25, 45, 44, 55, 59, 69, 70, 76, 86, 140, 141, 142, 257, 263, 264, 278, 279 }
local ShackledControls = { 21, 23 }
local Distance = 1.2
local Text = "handcuff"
IsHandcuffed = false
IsShackled = false
HandcuffTime = nil

DecorRegister("IsHandcuffed", 2)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not IsHandcuffed do
			Citizen.Wait(200)
		end

		local ped = PlayerPedId()

		for k, v in ipairs(DisabledControls) do
			DisableControlAction(0, v)
		end

		if IsHandcuffed then
			DisableControlAction(0,24)
			DisableControlAction(0,25)
		end
		
		if IsShackled then
			SetPedMoveRateOverride(ped, 0.8)
			for k, v in ipairs(ShackledControls) do
				DisableControlAction(0, v)
			end
		end

		if not exports.vehicles:IsInTrunk() and not exports.health:IsPedDead(PlayerPedId()) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
			UpdateCuffs()

			Citizen.Wait(200)
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		while IsHandcuffed or GetResourceState("jobs") ~= "started" do
			Citizen.Wait(200)
		end

		if exports.jobs:IsInGroup("Emergency") then
			local ped = PlayerPedId()
			
			if IsPedArmed(ped, 4) then
				local player = GetPlayer(Distance)
				local playerPed = GetPlayerPed(GetPlayerFromServerId(player))
				local coords = GetEntityCoords(playerPed)

				if DecorGetBool(playerPed, "IsHandcuffed") and exports.oldutils:DrawContext("Shackle", coords) then
					SendMessage(player, "shackle")
				end
			end
		else
			Citizen.Wait(2000)
		end
		
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
exports("IsHandcuffed", function()
	return IsHandcuffed == true
end)

Messages["handcuff"] = function(source, message, value)
	if not value then
		SetHandcuffed(false)
		exports.emotes:CancelEmote()

		return
	elseif IsHandcuffed and value then
		return
	end
	
	Citizen.CreateThread(function()
		HandcuffTime = GetGameTimer()

		exports.emotes:PerformEmote({
			Dict = "mp_arrest_paired",
			Name = "crook_p2_back_right"
		})
		
		TriggerEvent("disarmed")

		local result = nil
		local stunned = IsPedBeingStunned(PlayerPedId())

		if not stunned and not (GetResourceState("health") == "started" and exports.health:IsPedDead(PlayerPedId())) then
			TriggerEvent("quickTime:begin", "linear", GetRandomFloatInRange(10.0, 15.0), function(status)
				result = status
			end)
		else
			result = false
		end
		
		while result == nil do
			Citizen.Wait(20)
		end
		
		if result then
			SetHandcuffed(false)
			SendMessage(source, "handcuff-breakout", true)

			exports.emotes:CancelEmote()
		else
			SetHandcuffed(true)
			UpdateCuffs()
		end
	end)
end

Messages["shackle"] = function(source, message, value)
	IsShackled = not IsShackled
	SendMessage(source, "shackle-response", IsShackled)
	local walkStyle
	if IsShackled then
		walkStyle = "armored"
	end
	exports.emotes:SetCustomWalkStyle(walkStyle)
end

Messages["shackle-response"] = function(source, message, value)
	local message
	if value then
		message = "Shackles tightened!"
	else
		message = "Shackled loosened!"
	end
	exports.mythic_notify:SendAlert("inform", message, duration)
end

Items["Handcuffs"] = function()
	return CanUse(Distance, Text)
end

Items["Handcuff Keys"] = function()
	return CanUse(Distance, Text)
end

function UpdateCuffs()
	exports.emotes:PerformEmote({
		Dict = "mp_arresting",
		Name = "idle",
		Props = {
			{ Model = "p_cs_cuffs_02_s", Bone = 28422, Offset = { -0.03, 0.07, 0.0, 90.0, 0.0, 90.0 }},
		},
		Flag = 49,
		BlendSpeed = 100.0,
		Handcuffs = true,
	})
end

function CanHandcuff(player)
	if not player then return false end
	local ped = PlayerPedId()
	local playerPed = GetPlayerPed(GetPlayerFromServerId(player))
	if not DoesEntityExist(playerPed) then return false end

	if IsPedRagdoll(playerPed) then
		return true
	end

	local pedForward = GetEntityForwardVector(ped)
	local playerForward = GetEntityForwardVector(playerPed)
	return exports.misc:Dot(pedForward, playerForward) > 0.5 and exports.misc:Dot(exports.misc:Normalize(GetEntityCoords(playerPed) - GetEntityCoords(ped)), playerForward) > 0.5
end

function SetHandcuffed(value)
	IsHandcuffed = value
	IsShackled = false
	exports.emotes:SetCustomWalkStyle(nil)
	DecorSetBool(PlayerPedId(), "IsHandcuffed", value)
end
exports("SetHandcuffed", SetHandcuffed)

--[[ Items ]]--
RegisterNetEvent("inventory:use_Handcuffs")
AddEventHandler("inventory:use_Handcuffs", function()
	local player = GetPlayer()
	if player == 0 then return end
	if not CanHandcuff(player) then return end
	
	if DecorGetBool(playerPed, "IsHandcuffed") then
		return
	end
	
	SendMessage(player, "handcuff", true)

	exports.emotes:PerformEmote({
		Dict = "mp_arrest_paired",
		Name = "cop_p2_back_right",
		Duration = 3000,
	})
end)

RegisterNetEvent("inventory:use_HandcuffKeys")
AddEventHandler("inventory:use_HandcuffKeys", function()
	local player = GetPlayer()
	if player == 0 then return end
	if not CanHandcuff(player) then return end
	
	exports.emotes:PerformEmote({
		Dict = "mp_arresting",
		Name = "a_uncuff",
		Duration = 3000,
	})

	Citizen.Wait(3000)
	
	SendMessage(player, "handcuff", false)
end)

RegisterNetEvent("inventory:use_Lockpick")
AddEventHandler("inventory:use_Lockpick", function()
	local player = GetPlayer(2.0)
	if player == 0 then return end
	if not CanHandcuff(player) then return end

	local playerPed = GetPlayerPed(GetPlayerFromServerId(player))
	if not DoesEntityExist(playerPed) then return false end

	if not DecorGetBool(playerPed, "IsHandcuffed") then
		return
	end

	exports.mythic_progbar:Progress({
		Anim = {
			Dict = "missmechanic",
			Name = "work2_base",
			Flag = 49,
			Props = {
				{ Model = "prop_tool_screwdvr01", Bone = 60309, Offset = { 0.0, 0.0, -0.1, 0.0, 0.0, 0.0 }},
			},
			DisableMovement = true,
		},
		Label = "Lockpicking Handcuffs...",
		Duration = 10000,
		UseWhileDead = false,
		DisableMovement = true,
		DisableCarMovement = true,
		CanCancel = true,
		Disarm = true,
	}, function(wasCancelled)
		if wasCancelled then return end

		if player == GetPlayer(2.0) then
			SendMessage(player, "handcuff", false)
		end
	end)
end)