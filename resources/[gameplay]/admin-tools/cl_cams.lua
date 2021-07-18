local ShouldUpdate = false
local Camera = nil
local Cams = nil
local Rays = {
	{ Angle = vector3(0.0, 0.0, 0.0), R = 0, G = 255, B = 0, A = 255, Dist = 100.0 },
	{ Angle = vector3(15.0, 0.0, 0.0), R = 255, G = 255, B = 0, A = 255, Dist = 1.0 },
	{ Angle = vector3(-15.0, 0.0, 0.0), R = 255, G = 255, B = 0, A = 255, Dist = 1.0 },
	{ Angle = vector3(0.0, 0.0, 15.0), R = 255, G = 255, B = 0, A = 255, Dist = 1.0 },
	{ Angle = vector3(0.0, 0.0, -15.0), R = 255, G = 255, B = 0, A = 255, Dist = 1.0 },
}
local LastCoords = nil
local LastRot = nil
local Spectating = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local user = exports.user:GetUser()
		if user and user.power_level then
			ShouldUpdate = (user.power_level or 0) < 255
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		if ShouldUpdate then
			TriggerServerEvent("a-t:u", GetFinalRenderedCamCoord(), GetFinalRenderedCamRot())
		end
		Citizen.Wait(50)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Cams then
			local selfPlayer = GetPlayerServerId(PlayerId())
			local selfCoords = GetFinalRenderedCamCoord()
			for player, cam in pairs(Cams) do
				local coords = cam[1]
				if player ~= selfPlayer and #(selfCoords - coords) < 200.0 then
					local rot = cam[2]
					local dir = exports.misc:FromRotation(rot + vector3(0, 0, 90))
					
					for _, ray in ipairs(Rays) do
						local angleDir = exports.misc:FromRotation(rot + vector3(0, 0, 90) + ray.Angle) * ray.Dist
						DrawLine(coords.x, coords.y, coords.z, coords.x + angleDir.x, coords.y + angleDir.y, coords.z + angleDir.z, ray.R, ray.G, ray.B, ray.A)
					end

					exports.oldutils:Draw3DText(coords + vector3(0, 0, 1.0), "["..tostring(player).."]", 4, 0.3, id)
					-- DrawSpotLight(
					-- 	coords.x,
					-- 	coords.y,
					-- 	coords.z,
					-- 	dir.x,
					-- 	dir.y,
					-- 	dir.z,
					-- 	0,
					-- 	255,
					-- 	0,
					-- 	20.0, -- Distance.
					-- 	1.0, -- Brightness.
					-- 	10.0, -- Hardness.
					-- 	15.0, -- Radius.
					-- 	0.0 -- Falloff.
					-- )
				end
			end
		else
			Citizen.Wait(1000)
		end
		collectgarbage()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		while not Spectating or not Camera do
			Citizen.Wait(200)
		end
		
		local delta = (GetGameTimer() - LastUpdate) / 1000.0
		
		if LastCoords and LastRot then
			local coords = Coords + (Coords - LastCoords) * delta
			local rot = Rotation + (Rotation - LastRot) * delta

			Camera:Set("pos", coords)
			Camera:Set("rot", rot)
		end
		
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
RegisterNetEvent("a-t:u")
AddEventHandler("a-t:u", function(cams)
	Cams = cams
end)

RegisterNetEvent("a-t:s")
AddEventHandler("a-t:s", function(target, info)
	if not info or not info[1] or not info[2] then
		if Camera then
			Camera:Deactivate()
			Camera = nil
		end
		ClearFocus()
		Spectating = nil
		
		return
	end
	
	local player = GetPlayerFromServerId(target)
	Spectating = player

	if Noclip then
		ExecuteCommand("a:spectate")
		return
	end
	-- Noclip = false

	if not Camera then
		Camera = exports.oldutils:CreateCam()
		Camera:Set("fov", 70.0)
		Camera:Set("shake", 0.0)
		Camera:Activate()
	end
	
	LastCoords = Coords
	LastRot = Rotation

	Coords = info[1]
	Rotation = info[2]

	LastUpdate = GetGameTimer()
	
	Camera:Set("pos", Coords)
	Camera:Set("rot", Rotation)

	local listenCoords = Coords
	local ped = GetPlayerPed(player)
	if DoesEntityExist(ped) then
		local coords = GetEntityCoords(ped)
		listenCoords = coords
	end
	
	SetFocusPosAndVel(info[1].x, info[1].y, info[1].z)
end)

--[[ Options ]]--
Options[#Options + 1] = {
	"View Cameras", "toggle",
	function(value)
		TriggerServerEvent("admin-tools:viewCams", value)
		if not value then
			Cams = nil
		end
	end
}