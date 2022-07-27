-- TODO: Transform variables to uppercase
local cams = {}
local currentCam = -1

exports("CreateCam", function(_type)
	local cam = {}
	cam.cam = CreateCam(_type or "DEFAULT_SCRIPTED_CAMERA", false)
	cam.pos = vector3(0, 0, 0)
	cam.rot = vector3(0, 0, 0)
	cam.fov = 45
	cam.shake = 0.4
	cam.active = true

	local handler = {}
	handler.id = #cams + 1

	function handler:Set(key, value)
		cams[self.id][key] = value
	end

	function handler:Get(key)
		return cams[self.id][key]
	end

	function handler:Activate()
		local cam = cams[self.id]
		SetCamActive(cam.cam, true)
		ShakeCam(cam.cam, "HAND_SHAKE", cam.shake)
		RenderScriptCams(true, false, 0, 1, 0)

		currentCam = self.id
	end

	function handler:Deactivate()
		local cam = cams[self.id]
		cam.active = false
		
		if currentCam == self.id then
			RenderScriptCams(false, false, 0, 1, 0)
		end
		
		cams[self.id] = nil
	end
	
	cams[handler.id] = cam
	
	Citizen.CreateThread(function()
		local cam = cams[handler.id]

		while cam.active and DoesCamExist(cam.cam) do
			Citizen.Wait(0)

			SetCamCoord(cam.cam, cam.pos)
			SetCamRot(cam.cam, cam.rot)
			SetCamFov(cam.cam, cam.fov)
		end

		SetCamActive(cam.cam, false)
		DestroyCam(cam.cam)
	end)

	return handler
end)