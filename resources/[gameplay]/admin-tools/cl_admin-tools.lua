PowerLevel = 0
Functions = {}
Options = {}
Players = nil
GodMode = false
Invisible = false

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		UpdateUser()
	end
end)

Citizen.CreateThread(function()
	while true do
		while PowerLevel < Config.MinPowerLevel do
			Citizen.Wait(1000)
		end

		Citizen.Wait(0)

		Ped = PlayerPedId()
		Vehicle = GetVehiclePedIsIn(Ped, false)
		for name, func in pairs(Functions) do
			func()
		end
	end
end)

--[[ Functions ]]--
function RequestPlayers()
	Players = nil
	TriggerServerEvent("admin-tools:requestPlayers")

	local waitUntil = GetGameTimer() + 10000

	while Players == nil and GetGameTimer() < waitUntil do
		Citizen.Wait(10)
	end

	return Players ~= nil
end

function UpdateUser()
	PowerLevel = exports.user:GetUser().power_level or 0

	TriggerServerEvent("admin-tools:update", PowerLevel)
end

function SetCoords(x, y, z)
	local entity = Ped
	if DoesEntityExist(Vehicle) then
		entity = Vehicle
	end
	Coords = vector3(x, y, z)
	SetEntityCoords(entity, x, y, z)
end

-- function DrawText(title, text, yOrder, xOrder)
-- 	local pos = vector2(0.05 + (xOrder or 0.0) * 0.38, 0.05 + (yOrder or 0) * 0.03)
-- 	_DrawText(title, pos)
-- 	_DrawText(text, pos + vector2(0.1, 0.0))
-- end

-- function _DrawText(text, pos)
-- 	SetTextFont(6)
-- 	SetTextProportional(1)
-- 	SetTextScale(0.5, 0.5)
-- 	SetTextColour(255, 255, 255, 255)
-- 	SetTextDropShadow(0, 0, 0, 0, 255)
-- 	SetTextEdge(1, 0, 0, 0, 255)
-- 	SetTextDropShadow()
-- 	SetTextOutline()
-- 	BeginTextCommandDisplayText("string")
-- 	AddTextComponentSubstringPlayerName(tostring(text))
-- 	EndTextCommandDisplayText(pos.x, pos.y)
-- end

--[[ Events ]]--
RegisterNetEvent("admin-tools:receivePlayers")
AddEventHandler("admin-tools:receivePlayers", function(players)
	Players = players
end)

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
		SetPedToRagdoll(ped, 1500, 1500, 0)
		StartEntityFire(ped)
	end

	local lightFrames = 60
	for i = 1, lightFrames do
		local coords = GetEntityCoords(ped)
		local intensity = math.sin(math.pi * (i / lightFrames)^0.5) * 500.0

		DrawLightWithRange(coords.x, coords.y, coords.z + 20.0, 255, 255, 255, 100.0, intensity)
		Citizen.Wait(0)
	end
end)

--[[ Options ]]--
Options[#Options + 1] = {
	"Clean", "click",
	function(value)
		SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId()), 0.0)
	end
}

Options[#Options + 1] = {
	"God Mode", "toggle",
	function(value)
		GodMode = value

		if value then
			Citizen.CreateThread(function()
				while GodMode do
					SetEntityInvincible(PlayerPedId(), true)
					
					Citizen.Wait(100)
				end

				SetEntityInvincible(PlayerPedId(), false)
			end)
		end
	end
}

Options[#Options + 1] = {
	"Invisibility", "toggle",
	function(value)
		Invisible = value

		if value then
			Citizen.CreateThread(function()
				while Invisible do
					SetEntityAlpha(PlayerPedId(), 128)
					SetEntityInvincible(PlayerPedId(), true)
					SetEntityVisible(PlayerPedId(), false)
					
					Citizen.Wait(100)
				end
			end)
		else
			SetEntityAlpha(PlayerPedId(), 255)
			SetEntityInvincible(PlayerPedId(), false)
			SetEntityVisible(PlayerPedId(), true)
		end
	end
}

exports("IsInvisible", function()
	return Invisible
end)