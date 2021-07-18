local HoldingCam = false
local HoldingMicrophone = false
local HoldingBoomMic = false

local Fov = (Config.Camera.Fov.Max+Config.Camera.Fov.Min)*0.5

local MovCamera = false
local NewsCamera = false

--[[ Threads ]]--

-- Movie Cam.
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		local Ped = PlayerPedId()
		local Vehicle = GetVehiclePedIsIn(Ped, false)

		if HoldingCamera and IsControlJustReleased(1, 74) then
			MovCamera = true

			SetTimecycleModifier("default")

			SetTimecycleModifierStrength(0.3)
			
			local Scaleform = RequestScaleformMovie(Config.Camera.Scaleforms[1])

			while not HasScaleformMovieLoaded(Scaleform) do
				Citizen.Wait(10)
			end


			local Ped = PlayerPedId()
			local Vehicle = GetVehiclePedIsIn(Ped)
			local MovieCamera = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(MovieCamera, Ped, 0.0,0.0,1.0, true)
			SetCamRot(MovieCamera, 2.0,1.0,GetEntityHeading(Ped))
			SetCamFov(MovieCamera, Fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(Scaleform, Config.Camera.Scaleforms[1])
			PopScaleformMovieFunctionVoid()

			while MovCamera and not IsEntityDead(Ped) and (GetVehiclePedIsIn(Ped) == Vehicle) and true do
				if IsControlJustPressed(0, 177) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					MovCamera = false
				end
				
				SetEntityRotation(Ped, 0, 0, new_z,2, true)

				local zoomvalue = (1.0/(Config.Camera.Fov.Max-Config.Camera.Fov.Min))*(Fov-Config.Camera.Fov.Min)
				CheckInputRotation(MovieCamera, zoomvalue)

				HandleZoom(MovieCamera)
				HideHUDThisFrame()
                
				DrawRct(Config.UI.x + 0.0, 	Config.UI.y + 0.0, 1.0,0.15,0,0,0,255) -- Top Bar
				DrawScaleformMovieFullscreen(Scaleform, 255, 255, 255, 255)
				DrawRct(Config.UI.x + 0.0, 	Config.UI.y + 0.85, 1.0,0.16,0,0,0,255) -- Bottom Bar
				
				local camHeading = GetGameplayCamRelativeHeading()
				local camPitch = GetGameplayCamRelativePitch()
				if camPitch < -70.0 then
					camPitch = -70.0
				elseif camPitch > 42.0 then
					camPitch = 42.0
				end
				camPitch = (camPitch + 70.0) / 112.0
				
				if camHeading < -180.0 then
					camHeading = -180.0
				elseif camHeading > 180.0 then
					camHeading = 180.0
				end
				camHeading = (camHeading + 180.0) / 360.0
				
				Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
				Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
				
				Citizen.Wait(10)
			end

			MovCamera = false
			ClearTimecycleModifier()
			Fov = ( Config.Camera.Fov.Max + Config.Camera.Fov.Min ) * 0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(Scaleform)
			DestroyCam(MovieCamera, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

-- News Cam.
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		local Ped = PlayerPedId()
		local Vehicle = GetVehiclePedIsIn(Ped)

		if HoldingCamera and IsControlJustReleased(1, 38) then
			NewsCamera = true

			SetTimecycleModifier("default")

			SetTimecycleModifierStrength(0.3)
			
			local Scaleform = RequestScaleformMovie(Config.Camera.Scaleforms[1])
			local Scaleform2 = RequestScaleformMovie(Config.Camera.Scaleforms[2])


			while not HasScaleformMovieLoaded(Scaleform) do
				Citizen.Wait(10)
			end
			while not HasScaleformMovieLoaded(Scaleform2) do
				Citizen.Wait(10)
			end


			local Ped = PlayerPedId()
			local Vehicle = GetVehiclePedIsIn(Ped)
			local Cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(Cam2, Ped, 0.0,0.0,1.0, true)
			SetCamRot(Cam2, 2.0,1.0,GetEntityHeading(Ped))
			SetCamFov(Cam2, Fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(Scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunction(Scaleform2, Config.Camera.Scaleforms[2])
			PopScaleformMovieFunctionVoid()

			while NewsCamera and not IsEntityDead(Ped) and (GetVehiclePedIsIn(Ped) == Vehicle) and true do
				if IsControlJustPressed(1, 177) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					NewsCamera = false
				end

				SetEntityRotation(Ped, 0, 0, new_z,2, true)
					
				local zoomvalue = (1.0/(Config.Camera.Fov.Max-Config.Camera.Fov.Min))*(Fov-Config.Camera.Fov.Min)
				CheckInputRotation(Cam2, zoomvalue)

				HandleZoom(Cam2)
				HideHUDThisFrame()

				DrawScaleformMovieFullscreen(Scaleform, 255, 255, 255, 255)
				DrawScaleformMovie(Scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
				Breaking("BREAKING NEWS")
				
				local camHeading = GetGameplayCamRelativeHeading()
				local camPitch = GetGameplayCamRelativePitch()
				if camPitch < -70.0 then
					camPitch = -70.0
				elseif camPitch > 42.0 then
					camPitch = 42.0
				end
				camPitch = (camPitch + 70.0) / 112.0
				
				if camHeading < -180.0 then
					camHeading = -180.0
				elseif camHeading > 180.0 then
					camHeading = 180.0
				end
				camHeading = (camHeading + 180.0) / 360.0
				
				Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
				Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
				
				Citizen.Wait(10)
			end

			NewsCamera = false
			ClearTimecycleModifier()
			Fov = ( Config.Camera.Fov.Max + Config.Camera.Fov.Min ) * 0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(Scaleform)
			DestroyCam(Cam2, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

--[[ Events ]]--

RegisterNetEvent("inventory:use_StudioCamera")
RegisterNetEvent("inventory:use_Microphone")
RegisterNetEvent("inventory:use_BoomMicrophone")

AddEventHandler("inventory:use_StudioCamera", function()
    if HoldingCamera then
        ExitCamera()
    else
        EnterCamera()
    end
end)

AddEventHandler("inventory:use_Microphone", function()
    if HoldingMicrophone then
        exports.emotes:CancelEmote()
    else
        EnterMic()
    end
end)

AddEventHandler("inventory:use_BoomMicrophone", function()
    if HoldingBoomMic then
        exports.emotes:CancelEmote()
    else
        EnterBoomMic()
    end
end)

--[[ Functions ]]--

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(Config.Camera.ZoomUD)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(Config.Camera.ZoomLR)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local Ped = PlayerPedId()
	if not ( IsPedSittingInAnyVehicle( Ped ) ) then

		if IsControlJustPressed(0,241) then
			Fov = math.max(Fov - Config.Camera.ZoomSpeed, Config.Camera.Fov.Min)
		end
		if IsControlJustPressed(0,242) then
			Fov = math.min(Fov + Config.Camera.ZoomSpeed, Config.Camera.Fov.Max)
		end
		local CurrentFov = GetCamFov(cam)
		if math.abs(Fov-CurrentFov) < 0.1 then
			Fov = CurrentFov
		end
		SetCamFov(cam, CurrentFov + (Fov - CurrentFov)*0.05)
	else
		if IsControlJustPressed(0,17) then
			Fov = math.max(Fov - Config.Camera.ZoomSpeed, Config.Camera.Fov.Min)
		end
		if IsControlJustPressed(0,16) then
			Fov = math.min(Fov + Config.Camera.ZoomSpeed, Config.Camera.Fov.Max)
		end
		local CurrentFov = GetCamFov(cam)
		if math.abs(Fov-CurrentFov) < 0.1 then
			Fov = CurrentFov
		end
		SetCamFov(cam, CurrentFov + (Fov - CurrentFov)*0.05)
	end
end

function Breaking(text)
		SetTextColour(255, 255, 255, 255)
		SetTextFont(8)
		SetTextScale(1.2, 1.2)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.2, 0.85)
end

function Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0, 1)
end

function DisplayNotification(string)
	SetTextComponentFormat("STRING")
	AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function ExitCamera()
    HoldingCamera = false
    exports.emotes:CancelEmote()
end

function EnterCamera()
    HoldingCamera = true
    exports.emotes:PerformEmote(Config.Camera.Anim, function()
        ExitCamera()
    end)
	DisplayNotification("To enter News cam press ~INPUT_PICKUP~ \nTo Enter Movie Cam press ~INPUT_VEH_HEADLIGHT~")
end

function EnterMic()
    exports.emotes:PerformEmote(Config.Mic.Anim)
end

function EnterBoomMic()
    exports.emotes:PerformEmote(Config.BoomMic.Anim)
end