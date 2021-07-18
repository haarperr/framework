BodyPartsCache = {}
Debug = false
LastBloodLoss = 0.0
LastClothing = {}
LastInjuryEvents = {}
LastNotify = 0
LastReported = 0
LastWeaponUsed = nil
RequestingInjuries = false
ShouldUpdate = true
TotalLegDamage = 0.0

Info = {
	bones = {},
	bloodLoss = 0.0,
	isHemorrhaging = false,
}

--[[ Initialization ]]--
for bone, info in pairs(Config.BodyParts) do
	if info.Fallback == nil then
		BodyPartsCache[#BodyPartsCache + 1] = bone
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		
		local player = PlayerId()
		local ped = PlayerPedId()
		
		while IsPedDead(ped) do
			ped = PlayerPedId()

			if GetGameTimer() - LastReported > 60000 then
				exports.peds:AddEvent("downed")
				LastReported = GetGameTimer()
			end
			
			Citizen.Wait(200)
		end

		SetPlayerHealthRechargeMultiplier(player, 0.0)
		SetPedMaxHealth(ped, 1000)

		ShouldUpdate = false

		ProcessGeneralInjury()
		ProcessHeadInjury()
		ProcessLegInjury()
		ProcessWaterInjury()
		ProcessWalkStyle()
		ProcessNotifications()

		if ShouldUpdate then
			UpdateInfo()
		end
	end
end)

-- Debug.
Citizen.CreateThread(function()
	if not Debug then return end

	Citizen.Wait(200)
	
	UpdateInfo()

	-- SetPedArmour(PlayerPedId(), 10)
	-- SetPedMaxHealth(PlayerPedId(), 1000)
	-- SetEntityHealth(PlayerPedId(), 1000)

	-- Add all effects.
	-- for k, v in pairs(Config.Effects) do
	-- 	AddEffect(k, 1.0)
	-- end

	-- -- Get concussed.
	-- TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", {
	-- 	PlayerPedId(), PlayerPedId(), 0, 0, GetHashKey("WEAPON_FALL"), 31086
	-- })

	-- Get shot.
	-- for k, v in ipairs({24818, 11816, 36864, 36864}) do
	-- 	SetEntityHealth(PlayerPedId(), 960)
	-- 	TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", {
	-- 		PlayerPedId(), PlayerPedId(), 0, 0, GetHashKey("WEAPON_PISTOL"), v
	-- 	})
	-- 	Citizen.Wait(0)
	-- end

	-- Get hit.
	-- for k, v in ipairs({24818}) do
	-- 	SetEntityHealth(PlayerPedId(), 500)
	-- 	TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", {
	-- 		PlayerPedId(), PlayerPedId(), 0, 0, GetHashKey("WEAPON_KNUCKLE"), v
	-- 	})
	-- 	Citizen.Wait(0)
	-- end

	-- Get shot, alot.
	-- for i = 1, 4 do
	-- 	SetEntityHealth(PlayerPedId(), 980)
	-- 	TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", {
	-- 		PlayerPedId(), PlayerPedId(), 0, 0, GetHashKey("WEAPON_PISTOL"), 24818
	-- 	})
	-- end

	-- Get hurt in the leg by fall.
	-- SetEntityHealth(PlayerPedId(), 920)
	-- TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", {
	-- 	PlayerPedId(), PlayerPedId(), 0, 0, GetHashKey("WEAPON_FALL"), 63931
	-- })

	-- SetEntityHealth(PlayerPedId(), 850)
	-- TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", {
	-- 	PlayerPedId(), PlayerPedId(), 0, 0, GetHashKey("WEAPON_FALL"), 36864
	-- })
end)

--[[ Functions: Processing ]]--
function ProcessGeneralInjury()
	-- Bleeding and hemorrhaging.
	Info.isHemorrhaging = false
	
	LastBloodLoss = 0.0
	TotalLegDamage = 0.0

	for bone, info in pairs(Info.bones) do
		local bodyPart = Config.BodyParts[bone]
		-- Clotting.
		local clotted = info.clotted or 0.0
		local clot = math.max(1.0 - clotted, 0.0)
		if clotted > 0 then
			clotted = clotted - Config.Bleeding.UnclotRate
			info.clotted = clotted
		end
		-- Bleeding.
		local bleed = info.bleed or 0.0
		if bleed > 0 then
			if info.damage <= 0.99 then
				DamageBone(bone, 0.01)
			end
			if info.hemorrhaging and info.hemorrhaging > 0.0 then
				bleed = math.min(bleed + info.hemorrhaging * clot, 1.0)
				Info.isHemorrhaging = true
				if Debug then
					print("hemorrhaging", info.hemorrhaging)
				end
			else
				bleed = math.max(bleed - Config.Bleeding.ClotRate * GetRandomFloatInRange(math.min(clotted, 1.0), 1.0), 0.0)
			end
			info.bleed = bleed
			LastBloodLoss = LastBloodLoss + bleed * clot
			ShouldUpdate = true
		end
		-- Foot stuff.
		if bodyPart.Limp then
			TotalLegDamage = TotalLegDamage + bodyPart.Limp * (info.damage or 0.0)
		end
		if info.damage < Config.Healing.MaxDamage and info.damage >= 0.001 then
			local amount = Config.Healing.Amount
			local comfort = GetEffect("Comfort")

			if comfort > 0.001 then
				local min, max = table.unpack(Config.Modifiers.Healing)
				amount = amount * ((max - min) * comfort + min)
			end
			
			info.damage = math.max(info.damage - amount, 0.0)
			ShouldUpdate = true
		end
	end

	-- Blood loss.
	-- print(("Blood loss: %s	Last blood loss: %s"):format(BloodLoss, LastBloodLoss))
	Info.bloodLoss = (Info.bloodLoss or 0.0) + LastBloodLoss

	if Debug then
		print("blood loss", Info.bloodLoss, "last blood loss", LastBloodLoss)
	end
	
	if Info.bloodLoss > 1.0 then
		Slay()
	else
		Info.bloodLoss = math.max(Info.bloodLoss - Config.Bleeding.HealRate, 0.0)
	end

	if Info.bloodLoss > 0.01 then
		SetTimecycleModifier("li")
		SetTimecycleModifierStrength(Info.bloodLoss)
	end
end

function ProcessHeadInjury()
	if GetGameTimer() - (LastInjuryEvents.Head or 0) < 8000 then return end
	LastInjuryEvents.Head = GetGameTimer()

	local ped = PlayerPedId()

	-- Head injuries.
	local headBone = 31086
	local head = Info.bones[headBone]
	if head then
		local concussion = head.concussion or 0.0

		-- Healing.
		if concussion > 0.001 and GetRandomFloatInRange(0.0, 1.0) < Config.Concussions.HealChance then
			concussion = math.max(concussion - Config.Concussions.HealAmount, 0.0)
			if concussion <= 0.001 then
				exports.mythic_notify:SendAlert("error", "Your head feels clear again.", 7000)
				concussion = 0.0
			end
			head.concussion = concussion
		end

		-- Passing out.
		if concussion > Config.Concussions.PassoutThreshold and GetRandomFloatInRange(0.0, 1.0) < Config.Concussions.PassoutChance * concussion then
			exports.mythic_notify:SendAlert("error", "Your head is pulsing...", 7000)
			AnimpostfxPlay("CamPushInMichael", 3000, true)
			DamageBone(headBone, Config.Concussions.DamageAmount * concussion)
			UpdateInfo()
			CheckBones()

			if IsPedDead(ped) then
				return
			end

			Citizen.Wait(3000)

			local ragdollTime = 500
			local ragdollType = 0
			local alert = nil
			local isJumping = IsPedJumping(ped)

			if IsPedWalking(ped) and not isJumping then
				ragdollTime = 500
				ragdollType = 2
				alert = "You almost pass out..."
			elseif IsPedRunning(ped) and not isJumping then
				ragdollTime = 750
				ragdollType = 2
				alert = "Your mind is becoming hazy..."
			elseif IsPedSprinting(ped) or isJumping then
				ragdollTime = 2000
				ragdollType = 3
				alert = "Your mind goes blank for a second..."
			else
				alert = "You're having trouble staying conscious..."
			end

			ShakeGameplayCam("JOLT_SHAKE", 1.0)
			SetPedToRagdoll(ped, ragdollTime, 0, ragdollType, true, true, false)

			if alert then
				exports.mythic_notify:SendAlert("error", alert, 7000)
			end
		end
	end
end

function ProcessLegInjury()
	local ped = PlayerPedId()
	local isJumping = IsPedJumping(ped)

	if IsPedSprinting(ped) or isJumping then
		local shouldUpdate = false
		local damage = Config.Limping.SprintingDamage

		-- Bone damage.
		if isJumping then
			damage = damage * Config.Limping.JumpingDamage
		end

		for bone, info in pairs(Info.bones) do
			local bodyPart = Config.BodyParts[bone]
			if (bodyPart.Limp or 0.0) > 0.01 and (info.damage or 0.0) > 0.1 then
				DamageBone(bone, damage, "blunt")
				SpreadDamage(bone, damage, 0.8)
				shouldUpdate = true
			end
		end
		if shouldUpdate then
			CheckBones()
			UpdateInfo()

			if GetGameTimer() - LastNotify > 7000 then
				exports.mythic_notify:SendAlert("error", "You feel a sharp pain in your lower body!", 5000)
				LastNotify = GetGameTimer()
			end
		end
	end

	-- Staggering.
	if GetGameTimer() - (LastInjuryEvents.Stagger or 0) > 8000 then
		LastInjuryEvents.Stagger = GetGameTimer()

		if TotalLegDamage > 0.01 and GetRandomFloatInRange(0.0, 1.0) < Config.Limping.StaggerChance * TotalLegDamage then
			local alert, ragdollTime, ragdollType

			if (IsPedSprinting(ped) or IsPedRunning(ped) or isJumping) and TotalLegDamage > 1.0 then
				ragdollTime = 4000
				ragdollType = 0
				alert = "You have trouble standing..."
			elseif IsPedRunning(ped) or isJumping then
				ragdollTime = 500
				ragdollType = 2
				alert = "You have trouble keeping balance..."
			end
			
			if ragdollType then
				ShakeGameplayCam("JOLT_SHAKE", 1.0)
				SetPedToRagdoll(ped, ragdollTime, 0, ragdollType, true, true, false)
				exports.mythic_notify:SendAlert("error", alert, 7000)
			end
		end
	end
end

function ProcessWalkStyle()
	local walkStyle = nil
	local bloodLoss = Info.bloodLoss
	if bloodLoss > 0.7 then
		walkStyle = "drunk3"
	elseif bloodLoss > 0.4 then
		walkStyle = "drunk2"
	elseif bloodLoss > 0.1 then
		walkStyle = "drunk"
	elseif TotalLegDamage > Config.Limping.InjuredDamage then
		walkStyle = "injured"
	end
	if walkStyle then
		exports.emotes:SetCustomWalkStyle(walkStyle)
	end
end

function ProcessNotifications()
	if GetGameTimer() - LastNotify < 12000 then
		return
	end

	-- Notifications.
	local notify = nil
	local bloodLoss = Info.bloodLoss

	if bloodLoss > 0.9 then
		notify = "are having trouble staying conscious..."
	elseif bloodLoss > 0.8 then
		notify = "feel very weak..."
	elseif bloodLoss > 0.6 then
		notify = "feel very light headed..."
	elseif bloodLoss > 0.4 then
		notify = "feel a little weak!"
	elseif bloodLoss > 0.2 then
		notify = "feel light headed..."
	end

	if LastBloodLoss and LastBloodLoss >= 0.001 then
		if notify then
			notify = " and you "..notify
		else
			notify = "!"
		end
		if Info.isHemorrhaging then
			notify = "Blood is gushing from your wounds"..notify
		else
			notify = "You are bleeding from your wounds"..notify
		end
	elseif notify then
		notify = "You "..notify
	end
	
	if notify then
		LastNotify = GetGameTimer()
		exports.mythic_notify:SendAlert("error", notify, 7000)
	end
end

function ProcessWaterInjury()
	local ped = PlayerPedId()
	local isDiving = IsPedSwimmingUnderWater(ped)

	if isDiving then
		SetPedDiesInWater(ped, false)
		if GetEffect("Scuba") < 0.0001 then
			AddEffect("Oxygen", 0.1)
		end
	end
end

--[[ Functions ]]--
function TakeDamage(amount, bone, weapon)
	SetEntityHealth(PlayerPedId(), 1000 - amount)
	TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", { PlayerPedId(), PlayerPedId(), 0, 0, 0, bone or 0, weapon })
end
exports("TakeDamage", TakeDamage)

function ArmorUp(amount, _type, ignoreComponent)
	local bones
	local ped = PlayerPedId()
	local gender = exports.character:Get("gender")
	if _type == 1 then
		bones = { 24817, 24818, 64729, 10706, 11816, 40269, 45509 }
		if gender == 0 then
			SetPedComponentVariation(ped, 9, 109, 2, 0)
		else
			SetPedComponentVariation(ped, 9, 105, 2, 0)
		end
	elseif _type == 2 then
		bones = { 31086 }
		if gender == 0 then
			SetPedPropIndex(ped, 0, 118, 0, true)
		else
			SetPedPropIndex(ped, 0, 119, 0, true)
		end
	else
		bones = { 24817, 24818, 64729, 10706 }
		-- SetPedComponentVariation(ped, 9, 2, 1, 0)
	end
	for _, bone in ipairs(bones) do
		local boneInfo = Info.bones[bone]
		local boneSettings = Config.BodyParts[bone]
		if not boneInfo then
			boneInfo = {
				injuries = {},
				damage = 0.0,
			}
			Info.bones[bone] = boneInfo
		end
		boneInfo.armor = math.min((boneInfo.armor or 0.0) + amount, boneSettings.MaxArmor or 1.0)
	end
	UpdateInfo()
end
exports("ArmorUp", ArmorUp)

function ClearArmor()
	for bone, info in pairs(Info.bones) do
		info.armor = nil
	end
	UpdateInfo()
end
exports("ClearArmor", ClearArmor)

function HealPed()
	local ped = PlayerPedId()
	local health = GetPedMaxHealth(ped)
	SetEntityHealth(ped, health)

	for boneId, boneInfo in pairs(Info.bones) do
		local armor = boneInfo.armor
		if armor and armor > 0.001 then
			boneInfo = { armor = armor, damage = 0.0 }
		else
			boneInfo = nil
		end
		Info.bones[boneId] = boneInfo
	end

	Info.bloodLoss = 0.0
	Info.isHemorrhaging = false

	ClearEffects()
	-- UpdateInfo()
	
	ResetExtraTimecycleModifierStrength()
	SetExtraTimecycleModifierStrength(0.0)
	SetTimecycleModifierStrength(0.0)
	
	exports.emotes:SetCustomWalkStyle(nil)
end
exports("HealPed", HealPed)

function HealPartial(amount)
	local ped = PlayerPedId()
	local health = GetPedMaxHealth(ped)
	SetEntityHealth(ped, health)

	Info.isHemorrhaging = false
	Info.bloodLoss = math.max((Info.bloodLoss or 0.0) - amount, 0.0)

	local totalDamage = 0.0

	for bone, info in pairs(Info.bones) do
		if info.damage and info.damage > 0.001 then
			info.damage = math.max(info.damage - amount, 0.0)
			info.bleed = math.max((info.bleed or 0.0) - amount, 0.0)
			totalDamage = totalDamage + info.damage
		end
	end

	if totalDamage < 0.05 then
		if IsDead then
			ResurrectPed()
		else
			HealPed()
		end
	end

	UpdateInfo()
end
exports("HealPartial", HealPartial)

function UpdateInfo(check, target, info)
	local player = PlayerId()
	local ped = PlayerPedId()
	local dead = false

	if target == nil then
		dead = IsPedDead(ped)
	else
		if info == nil then return end
		player = GetPlayerFromServerId(target)
		ped = GetPlayerPed(player)
	end

	if not DoesEntityExist(ped) then return end

	if check then
		SetNuiFocus(true, true)
		SetNuiFocusKeepInput(false)
	end
	
	SendNUIMessage({
		info = info or Info,
		check = check,
		dead = dead,
	})
end
exports("UpdateInfo", UpdateInfo)

function GetDamageValue()
	local value = 0.0
	for bone, info in pairs(Info.bones) do
		value = value + info.damage
	end
	return value
end
exports("GetDamageValue", GetDamageValue)

function Impact(intensity)
	local bones = { 31086, 24818, 24817, 11816 }
	local bone = bones[GetRandomIntInRange(1, #bones)]

	intensity = intensity or GetRandomFloatInRange(0.0, 1.0)
	
	if intensity > 0.2 then
		SetFlash(0, 0, 500, 0, 1000)
	end

	ShakeGameplayCam("JOLT_SHAKE", 3.0 * intensity)
	TakeDamage(math.floor(intensity * 30), bone, "WEAPON_FALL")

	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < math.ceil(2000 * intensity) do
			for k, v in ipairs({ 21, 22, 23, 24, 25, 26, 71, 72, 73, 75, 86, 87, 88, 89, 90, 91, 92, 102 }) do
				DisableControlAction(0, v)
			end
			Citizen.Wait(0)
		end
	end)
end
exports("Impact", Impact)

function Bandage()
	local effective = false
	for bone, info in pairs(Info.bones) do
		if info.damage and info.damage > 0.5 and info.damage < Config.Healing.MaxDamage then
			info.damage = math.max(info.damage - GetRandomFloatInRange(Config.Bandaging.InstantHealth[1], Config.Bandaging.InstantHealth[2]), 0.0)
			effective = true
		end
		local clotted = info.clotted or 0.0
		if clotted < 1.5 then
			effective = true
		end
		clotted = clotted + (1.0 / (clotted + 1.0))
		info.clotted = clotted
	end
	if effective then
		exports.mythic_notify:SendAlert("success", "That seems to be helping!", 7000)
	else
		exports.mythic_notify:SendAlert("error", "It doesn't seem to be helping...", 7000)
	end
	UpdateInfo()
end

function Gauze()
	local effective = false
	for bone, info in pairs(Info.bones) do
		if info.bleed and info.bleed > 0.05 then
			effective = true
			info.bleed = math.max(info.bleed - 0.1, 0.0)
		end
		if info.hemorrhaging and info.hemorrhaging > 0.0 then
			info.hemorrhaging = info.hemorrhaging - 0.5
			if info.hemorrhaging <= 0.0 then
				info.hemorrhaging = nil
			end
			effective = true
		end
		info.clotted = math.max((info.clotted or 0.0), 0.5)
	end
	if effective then
		exports.mythic_notify:SendAlert("success", "That seems to be helping!", 7000)
	else
		exports.mythic_notify:SendAlert("error", "It doesn't seem to be helping...", 7000)
	end
	UpdateInfo()
end

function IFAK()
	for bone, info in pairs(Info.bones) do
		if info.bleed then
			info.bleed = 0.0
		end
		if info.hemorrhaging then
			info.hemorrhaging = 0.0
		end
		if (info.damage or 0.0) > 0.1 then
			info.damage = math.max(info.damage - 0.5, 0.1)
		end
		info.clotted = 1.0
	end
	exports.mythic_notify:SendAlert("success", "You feel so much better!", 7000)
	UpdateInfo()
end

-- Clothing Option - 1 = Component.
function Rebreather()
	AddEffect("Scuba", 0.5)

	local ped = PlayerPedId()
	SetPedComponentVariation(ped, 1, 258, 0, 0)
end

function ScubaGear()
	AddEffect("Scuba", 1.0)

	local ped = PlayerPedId()
	if IsPedModel(ped, GetHashKey("mp_f_freemode_01")) then
		SetPedComponentVariation(ped, 8, 271, 0, 0) -- Undershirt.
	elseif IsPedModel(ped, GetHashKey("mp_m_freemode_01")) then
		SetPedComponentVariation(ped, 8, 235, 0, 0) -- Undershirt.
	end
end

function Badge()
	UpdateInfo()
end

function Cyanide()
	AddEffect("Poison", 1.0)
	Slay()
	
	exports.mythic_notify:SendAlert("success", "You fade into black...", 7000)
	UpdateInfo()
end

function Oxycodone()
	AddEffect("Armor", GetRandomFloatInRange(0.4, 0.9))
	AddEffect("Comfort", 0.8)
	AddEffect("Drug", 0.7)
	AddEffect("Thirst", 0.3)
	
	exports.emotes:SetCustomWalkStyle(nil)
	exports.mythic_notify:SendAlert("success", "You feel at peace...", 7000)

	UpdateInfo()
end

function Hydrocodone()
	AddEffect("Armor", GetRandomFloatInRange(0.5, 0.8))
	AddEffect("Comfort", 0.7)
	AddEffect("Drug", 0.6)
	AddEffect("Thirst", 0.2)

	exports.emotes:SetCustomWalkStyle(nil)
	exports.mythic_notify:SendAlert("success", "You feel at peace...", 7000)
end

function CrackPipe()
	exports.emotes:SetCustomWalkStyle("hobo")

	AddEffect("Thirst", 0.4)
	AddEffect("Drug", GetRandomFloatInRange(0.1, 0.3))
	AddEffect("Comfort", GetRandomFloatInRange(0.4, 0.6))
end

function PeyoteChunk()
	AddEffect("Thirst", 0.4)
	AddEffect("Drug", GetRandomFloatInRange(0.4, 0.6))
	AddEffect("Comfort", 0.3)
	
	exports.emotes:SetCustomWalkStyle("drunk")
	exports.mythic_notify:SendAlert("success", "You feel very self-aware...", 7000)
end

function KetamineSyringe()
	AddEffect("Thirst", 0.2)
	AddEffect("Hunger", 0.2)
	AddEffect("Drug", 0.5)
	AddEffect("Comfort", 0.3)

	exports.emotes:SetCustomWalkStyle("quick")
	exports.mythic_notify:SendAlert("success", "You feel very energetic...", 7000)
end

function HeroinSyringe()
	AddEffect("Thirst", 0.2)
	AddEffect("Hunger", 0.2)
	AddEffect("Drug", GetRandomFloatInRange(0.2, 0.4))
	AddEffect("Comfort", GetRandomFloatInRange(0.5, 1.0))

	exports.emotes:SetCustomWalkStyle(nil)
	exports.mythic_notify:SendAlert("success", "You feel at peace...", 7000)
end

function ChinaWhiteSyringe()
	AddEffect("Armor", GetRandomFloatInRange(0.2, 0.6))
	AddEffect("Thirst", 0.4)
	AddEffect("Hunger", 0.4)
	AddEffect("Drug", 0.6)
	AddEffect("Comfort", 0.5)

	exports.emotes:SetCustomWalkStyle(nil)
end

function Lean()
	AddEffect("Thirst", 0.4)
	AddEffect("Drug", GetRandomFloatInRange(0.3, 0.5))
	AddEffect("Comfort", 0.3)

	exports.emotes:SetCustomWalkStyle("drunk")
end

function LSD()
	exports.emotes:SetCustomWalkStyle("lemar")

	AddEffect("Thirst", 0.4)
	AddEffect("Drug", GetRandomFloatInRange(0.1, 0.3))
	AddEffect("Comfort", 0.1)
end

function MedicinalJoint()
	exports.mythic_notify:SendAlert("success", "You feel your pain easing!", 7000)
	exports.emotes:SetCustomWalkStyle(nil)

	AddEffect("Thirst", 0.3)
	AddEffect("Hunger", 0.3)
	AddEffect("Comfort", GetRandomFloatInRange(0.4, 0.8))
end

function Edible()
	for bone, info in pairs(Info.bones) do
		if info.damage then
			info.damage = math.max(info.damage - 0.1, 0.25)
		end
	end
	exports.mythic_notify:SendAlert("success", "You feel your pain easing!", 7000)
	exports.emotes:SetCustomWalkStyle(nil)

	AddEffect("Hunger", 0.4)
	AddEffect("Comfort", GetRandomFloatInRange(0.1, 0.3))
end

function LesserEdible()
	exports.mythic_notify:SendAlert("success", "You start to feel less stressed!", 7000)

	AddEffect("Hunger", 0.4)
	AddEffect("Armor", GetRandomFloatInRange(0.1, 0.3))
	AddEffect("Comfort", 0.1)
end

function Bong()
	exports.emotes:SetCustomWalkStyle("hobo")
	AddEffect("Thirst", 0.25)
end

function PureCocaine()
	exports.mythic_notify:SendAlert("error", "You feel unexplainably weird..", 7000)

	AddEffect("Thirst", 0.7)
	AddEffect("Drug", GetRandomFloatInRange(0.6, 1.0))
end

function DamageBone(bone, damage, injury)
	local bodyPart = Config.BodyParts[bone]
	if not bodyPart then return end
	
	if not Info.bones[bone] then
		Info.bones[bone] = {}
		Info.bones[bone].injuries = {}
	end

	local boneInfo = Info.bones[bone]
	local boneDamage = boneInfo.damage or 0

	if boneInfo.armor and boneInfo.armor > 0.0 then
		boneInfo.armor = boneInfo.armor - damage
		if boneInfo.armor <= 0.0 then
			boneInfo.armor = nil
		else
			damage = 0.0
		end
	end

	boneDamage = math.max(boneDamage + damage, 0.0)
	boneInfo.damage = boneDamage

	local clotted = boneInfo.clotted
	if clotted ~= nil and clotted > 0 then
		clotted = math.max(clotted - damage, 0.0)
		boneInfo.clotted = clotted

		if Debug then
			print("Clotted limb took damage", clotted)
		end
	end

	if injury then
		local injuryInfo = Config.Injuries[injury]
		
		if not boneInfo.injuries[injury] then
			boneInfo.injuries[injury] = {
				occurrences = {}
			}
		end
		
		local injuries = boneInfo.injuries[injury]
		injuries.totalDamage = (injuries.totalDamage or 0.0) + boneDamage

		local occurrence = {
			time = GetGameTimer(),
			damage = boneDamage,
		}

		if injury == "gsw" then
			local ammo = exports.weapons:GetAmmo(LastWeaponUsed)
			occurrence.show = true
			occurrence.text = ("%s (%s)"):format(injuryInfo.Name, ammo)
		elseif injuryInfo.UseIntensity then
			for k, intensity in ipairs(Config.Intensities) do
				if injuries.totalDamage >= intensity[1] then
					injuries.text = intensity[2]:format(injuryInfo.Name)
					break
				end
			end
		else
			injuries.text = injuryInfo.Name
		end

		table.insert(injuries.occurrences, occurrence)

		-- table.insert(boneInfo.injuries, injuries)

		if type(injury) == "string" then
			local injuryInfo = Config.Injuries[injury] or {}
			boneInfo.bleed = (boneInfo.bleed or 0.0) + (injuryInfo.Bleed or 0.0) * damage

			-- Hemorrhaging.
			if injuryInfo.Hemorrhaging and injuryInfo.HemorrhagingChance > GetRandomFloatInRange(0.0, 1.0) * damage then
				boneInfo.hemorrhaging = (boneInfo.hemorrhaging or 0.0) + (injuryInfo.Hemorrhaging or 1.0) * damage
			end
			-- Concussions.
			if bodyPart.Concussion and injuryInfo.Concussion then
				boneInfo.concussion = (boneInfo.concussion or 0.0) + injuryInfo.Concussion * damage
			end
		end
	end
end

function SpreadDamage(bone, damage, spread)
	local bodyPart = Config.BodyParts[bone]
	if not bodyPart.Nearby then return end
	for k, v in ipairs(bodyPart.Nearby) do
		DamageBone(v, damage * spread)
	end
end

function CheckBones()
	local fatal = 0.0

	for bone, info in pairs(Info.bones) do
		local bodyPart = Config.BodyParts[bone]
		fatal = fatal + info.damage * (bodyPart.Fatal or 0.0)
	end
	
	if fatal >= 0.999 then
		Slay()
		return true
	end
	return false
end

function RandomBone()
	return BodyPartsCache[GetRandomIntInRange(1, #BodyPartsCache)]
end

local function RegisterItems()
	exports.inventory:RegisterAction("Bandage", Config.Bandaging.Action)
	exports.inventory:RegisterAction("Gauze", Config.Gauzing.Action)
	exports.inventory:RegisterAction("IFAK", Config.IFAK.Action)
	exports.inventory:RegisterAction("Cyanide", Config.Pills.Action)
	exports.inventory:RegisterAction("Oxycodone", Config.Pills.Action)
	exports.inventory:RegisterAction("Hydrocodone", Config.Pills.Action)
	exports.inventory:RegisterAction("Medicinal Joint", Config.Joint.Action)
	exports.inventory:RegisterAction("Edible", Config.Edible.Action)
	exports.inventory:RegisterAction("Body Armor", Config.Armoring.Action)
	exports.inventory:RegisterAction("Heavy Armor", Config.Armoring.Action)
	exports.inventory:RegisterAction("Ballistic Helmet", Config.Armoring.Action)
	exports.inventory:RegisterAction("Medical Bag", Config.Medical.Action)
	exports.inventory:RegisterAction("Rebreather", Config.Rebreather.Action)
	exports.inventory:RegisterAction("Scuba Gear", Config.Rebreather.Action)
	exports.inventory:RegisterAction("Badge", Config.Badge.Action)
	
	exports.inventory:RegisterCondition("Medical Bag", function()
		local hasFaction = false
		for _, faction in ipairs({ "paramedic", "doctor" }) do
			if exports.character:HasFaction(faction) then
				hasFaction = true
				break
			end
		end
		if not hasFaction then
			exports.mythic_notify:SendAlert("error", "You're not trained to use this...", 7000)
			return false
		end
	
		local nearestPed = exports.oldutils:GetNearestPed()
		local player = GetPlayerServerId(NetworkGetPlayerIndexFromPed(nearestPed))

		if player == 0 or #(GetEntityCoords(nearestPed) - GetEntityCoords(PlayerPedId())) > Config.Medical.Distance then
			exports.mythic_notify:SendAlert("error", "There's nobody near you!", 7000)
			return false
		end

		return true
	end)
end

--[[ NUI ]]--
RegisterNUICallback("closeMenu", function(data)
	SetNuiFocus(false, false)
end)

--[[ Items ]]--
AddEventHandler("inventory:loaded", function()
	RegisterItems()
end)

RegisterNetEvent("inventory:use_Bandage")
AddEventHandler("inventory:use_Bandage", function()
	Bandage()
end)

RegisterNetEvent("inventory:use_Gauze")
AddEventHandler("inventory:use_Gauze", function()
	Gauze()
end)

RegisterNetEvent("inventory:use_IFAK")
AddEventHandler("inventory:use_IFAK", function()
	IFAK()
end)

RegisterNetEvent("inventory:use_Badge")
AddEventHandler("inventory:use_Badge", function()
	Badge()
end)

RegisterNetEvent("inventory:use_BodyArmor")
AddEventHandler("inventory:use_BodyArmor", function()
	ArmorUp(1.0)
end)

RegisterNetEvent("inventory:use_HeavyArmor")
AddEventHandler("inventory:use_HeavyArmor", function()
	ArmorUp(1.0, 1)
end)

RegisterNetEvent("inventory:use_BallisticHelmet")
AddEventHandler("inventory:use_BallisticHelmet", function()
	ArmorUp(1.0, 2)
end)

RegisterNetEvent("inventory:use_Rebreather")
AddEventHandler("inventory:use_Rebreather", function()
	Rebreather()
end)

RegisterNetEvent("inventory:use_ScubaGear")
AddEventHandler("inventory:use_ScubaGear", function()
	ScubaGear()
end)

RegisterNetEvent("inventory:use_Cyanide")
AddEventHandler("inventory:use_Cyanide", function()
	Cyanide()
end)

RegisterNetEvent("inventory:use_Oxycodone")
AddEventHandler("inventory:use_Oxycodone", function()
	Oxycodone()
end)

RegisterNetEvent("inventory:use_Hydrocodone")
AddEventHandler("inventory:use_Hydrocodone", function()
	Hydrocodone()
end)


RegisterNetEvent("inventory:use_CrackPipe")
AddEventHandler("inventory:use_CrackPipe", function()
	CrackPipe()
end)

RegisterNetEvent("inventory:use_CrackCocaine")
AddEventHandler("inventory:use_CrackCocaine", function()
	CrackPipe()
end)

RegisterNetEvent("inventory:use_Cocaine")
AddEventHandler("inventory:use_Cocaine", function()
	PureCocaine()
end)

RegisterNetEvent("inventory:use_PeyoteChunk")
AddEventHandler("inventory:use_PeyoteChunk", function()
	PeyoteChunk()
end)

RegisterNetEvent("inventory:use_KetamineSyringe")
AddEventHandler("inventory:use_KetamineSyringe", function()
	KetamineSyringe()
end)

RegisterNetEvent("inventory:use_HeroinSyringe")
AddEventHandler("inventory:use_HeroinSyringe", function()
	HeroinSyringe()
end)

RegisterNetEvent("inventory:use_ChinaWhiteSyringe")
AddEventHandler("inventory:use_ChinaWhiteSyringe", function()
	ChinaWhiteSyringe()
end)

RegisterNetEvent("inventory:use_Lean")
AddEventHandler("inventory:use_Lean", function()
	Lean()
end)

RegisterNetEvent("inventory:use_MedicinalJoint")
AddEventHandler("inventory:use_MedicinalJoint", function()
	MedicinalJoint()
end)

RegisterNetEvent("inventory:use_Edible")
AddEventHandler("inventory:use_Edible", function()
	Edible()
end)

RegisterNetEvent("inventory:use_CBDGummies")
AddEventHandler("inventory:use_CBDGummies", function()
	LesserEdible()
end)

RegisterNetEvent("inventory:use_WaxConcentrate")
AddEventHandler("inventory:use_WaxConcentrate", function()
	MedicinalJoint()
end)

RegisterNetEvent("inventory:use_DabSauce")
AddEventHandler("inventory:use_DabSauce", function()
	MedicinalJoint()
end)

RegisterNetEvent("inventory:use_CherryMedicinalJoint")
AddEventHandler("inventory:use_CherryMedicinalJoint", function()
	MedicinalJoint()
end)

RegisterNetEvent("inventory:use_MangoMedicinalJoint")
AddEventHandler("inventory:use_MangoMedicinalJoint", function()
	MedicinalJoint()
end)

RegisterNetEvent("inventory:use_SpecialCookies")
AddEventHandler("inventory:use_SpecialCookies", function()
	Edible()
end)

RegisterNetEvent("inventory:use_RiceKrispie")
AddEventHandler("inventory:use_RiceKrispie", function()
	Edible()
end)

RegisterNetEvent("inventory:use_CerealKrispie")
AddEventHandler("inventory:use_CerealKrispie", function()
	Edible()
end)

RegisterNetEvent("inventory:use_Bong")
AddEventHandler("inventory:use_Bong", function()
	Bong()
end)

RegisterNetEvent("inventory:use_LSD")
AddEventHandler("inventory:use_LSD", function()
	LSD()
end)

RegisterNetEvent("inventory:use_MedicalBag")
AddEventHandler("inventory:use_MedicalBag", function(item, slot)
	local nearestPed = exports.oldutils:GetNearestPed()
	local player = GetPlayerServerId(NetworkGetPlayerIndexFromPed(nearestPed))

	if player == 0 or #(GetEntityCoords(nearestPed) - GetEntityCoords(PlayerPedId())) > Config.Medical.Distance then
		exports.mythic_notify:SendAlert("error", "There's nobody near you!", 7000)
		return false
	end

	TriggerServerEvent("health:heal", player, true, slot)
	TriggerServerEvent("health:requestInjuries", player)
	RequestingInjuries = 2
end)

RegisterNetEvent("health:heal")
AddEventHandler("health:heal", function(partial)
	if partial then
		HealPartial(0.2)
	else
		HealPed()
	end
end)

--[[ Events ]]--
AddEventHandler("gameEventTriggered", function(name, args)
	if name ~= "CEventNetworkEntityDamage" then return end
	
	local ped = PlayerPedId()
	local targetEntity, sourceEntity, _, _, _, boneOverride, weaponUsed = table.unpack(args)
	if sourceEntity == -1 then return end

	if ped ~= targetEntity then
		if ped == sourceEntity and IsEntityAPed(targetEntity) and IsPedAPlayer(targetEntity) then
			local player = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetEntity))
			if player then
				TriggerServerEvent("health:beginCombat", player, weaponUsed)
			end
		end
		return
	end
	-- ped = targetEntity

	local damageType = GetWeaponDamageType(weaponUsed)
	local targetType = GetEntityType(targetEntity)
	local sourceType = GetEntityType(sourceEntity)

	local retval, bone = GetPedLastDamageBone(targetEntity)

	LastWeaponUsed = weaponUsed

	-- Injury.
	local injury = nil
		
	if damageType == 2 then
		-- Melee (blunt or stab).
		-- Don't set injury, let it be per weapon.
	elseif damageType == 3 then
		-- Bullet.
		injury = "gsw"
	elseif damageType == 4 then
		-- Force ragdoll fall (bruising/broken bones).
		injury = "blunt"
	elseif damageType == 5 then
		-- Explosive.
		injury = "burn3"
		retval = true
		bone = RandomBone()
	elseif damageType == 6 then
		-- Fire.
		injury = "burn2"
		retval = true
		bone = RandomBone()
	elseif damageType == 8 then
		-- WEAPON_HELI_CRASH.
		injury = "blunt"
	elseif damageType == 10 then
		-- Eletric.
		injury = "burn2"
	elseif damageType == 11 then
		-- Barbed wire.
		injury = "scrapes"
	elseif damageType == 12 then
		-- Extinguisher.
		print("Ow, my lungs!")
	elseif damageType == 13 then
		-- Gas.
		injury = "gas"
	elseif damageType == 14 then
		-- Water cannon.
		injury = "blunt"
	end

	local weaponSettings = {}
	if not injury then
		weaponSettings = exports.weapons:GetSettings(weaponUsed)
		injury = weaponSettings.Injury or "blunt"
	end

	-- Bone defaults.
	if boneOverride ~= 0 and boneOverride ~= nil and Config.BodyParts[boneOverride] then
		bone = boneOverride
	elseif not retval then
		bone = RandomBone()
	end

	-- Body parts.
	local bodyPart = Config.BodyParts[bone]

	if bodyPart == nil then
		bone = 11816
		bodyPart = Config.BodyParts[11816]
	elseif bodyPart.Fallback then
		bone = bodyPart.Fallback
		bodyPart = Config.BodyParts[bodyPart.Fallback]
	end

	-- Damage.
	local maxHealth = GetPedMaxHealth(ped)
	local health = GetEntityHealth(ped)

	local damageTaken = maxHealth - health
	
	-- Armor.
	-- if bodyPart.Armored and not weaponSettings.IgnoreArmor and armor > 0 then
	-- 	armor = armor - armorDamage
	-- 	damageTaken = armorDamage * 0.15
	-- 	injury = "blunt"
	-- else
	-- 	damageTaken = damageTaken + armorDamage
	-- 	armor = LastArmor
	-- end
	
	-- Damage.
	local damage = math.min(damageTaken / 100.0 * (weaponSettings.Damage or 1.0), 1.0)
	local resistance = GetEffect("Armor")

	if resistance > 0.001 then
		local min, max = table.unpack(Config.Modifiers.Resistance)
		resistance = ((max - min) * resistance + min)
		
		damage = damage * resistance
	end

	if Debug then
		print("damage", damage, damageTaken, json.encode(injury))
		print("resistance", resistance)
	end
	
	-- Finally set health.
	SetEntityHealth(ped, maxHealth)

	local injuries = nil
	if type(injury) == "table" then
		injuries = injury
	else
		injuries = { injury }
	end

	for k, injury in ipairs(injuries) do
		local injuryInfo = Config.Injuries[injury]
		DamageBone(bone, damage * ((injuryInfo or {}).DamageMultiplier or 1.0), injury)
		if injuryInfo and injuryInfo.Spread ~= nil and damage > (injuryInfo.MinSpread or 0.0) then
			SpreadDamage(bone, damage, injuryInfo.Spread)
		end
	end
	-- If death.
	if CheckBones() then
		local player = nil
		if sourceEntity ~= ped and IsEntityAPed(sourceEntity) and IsPedAPlayer(sourceEntity) then
			player = GetPlayerServerId(NetworkGetPlayerIndexFromPed(sourceEntity))
		end
		TriggerServerEvent("health:killed", weaponUsed, player)
	end
	UpdateInfo()
end)

RegisterNetEvent("health:status")
AddEventHandler("health:status", function(type)
	UpdateInfo(type ~= 0)
end)

RegisterNetEvent("health:requestInjuries")
AddEventHandler("health:requestInjuries", function(target)
	Citizen.Trace(("Uploading injuries to net for netID %s\n"):format(target))
	TriggerServerEvent("health:sendInjuries", Info, target)
end)

RegisterNetEvent("health:receiveInjuries")
AddEventHandler("health:receiveInjuries", function(target, info)
	Citizen.Trace(("Downloading injuries from net for netID %s\n"):format(target))

	UpdateInfo(RequestingInjuries ~= 2, target, info)
	RequestingInjuries = nil
end)

RegisterNetEvent("health:downloadInfo")
AddEventHandler("health:downloadInfo", function()
	UpdateInfo(type ~= 0)
	if type ~= 0 then
		SetNuiFocus(true, true)
		SetNuiFocusKeepInput(true)
	end
end)

RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	ResurrectPed()
end)

AddEventHandler("health:start", function()
	RegisterItems()
end)

--[[ Commands ]]--
RegisterCommand("status", function(source, args, command)
	TriggerEvent("health:status", 0)
end)

RegisterCommand("mi", function(source, args, command)
	TriggerEvent("health:status", 1)
end)

RegisterCommand("ci", function(source, args, command)
	local nearestPed = exports.oldutils:GetNearestPed()
	-- nearestPed = PlayerPedId()
	local player = GetPlayerServerId(NetworkGetPlayerIndexFromPed(nearestPed))

	if player == 0 or #(GetEntityCoords(nearestPed) - GetEntityCoords(PlayerPedId())) > Config.CheckInjuryDistance then
		exports.mythic_notify:SendAlert("error", "There's nobody near you to check!", 7000)
		return
	end
	
	TriggerServerEvent("health:requestInjuries", player)
	RequestingInjuries = 1
	-- TriggerEvent("health:status", 2)
end)
