Dict = "misscarsteal1leadin"
Name = "devon_idle_02"
Enabled = true
Health = 10000
Shields = {}

AddEventHandler("gameEventTriggered", function(name, args)
	if not Enabled then return end
	if name ~= "CEventNetworkEntityDamage" then return end
	
	local ped = PlayerPedId()
	local targetEntity, sourceEntity, damageTime, fatalDamage, weaponUsed, boneOverride = table.unpack(args)

	if targetEntity ~= ped then return end

	local damage = 200 - GetEntityHealth(ped)

	Health = Health - damage

	print(Health)

	SetEntityHealth(ped, 200)
end)

Citizen.CreateThread(function()
	-- missfam5_flying falling_to_skydive
	CreateTest()
	CreateShields()

	if true then return end
	StartFlying()
	while true do
		local velocity = vector3(0.0, 0.0, 0.0)
		local ped = PlayerPedId()
		
		if not IsEntityPlayingAnim(ped, Dict, Name, 3) then
			ClearPedTasksImmediately(ped)
			StartFlying()
		end
		
		local coords = GetEntityCoords(ped)
		local right = GetControlNormal(0, 30)
		local forward = GetControlNormal(0, 31)
		local speed = 20.0
		local target

		if IsControlPressed(0, 21) then
			speed = speed * 5.0
		end

		target = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)
		velocity = velocity + (target - coords) * -forward * speed

		target = GetOffsetFromEntityInWorldCoords(ped, 1.0, 0.0, 0.0)
		velocity = velocity + (target - coords) * right * speed

		if IsControlPressed(0, 22) then
			velocity = velocity + vector3(0.0, 0.0, 1.0) * speed
		elseif IsControlPressed(0, 36) then
			velocity = velocity - vector3(0.0, 0.0, 1.0) * speed
		end

		-- if IsControlPressed(0, 44) then
		-- 	SetEntityHeading(ped, GetEntityHeading(ped) + 2.0)
		-- elseif IsControlPressed(0, 46) then
		-- 	SetEntityHeading(ped, GetEntityHeading(ped) - 2.0)
		-- end

		local camRot = GetGameplayCamRot(2)
		local heading = GetEntityHeading(ped)

		-- heading = heading + (heading - camRot.z) * GetFrameTime()

		if not IsDisabledControlPressed(0, 46) then
			heading = camRot.z
		end

		SetEntityHeading(ped, heading)
		SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
		-- SetEntityCoords(ped, coords.x, coords.y, coords.z)

		SetPedCanRagdoll(ped, false)
		SetPedGravity(ped, false)
		SetEntityHasGravity(ped, false)

		-- if GetIsTaskActive(ped, 422) then
		-- 	ClearPedTasksImmediately(ped)
		-- end
		
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local peds = exports.oldutils:GetPeds()
		local coords = GetEntityCoords(PlayerPedId())
		for k, ped in ipairs(peds) do
			TaskShootAtCoord(ped, coords.x, coords.y, coords.z, 1000)
		end

		Citizen.Wait(1000)
	end
end)


function CreateShields()
	local model = GetHashKey("prop_metal_plates01")
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(0)
	end

	local coords = GetEntityCoords(PlayerPedId())

	local n = 8
	for i = 1, n do
		local rad = (i / n) * 3.14 * 2.0
		local dir = vector3(math.cos(rad), math.sin(rad), 0.0)
		local rot = exports.misc:ToRotation(dir) + vector3(90.0, 0.0, 0.0)
		local pCoords = coords + dir * 3.0

		local entity = CreateObject(model, pCoords.x, pCoords.y, pCoords.z, true, true, false)
		-- SetEntityVisible(entity, false)
		SetEntityRotation(entity, rot.x, rot.y, rot.z)
		-- FreezeEntityPosition(entity, true)
		AttachEntityToEntity(entity, PlayerPedId(), -1, pCoords.x, pCoords.y, pCoords.z, rot.x, rot.y, rot.z, false, false, true, true, 0, true)
		SetEntityCoords(entity, pCoords.x, pCoords.y, pCoords.z)
		Shields[i] = entity
	end
end

function StartFlying()
	local ped = PlayerPedId()
	RequestAnimDict(Dict)
	while not HasAnimDictLoaded(Dict) do
		Wait(0)
	end
	
	TaskPlayAnim(
		ped --[[ Ped ]], 
		Dict --[[ string ]], 
		Name --[[ string ]], 
		1.0 --[[ number ]], 
		1.0 --[[ number ]], 
		-1 --[[ integer ]], 
		49 --[[ integer ]], 
		1.0 --[[ number ]], 
		false --[[ boolean ]], 
		false --[[ boolean ]], 
		false --[[ boolean ]]
	)
end

function StopFlying()
end

function CreateTest()
	local mdl = "g_m_importexport_01"
	RequestModel(mdl)
	Citizen.Wait(500)
	AddRelationshipGroup("ppl")

	local coords = GetEntityCoords(PlayerPedId())
	
	for i = 1, 10 do
		local rad = GetRandomFloatInRange(-3.14, 3.14)
		local nCoords = coords + vector3(math.cos(rad), math.sin(rad), 0.0) * GetRandomFloatInRange(10.0, 20.0)
		local retval, height = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)

		local ped = CreatePed(4, mdl, nCoords.x, nCoords.y, height, GetRandomFloatInRange(0, 360), false, false)
		PlaceObjectOnGroundProperly(ped)
		GiveWeaponToPed(ped, "WEAPON_ASSAULTRIFLE", 9999, false, true)
		TaskCombatPed(ped, PlayerPedId(), 0, 16)
		SetPedRelationshipGroupHash(ped, GetHashKey("ppl"))
	end
end