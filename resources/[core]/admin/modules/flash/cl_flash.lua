RegisterNetEvent("admin-tools:flash")
AddEventHandler("admin-tools:flash", function(target)
	local ptfx = "core"
	local name = "exp_grd_sticky"

	local player = GetPlayerFromServerId(target)
	if player == -1 then return end

	local ped = GetPlayerPed(player)
	if not DoesEntityExist(ped) then return end

	while not HasNamedPtfxAssetLoaded(ptfx) do
		RequestNamedPtfxAsset(ptfx)
		Citizen.Wait(20)
	end

	local bolt = GetEntityCoords(ped)
	local spread = 0.6
	local points = {}

	for i = 1, 100 do
		bolt = bolt + vector3(GetRandomFloatInRange(-spread, spread), GetRandomFloatInRange(-spread, spread), 1.0)

		points[i] = bolt
		
	end
	
	ForceLightningFlash()

	for i = #points, 1, -1 do
		local bolt = points[i]

		UseParticleFxAsset(ptfx)
		StartParticleFxNonLoopedAtCoord(name, bolt.x, bolt.y, bolt.z, 0.0, 90.0, 0.0, 0.65, true, true, true)

		if i % 5 == 0 then
			Citizen.Wait(0)
		end
	end
	
	if ped == PlayerPedId() then
		SetPedToRagdoll(ped, 5000, 5000, 0)
		--StartEntityFire(ped)
	end

	local lightFrames = 60
	for i = 1, lightFrames do
		local coords = GetEntityCoords(ped)
		local intensity = math.sin(math.pi * (i / lightFrames)^0.5) * 500.0

		DrawLightWithRange(coords.x, coords.y, coords.z + 20.0, 255, 255, 255, 100.0, intensity)
		Citizen.Wait(0)
	end
end)