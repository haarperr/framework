Noclip = false

local WasNoclip = false
local Camera = nil
local Rotation = nil
local MoveSpeed = 0.2
local LastVehicle = nil
local Light = false

local function ToggleVisibility(toggle)
	SetEntityVisible(Ped, not toggle)
	exports.oldutils:SetPlayerVisibleLocally(not toggle)
	FreezeEntityPosition(Ped, toggle)
	SetEntityCollision(Ped, not toggle, not toggle)
end

function Functions:ProcessNoclip()
	if PowerLevel < Config.Noclip.PowerLevel then return end

	if (IsDisabledControlJustPressed(0, Config.Noclip.Key) or (Noclip and IsDisabledControlJustPressed(0, 24))) and not IsPauseMenuActive() then
		Noclip = not Noclip
	end

	if Noclip ~= WasNoclip then
		-- ToggleVisibility(Noclip)
		ClearFocus()
		
		if Noclip then
			Camera = exports.oldutils:CreateCam()
			Rotation = Rotation or GetGameplayCamRot()
			Coords = Coords or GetGameplayCamCoord()
			
			Camera:Set("pos", Coords)
			Camera:Set("rot", Rotation)
			Camera:Set("fov", 60.0)
			Camera:Set("shake", 0.0)
			Camera:Activate()
			
			LastVehicle = Vehicle
			-- if DoesEntityExist(LastVehicle) then
			-- 	SetEntityAsMissionEntity(LastVehicle)
			-- 	SetEntityVisible(LastVehicle, false)
			-- 	SetEntityCollision(LastVehicle, false, false)
			-- end
		else
			Camera:Deactivate()

			SetGameplayCamRelativeRotation(0, 0, 0)

			-- if DoesEntityExist(LastVehicle) then
			-- 	SetPedIntoVehicle(Ped, LastVehicle, -1)
			-- 	SetEntityCoords(LastVehicle, Coords.x, Coords.y, Coords.z)
			-- 	SetEntityHeading(LastVehicle, Rotation.z)
			-- 	SetEntityAsNoLongerNeeded(LastVehicle)
			-- 	SetEntityVisible(LastVehicle, true)
			-- 	SetEntityCollision(LastVehicle, true, true)
			-- end
			Coords = nil
			Rotation = nil
			LastVehicle = nil
		end
	end

	if Noclip then
		if not IsPauseMenuActive() then
			local lookX, lookY = GetDisabledControlUnboundNormal(1, 1), GetDisabledControlUnboundNormal(1, 2)
			local moveX, moveY, moveZ = GetDisabledControlUnboundNormal(0, 30), GetDisabledControlUnboundNormal(0, 31), 0
			local right, forward, up = GetCamMatrix(Camera:Get("cam"))
			
			if IsDisabledControlPressed(0, 20) then
				moveZ = -1
			elseif IsDisabledControlPressed(0, 44) then
				moveZ = 1
			end
			
			if IsDisabledControlPressed(0, 96) then
				MoveSpeed = math.min(MoveSpeed + 0.1, 10.0)
			elseif IsDisabledControlPressed(0, 97) then
				MoveSpeed = math.max(MoveSpeed - 0.1, 0.05)
			end

			DisableAllControlActions(0)

			for k, v in ipairs({ 137, 178, 199, 200, 245, 249 }) do
				EnableControlAction(0, v, true)
			end
			
			local speed = MoveSpeed

			if IsDisabledControlPressed(0, 21) then
				speed = speed * 2.0
			end

			Rotation = vector3(math.min(math.max(Rotation.x - lookY * Config.Noclip.Sensitivity, -90), 90), 0, Rotation.z - lookX * Config.Noclip.Sensitivity)
			Coords = Coords - forward * moveY * speed + right * moveX * speed + up * moveZ * speed

			Camera:Set("rot", Rotation)
			Camera:Set("pos", Coords)

			if Light then
				DrawSpotLight(Coords.x, Coords.y, Coords.z, forward.x, forward.y, forward.z, 255, 255, 255, 500.0, 1.0, 0.0, 100.0, 1.0)
			end

			if IsDisabledControlJustPressed(0, 25) then
				if DoesEntityExist(LastVehicle) then
					SetEntityCoordsNoOffset(LastVehicle, Coords.x, Coords.y, Coords.z)
				else
					SetEntityHeading(Ped, Rotation.z)
					SetEntityCoordsNoOffset(Ped, Coords.x, Coords.y, Coords.z)
				end
			elseif IsDisabledControlJustPressed(0, 46) then
				Light = not Light
			end
		end
	
		SetFocusPosAndVel(Coords.x, Coords.y, Coords.z)
	
		SetPlayerBlipPositionThisFrame(Coords.x, Coords.y)
	end

	WasNoclip = Noclip
end

function IsNoclipping()
	return Noclip
end
exports("IsNoclipping", IsNoclipping)