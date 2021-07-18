local cam = nil
local viewing = false

--[[ Functions ]]--
function CreateCam()
	-- Create the camera.
	cam = exports.oldutils:CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA")
	cam:Set("fov", 10.0)
	cam:Set("shake", 0.0)
	cam:Set("rot", vector3(-90.0, 0.0, 0.0))
	cam:Activate()

	local sourceBlip = AddBlipForRadius(0.0, 0.0, 0.0, Config.Blip.Radius)
	local targetBlip = AddBlipForRadius(0.0, 0.0, 0.0, Config.Blip.Radius)

	Citizen.CreateThread(function()
		-- Update the camera.
		while viewing do
			-- DisableControlAction(0, 200, true)

			if IsDisabledControlJustPressed(0, 46) then
				StopViewing()
				break
			end

			local coords = cam:Get("pos")
			local targetCoords = cam:Get("target") or coords
			local dir = targetCoords - coords
			local dist = #dir
			local groundZ = GetHeightmapTopZForPosition(coords.x, coords.y)

			if #(targetCoords - coords) > 1.0 then
				coords = coords + dir / dist
				
				SetBlipCoords(targetBlip, targetCoords.x, targetCoords.y, targetCoords.z)
				SetBlipAlpha(targetBlip, 255)
			else
				SetBlipAlpha(targetBlip, 0)
			end
			
			cam:Set("pos", coords)
			
			SetBlipCoords(sourceBlip, coords.x, coords.y, coords.z)
			SetFocusPosAndVel(coords.x, coords.y, groundZ, 0.0, 0.0, 0.0)
			-- SetPlayerBlipPositionThisFrame(coords.x, coords.y)
			SetRadarAsExteriorThisFrame()

			if IsWaypointActive() then
				local blip = GetFirstBlipInfoId(8)
				if DoesBlipExist(blip) then
					SetTarget(GetBlipCoords(blip))
					SetWaypointOff()
				end
			end

			Citizen.Wait(0)
		end

		-- Keep disabling pause menu.
		-- Citizen.CreateThread(function()
		-- 	for i = 1, 30 do
		-- 		DisableControlAction(0, 200, true)
		-- 		Citizen.Wait(0)
		-- 	end
		-- end)

		-- Deactivate the camera.
		cam:Deactivate()
		cam = nil

		-- Remove blips.
		if DoesBlipExist(sourceBlip) then
			RemoveBlip(sourceBlip)
		end
		
		if DoesBlipExist(targetBlip) then
			RemoveBlip(targetBlip)
		end

		-- Reset focus.
		ClearFocus()
	end)
end

function StopViewing()
	viewing = false
	TriggerServerEvent("satCam:subscribe", id, false)
end

function ViewSite(id)
	viewing = id
	SetWaypointOff()
	TriggerServerEvent("satCam:subscribe", id, true)
end

function SetTarget(coords)
	TriggerServerEvent("satCam:setCoords", viewing, coords)
end

--[[ Events ]]--
RegisterNetEvent("satCam:update")
AddEventHandler("satCam:update", function(info)
	if not viewing then return end
	
	local position = info.position
	local coords = vector3(position[1], position[2], 1000.0)
	
	if not cam then
		CreateCam(coords)
		cam:Set("pos", coords)
	end

	cam:Set("target", coords)
end)

AddEventHandler("satCam:clientStart", function()
	for siteId, site in ipairs(Config.Sites) do
		local callbackId = "SatCam-"..tostring(siteId)

		-- Create the marker.
		exports.markers:CreateUsable(
			GetCurrentResourceName(),
			site.Control,
			callbackId,
			{ {47, "Insert Credentials"} }
		)

		-- Create the callback.
		AddEventHandler("markers:use_"..callbackId, function()
			ViewSite(siteId)
		end)
	end
end)